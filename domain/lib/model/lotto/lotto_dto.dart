class LottoDto {
  final int bnusNo;
  final int drwNo;
  final String drwNoDate;
  final int drwtNo1;
  final int drwtNo2;
  final int drwtNo3;
  final int drwtNo4;
  final int drwtNo5;
  final int drwtNo6;
  final double firstAccumamnt;
  final int firstPrzwnerCo;
  final double firstWinamnt;
  final String returnValue;
  final double totSellamnt;

  LottoDto({
    required this.bnusNo,
    required this.drwNo,
    required this.drwNoDate,
    required this.drwtNo1,
    required this.drwtNo2,
    required this.drwtNo3,
    required this.drwtNo4,
    required this.drwtNo5,
    required this.drwtNo6,
    required this.firstAccumamnt,
    required this.firstPrzwnerCo,
    required this.firstWinamnt,
    required this.returnValue,
    required this.totSellamnt,
  });

  const LottoDto.init({
    this.bnusNo = 0,
    this.drwNo = 0,
    this.drwNoDate = '',
    this.drwtNo1 = 0,
    this.drwtNo2 = 0,
    this.drwtNo3 = 0,
    this.drwtNo4 = 0,
    this.drwtNo5 = 0,
    this.drwtNo6 = 0,
    this.firstAccumamnt = 0,
    this.firstPrzwnerCo = 0,
    this.firstWinamnt = 0,
    this.returnValue = '',
    this.totSellamnt = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'bnusNo': bnusNo,
      'drwNo': drwNo,
      'drwNoDate': drwNoDate,
      'drwtNo1': drwtNo1,
      'drwtNo2': drwtNo2,
      'drwtNo3': drwtNo3,
      'drwtNo4': drwtNo4,
      'drwtNo5': drwtNo5,
      'drwtNo6': drwtNo6,
      'firstAccumamnt': firstAccumamnt,
      'firstPrzwnerCo': firstPrzwnerCo,
      'firstWinamnt': firstWinamnt,
      'returnValue': returnValue,
      'totSellamnt': totSellamnt,
    };
  }

  int get sum => drwtNo1 + drwtNo2 + drwtNo3 + drwtNo4 + drwtNo5 + drwtNo6;

  List<int> get numbers => [drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6];
}
