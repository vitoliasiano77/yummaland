class Constants {
  // Ganti 'your-php-server-ip' dengan IP server PHP Anda (misal: 192.168.1.100)
  // Ganti 'your-project-folder' dengan nama folder proyek PHP Anda di server
  static const String baseUrl = 'http://your-php-server-ip/your-project-folder/api';

  static const String loginEndpoint = '$baseUrl/auth/login.php';
  static const String registerEndpoint = '$baseUrl/auth/register.php';
  static const String addChildEndpoint = '$baseUrl/children/add.php';
  static const String getChildrenEndpoint = '$baseUrl/children/history.php';
  static const String updateChildEndpoint = '$baseUrl/children/update.php';
  static const String deleteChildEndpoint = '$baseUrl/children/delete.php';
  static const String getAllUsersEndpoint = '$baseUrl/admin/users.php';
  static const String updateUserEndpoint = '$baseUrl/admin/update_user.php';
  static const String deleteUserEndpoint = '$baseUrl/admin/delete_user.php';
  static const String processPaymentEndpoint = '$baseUrl/payments/process.php';
  static const String getTopScoresEndpoint = '$baseUrl/children/top_scores.php';
}