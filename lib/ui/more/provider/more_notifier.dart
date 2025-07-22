import 'dart:convert';
import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:lottoz/ui/more/backup_type.dart';
import 'package:path_provider/path_provider.dart';

class MoreState {
  final MoreEvent? event;
  final bool isLoading;
  final int maxRound;
  final List<LottoDto> lottoNumbers;
  final int statisticsSize;

  MoreState({
    required this.event,
    required this.isLoading,
    required this.maxRound,
    required this.lottoNumbers,
    required this.statisticsSize,
  });

  factory MoreState.init() =>
      MoreState(event: null, isLoading: false, maxRound: 20, lottoNumbers: [], statisticsSize: 20);

  MoreState copyWith({
    MoreEvent? event,
    bool? isLoading,
    int? maxRound,
    List<LottoDto>? lottoNumbers,
    int? statisticsSize,
  }) => MoreState(
    event: event ?? this.event,
    isLoading: isLoading ?? this.isLoading,
    maxRound: maxRound ?? this.maxRound,
    lottoNumbers: lottoNumbers ?? this.lottoNumbers,
    statisticsSize: statisticsSize ?? this.statisticsSize,
  );
}

sealed class MoreEvent {}

class ShowSnackBar extends MoreEvent {
  final String message;

  ShowSnackBar({required this.message});
}

class MoreNotifier extends StateNotifier<MoreState> {
  final LottoRepository lottoRepository;
  final SettingRepository settingRepository;

  MoreNotifier({required this.lottoRepository, required this.settingRepository})
    : super(MoreState.init());

  fetchStatisticsSize() async {
    final lottoNumbers = await lottoRepository.getLocalLottoNumbers();
    state = state.copyWith(
      maxRound: lottoNumbers.first.drwNo,
      lottoNumbers: lottoNumbers,
      statisticsSize: await settingRepository.getStatisticsSize(),
    );
  }

  updateStatisticsSize({required int statisticsSize}) async {
    state = state.copyWith(
      statisticsSize: await settingRepository.updateStatisticsSize(statisticsSize: statisticsSize),
    );
  }

  backupMyNumbers({required BackupType backupType}) async {
    final myLottoNumbers = await lottoRepository.getMyLottoNumbers();
    final json = jsonEncode(myLottoNumbers.map((lotto) => lotto.toJson()).toList());
    final directory = await getApplicationDocumentsDirectory();
    const fileName = 'my_numbers.json';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(json);
    switch (backupType) {
      case BackupType.iCloud:
        await _uploadFileToiCloud(file: file, fileName: fileName);
        break;
      case BackupType.googleDrive:
        await _uploadFileToGoogleDrive(file: file, fileName: fileName);
        break;
    }
  }

  _uploadFileToGoogleDrive({required File file, required String fileName}) async {
    state = state.copyWith(isLoading: true);
    final client = await _signInWithGoogle();
    if (client == null) {
      _showError();
      return;
    }
    final driveApi = drive.DriveApi(client);
    final rootId = await _getOrCreateFolder(driveApi: driveApi, folderName: 'lottoz');
    final subFolderId = await _getOrCreateFolder(
      driveApi: driveApi,
      folderName: 'backup',
      parentId: rootId,
    );

    final media = drive.Media(file.openRead(), file.lengthSync());
    final driveFile = drive.File()
      ..name = fileName
      ..parents = [subFolderId];

    await driveApi.files.create(driveFile, uploadMedia: media);
    state = state.copyWith(event: ShowSnackBar(message: '백업이 완료되었습니다.'), isLoading: false);
  }

  Future<auth.AuthClient?> _signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveFileScope]);
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    final token = googleAuth?.accessToken;

    if (token == null) {
      await googleSignIn.signOut();
      _showError();
      return null;
    }

    final credentials = auth.AccessCredentials(
      auth.AccessToken('Bearer', token, DateTime.now().toUtc().add(const Duration(hours: 1))),
      null,
      [drive.DriveApi.driveFileScope],
    );
    return auth.authenticatedClient(http.Client(), credentials);
  }

  restoreFileFromGoogleDrive() async {
    state = state.copyWith(isLoading: true);
    final client = await _signInWithGoogle();
    if (client == null) {
      _showError();
      return;
    }
    final driveApi = drive.DriveApi(client);
    final rootId = await _getOrCreateFolder(driveApi: driveApi, folderName: 'lottoz');
    final subFolderId = await _getOrCreateFolder(
      driveApi: driveApi,
      folderName: 'backup',
      parentId: rootId,
    );
    final query = "name = 'my_numbers.json' and '$subFolderId' in parents and trashed = false";
    final res = await driveApi.files.list(q: query, spaces: 'drive');
    drive.File? file;

    if (res.files != null && res.files!.isNotEmpty) {
      file = res.files!.first;
    }

    if (file == null) {
      _showError(message: '백업된 파일이 없습니다.');
      return;
    }

    final media =
        await driveApi.files.get(file.id!, downloadOptions: drive.DownloadOptions.fullMedia)
            as drive.Media;

    final content = await media.stream.transform(utf8.decoder).join();
    final list = jsonDecode(content) as List;

    final myLottoNumbers = list.map((e) => MyLottoDto.fromJson(e)).toList();
    final localMyLottoNumbers = await lottoRepository.getMyLottoNumbers();
    await lottoRepository.saveMyLottoNumbers(
      myLottoNumbers: localMyLottoNumbers.removeDuplicates(myLottoNumbers),
    );
    state = state.copyWith(event: ShowSnackBar(message: '내 번호를 가져왔습니다.'), isLoading: false);
  }

  /// 특정 이름의 폴더가 없으면 생성하고, 있으면 ID 반환
  Future<String> _getOrCreateFolder({
    required drive.DriveApi driveApi,
    required String folderName,
    String? parentId,
  }) async {
    final query =
        "name = '$folderName' and mimeType = 'application/vnd.google-apps.folder' and "
        "trashed = false${parentId != null ? " and '$parentId' in parents" : ""}";

    final res = await driveApi.files.list(q: query, spaces: 'drive');
    if (res.files != null && res.files!.isNotEmpty) {
      return res.files!.first.id!;
    }

    final folder = drive.File()
      ..name = folderName
      ..mimeType = 'application/vnd.google-apps.folder'
      ..parents = parentId != null ? [parentId] : null;

    final created = await driveApi.files.create(folder);
    return created.id!;
  }

  _uploadFileToiCloud({required File file, required String fileName}) async {}

  restoreFileFromiCloud() async {}

  _showError({String? message}) {
    state = state.copyWith(
      event: ShowSnackBar(message: message ?? '오류가 발생했습니다.'),
      isLoading: false,
    );
  }

  clearEvent() {
    state = state.copyWith(event: null);
  }
}
