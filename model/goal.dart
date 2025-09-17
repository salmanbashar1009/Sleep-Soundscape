class Goals {
  final String userGoals;
  final String goalDescriptions;
  final String img;

  Goals({required this.userGoals, required this.goalDescriptions, required this.img});

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      userGoals: json["title"],
      goalDescriptions: json["description"],
      img: json["img"],
    );
  }
}
