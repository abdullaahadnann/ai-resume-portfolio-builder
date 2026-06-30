class Constants {
  // Your FastAPI backend URL
  // Use 10.0.2.2 instead of localhost when testing on Android emulator
  static const String baseUrl = "http://192.168.2.74:8000";

  // API endpoints
  static const String registerUrl = '$baseUrl/auth/register';
  static const String loginUrl = '$baseUrl/auth/login';
  static const String resumeUrl = '$baseUrl/resume/';
  static const String getResumeUrl = '$baseUrl/resume/me';
  static const String generateResumeUrl = '$baseUrl/ai/generate-resume';
  static const String generatePortfolioUrl = '$baseUrl/ai/generate-portfolio';
  static const String matchJobUrl = '$baseUrl/ai/match-job';
  static const String atsScoreUrl = '$baseUrl/ai/ats-score';
}
