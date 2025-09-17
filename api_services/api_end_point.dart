class AppUrls {
  AppUrls();

  //https://energy-backend.ddns.net

  static const String baseUrl = 'http://192.168.40.10:1000';
  //'http://46.202.164.243:3000';

  //'http://192.168.40.10:1000';
  // static const String baseUrl = 'http://192.168.40.25:1000';

  //'https://dependent-boxes-eh-mandate.trycloudflare.com';
  static String sound(String category) =>
      '$baseUrl/api/sounds/filterSounds?category=$category';
  static String musicSearch(String search) =>
      '$baseUrl/api/sounds/filterSounds?search=$search';
  static String getSounds({required int page, required int limit}) =>
      '$baseUrl/api/sounds/getSounds?page=$page&limit=$limit';
  static String forgotPassword = '$baseUrl/api/users/forgot-password';
  static String loginUrl = '$baseUrl/api/users/logIn';
  static String signUp = '$baseUrl/api/users/signup';
  static String changePassword = '$baseUrl/api/users/reset-password';
  static String editProfile = '$baseUrl/api/users/update-user';
  static String feedbackCreate = '$baseUrl/api/feedback/create';
  static String refCode = '$baseUrl/api/users/referral-code';
  static String joiningDate = '$baseUrl/api/users/joining-date';
  static String resetPassword = '$baseUrl/api/users/change-password';
  static String setGoalUrl = '$baseUrl/api/users/set-goal';
  static String getGoalUrl = '$baseUrl/api/users/get-goal';
  static String deleteUser = '$baseUrl/api/users/get-goal';
  static String allMusic(int page, int limit) =>
      '$baseUrl/api/sounds/getSounds?page=$page&limit=$limit';
  static String addSound = '$baseUrl/api/users/delete-user';

  static String deleteAccount = '$baseUrl/api/users/delete-user';
}
