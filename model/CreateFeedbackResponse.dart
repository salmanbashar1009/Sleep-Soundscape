class CreateFeedbackResponse {
  bool? success;
  String? message;
  Feedback? feedback;

  CreateFeedbackResponse({this.success, this.message, this.feedback});

  CreateFeedbackResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    feedback = json['feedback'] != null
        ? new Feedback.fromJson(json['feedback'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.feedback != null) {
      data['feedback'] = this.feedback!.toJson();
    }
    return data;
  }
}

class Feedback {
  String? user;
  int? reading;
  String? emoji;
  String? category;
  String? description;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Feedback(
      {this.user,
        this.reading,
        this.emoji,
        this.category,
        this.description,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Feedback.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    reading = json['reading'];
    emoji = json['emoji'];
    category = json['category'];
    description = json['description'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['reading'] = this.reading;
    data['emoji'] = this.emoji;
    data['category'] = this.category;
    data['description'] = this.description;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
