class AddSoundDataModel {
  bool? success;
  String? message;
  Sound? sound;

  AddSoundDataModel({this.success, this.message, this.sound});

  AddSoundDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    sound = json['sound'] != null ? new Sound.fromJson(json['sound']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.sound != null) {
      data['sound'] = this.sound!.toJson();
    }
    return data;
  }
}

class Sound {
  String? id;
  String? category;
  String? title;
  String? subtitle;
  String? imagePath;
  String? audioPath;

  Sound(
      {this.id,
        this.category,
        this.title,
        this.subtitle,
        this.imagePath,
        this.audioPath});

  Sound.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    title = json['title'];
    subtitle = json['subtitle'];
    imagePath = json['imagePath'];
    audioPath = json['audioPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['imagePath'] = this.imagePath;
    data['audioPath'] = this.audioPath;
    return data;
  }
}
