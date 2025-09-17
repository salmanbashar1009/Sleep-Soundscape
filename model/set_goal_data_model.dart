class SetGoalDataModel {
  bool? success;
  String? message;
  List<Goals>? goals;

  SetGoalDataModel({this.success, this.message, this.goals});

  SetGoalDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['goals'] != null) {
      goals = <Goals>[];
      json['goals'].forEach((v) {
        goals!.add(new Goals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.goals != null) {
      data['goals'] = this.goals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Goals {
  String? userGoals;
  String? goalDescriptions;
  String img = '';

  Goals({this.userGoals, this.goalDescriptions,   required this.img});

  Goals.fromJson(Map<String, dynamic> json) {
    userGoals = json['userGoals'];
    goalDescriptions = json['goalDescriptions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userGoals'] = this.userGoals;
    data['goalDescriptions'] = this.goalDescriptions;
    return data;
  }
}
