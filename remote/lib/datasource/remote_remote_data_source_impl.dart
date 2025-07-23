import 'dart:convert';
import 'dart:io';

import 'package:data/data.dart';
import 'package:domain/model/lotto/my_lotto_dto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SettingRemoteDataSourceImpl extends SettingRemoteDataSource {
  SettingRemoteDataSourceImpl();

  @override
  Future<int> backupMyNumbersToiCloud({
    required List<MyLottoDto> myLottoNumbers,
    required Function(String? message) onError,
  }) async {
    // todo : iCloud에 백업
    return 0;
  }

  @override
  Future<int> backupMyNumbersToGoogleDrive({
    required List<MyLottoDto> myLottoNumbers,
    required Function(String? message) onError,
  }) async {
    const fileName = 'my_numbers.json';
    final file = await _getJsonFile(fileName: fileName, myLottoNumbers: myLottoNumbers);

    final client = await _signInWithGoogle(onError: onError);
    if (client == null) return 0;
    final driveApi = drive.DriveApi(client);
    final parentId = await _getParentDirId(driveApi: driveApi, folderName: 'lottoz');

    final media = drive.Media(file.openRead(), file.lengthSync());
    final driveFile = drive.File()
      ..name = fileName
      ..parents = [parentId];

    await driveApi.files.create(driveFile, uploadMedia: media);
    return myLottoNumbers.length;
  }

  @override
  Future<List<MyLottoDto>> restoreMyNumbersFromiCloud({
    required Function(String? message) onError,
  }) async {
    // todo : iCloud에서 가져오기
    return [];
  }

  @override
  Future<List<MyLottoDto>> restoreMyNumbersFromGoogleDrive({
    required Function(String? message) onError,
  }) async {
    const fileName = 'my_numbers.json';

    final client = await _signInWithGoogle(onError: onError);
    if (client == null) return [];
    final driveApi = drive.DriveApi(client);
    final parentId = await _getParentDirId(driveApi: driveApi, folderName: 'lottoz');

    final query = "name = '$fileName' and '$parentId' in parents and trashed = false";
    final res = await driveApi.files.list(q: query, spaces: 'drive');
    drive.File? file;
    if (res.files != null && res.files!.isNotEmpty) {
      file = res.files!.first;
    }

    if (file == null) {
      onError('백업된 파일이 없습니다.');
      return [];
    }

    final media =
        await driveApi.files.get(file.id!, downloadOptions: drive.DownloadOptions.fullMedia)
            as drive.Media;

    final content = await media.stream.transform(utf8.decoder).join();
    final list = jsonDecode(content) as List;
    final myLottoNumbers = list.map((e) => MyLottoDto.fromJson(e)).toList();
    return myLottoNumbers;
  }

  Future<File> _getJsonFile({
    required String fileName,
    required List<MyLottoDto> myLottoNumbers,
  }) async {
    final json = jsonEncode(myLottoNumbers.map((lotto) => lotto.toJson()).toList());
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(json);
    return file;
  }

  Future<auth.AuthClient?> _signInWithGoogle({required Function(String? message) onError}) async {
    final googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveFileScope]);
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    final token = googleAuth?.accessToken;

    if (token == null) {
      await googleSignIn.signOut();
      onError(null);
      return null;
    }

    final credentials = auth.AccessCredentials(
      auth.AccessToken('Bearer', token, DateTime.now().toUtc().add(const Duration(hours: 1))),
      null,
      [drive.DriveApi.driveFileScope],
    );
    return auth.authenticatedClient(http.Client(), credentials);
  }

  Future<String> _getParentDirId({
    required drive.DriveApi driveApi,
    required String folderName,
  }) async {
    final rootId = await _getOrCreateFolder(driveApi: driveApi, folderName: 'lottoz');
    final subFolderId = await _getOrCreateFolder(
      driveApi: driveApi,
      folderName: 'backup',
      parentId: rootId,
    );
    return subFolderId;
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
}
