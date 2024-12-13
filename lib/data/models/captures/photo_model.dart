class PhotoModel {
  final num bkId;
  final num cntId;
  final String typePicture;
  final String subTypePicture;
  final String url;
  final String date;
  final num user;

  PhotoModel(this.bkId, this.cntId, this.typePicture, this.subTypePicture,
      this.url, this.date, this.user);

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
        num.tryParse(json['MbBkId'].toString()) ?? 0,
        num.tryParse(json['MbCntId'].toString()) ?? 0,
        json['MbPcTypePicture'] ?? '',
        json['MbPcSubTypePicture'] ?? '',
        json['MbPcLinkDirectory'] ?? '',
        json['SecDateCreate'] ?? '',
        num.tryParse(json['UsrCreate'].toString()) ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'MbBkId': bkId,
      'MbCntId': cntId,
      'MbPcTypePicture': typePicture,
      'MbPcSubTypePicture': subTypePicture,
      'MbPcLinkDirectory': url,
      'SecDateCreate': date,
      'UsrCreate': date,
    };
  }

  @override
  String toString() {
    return 'PhotoModel{'
        'MbBkId: $bkId,'
        'MbCntId: $cntId,'
        'MbPcTypePicture: $typePicture,'
        'MbPcSubTypePicture: $subTypePicture,'
        'MbPcLinkDirectory: $url,'
        'SecDateCreate: $date,'
        'UsrCreate: $date,';
  }
}
