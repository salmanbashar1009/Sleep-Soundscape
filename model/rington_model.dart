class RingTonModel {
  final String name;
  final String path;

  RingTonModel({required this.name, required this.path});

  // Factory method to convert JSON (Map) to Model
  factory RingTonModel.fromJson(Map<String, String> json) {
    return RingTonModel(
      name: json["name"]!,
      path: json["path"]!,
    );
  }

  // Method to convert Model to JSON (Map)
  Map<String, String> toJson() {
    return {
      "name": name,
      "path": path,
    };
  }
}
