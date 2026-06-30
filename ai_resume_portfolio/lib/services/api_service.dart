import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ApiService {
  // Save JWT token to phone storage
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Get JWT token from phone storage
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Delete token when user logs out
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Register a new user
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse(Constants.registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // Login user and save token
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(Constants.loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveToken(data['access_token']);
      return true;
    }
    return false;
  }

  // Create resume
  static Future<Map<String, dynamic>> createResume(
    Map<String, dynamic> resumeData,
  ) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse(Constants.resumeUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(resumeData),
    );
    return jsonDecode(response.body);
  }

  // Get my resume
  static Future<Map<String, dynamic>> getResume() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(Constants.getResumeUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // Generate AI resume
  static Future<Map<String, dynamic>> generateResume() async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse(Constants.generateResumeUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // Generate AI portfolio
  static Future<Map<String, dynamic>> generatePortfolio() async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse(Constants.generatePortfolioUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // Match job description
  static Future<Map<String, dynamic>> matchJob(String jobDescription) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse(Constants.matchJobUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'job_description': jobDescription}),
    );
    return jsonDecode(response.body);
  }

  // Check ATS score
  static Future<Map<String, dynamic>> checkAtsScore(
    String jobDescription,
  ) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse(Constants.atsScoreUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'job_description': jobDescription}),
    );
    return jsonDecode(response.body);
  }

  // Update resume
  static Future<Map<String, dynamic>> updateResume(
    Map<String, dynamic> resumeData,
  ) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse(Constants.getResumeUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(resumeData),
    );
    return jsonDecode(response.body);
  }
}
