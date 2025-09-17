class DownloadModel {
  bool? success;
  List<Sounds>? sounds;
  int? totalSounds;
  int? currentPage;
  int? totalPages;
  bool? hasMore;

  DownloadModel(
      {this.success,
        this.sounds,
        this.totalSounds,
        this.currentPage,
        this.totalPages,
        this.hasMore});

  DownloadModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['sounds'] != null) {
      sounds = <Sounds>[];
      json['sounds'].forEach((v) {
        sounds!.add(new Sounds.fromJson(v));
      });
    }
    totalSounds = json['totalSounds'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    hasMore = json['hasMore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.sounds != null) {
      data['sounds'] = this.sounds!.map((v) => v.toJson()).toList();
    }
    data['totalSounds'] = this.totalSounds;
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['hasMore'] = this.hasMore;
    return data;
  }
}

class Sounds {
  String? sId;
  String? category;
  String? title;
  String? subtitle;
  String? imagePath;
  String? audioPath;
  int? iV;

  Sounds(
      {this.sId,
        this.category,
        this.title,
        this.subtitle,
        this.imagePath,
        this.audioPath,
        this.iV});

  Sounds.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    category = json['category'];
    title = json['title'];
    subtitle = json['subtitle'];
    imagePath = json['imagePath'];
    audioPath = json['audioPath'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['category'] = this.category;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['imagePath'] = this.imagePath;
    data['audioPath'] = this.audioPath;
    data['__v'] = this.iV;
    return data;
  }
}
