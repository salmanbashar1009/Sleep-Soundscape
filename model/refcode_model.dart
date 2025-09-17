class refcode {
  bool? success;
  String? referralCode;

  refcode({this.success, this.referralCode});

  refcode.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    referralCode = json['referralCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['referralCode'] = this.referralCode;
    return data;
  }
}