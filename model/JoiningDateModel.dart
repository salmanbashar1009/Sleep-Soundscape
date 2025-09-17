class JoiningDateModel {
  bool? success;
  String? joiningDate;

  JoiningDateModel({this.success, this.joiningDate});

  JoiningDateModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    joiningDate = json['joiningDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['joiningDate'] = this.joiningDate;
    return data;
  }
}
