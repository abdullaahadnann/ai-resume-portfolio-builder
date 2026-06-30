import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'resume_form_screen.dart';
import 'ai_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? resume;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadResume();
  }

  void loadResume() async {
    final data = await ApiService.getResume();
    setState(() {
      resume = data.containsKey('id') ? data : null;
      isLoading = false;
    });
  }

  void logout() async {
    await ApiService.deleteToken();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('AI Resume Builder'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resume != null
                        ? 'Hello, ${resume!['full_name']}!'
                        : 'Create your resume to get started',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  // Resume card
                  _buildActionCard(
                    icon: Icons.description,
                    title: resume != null ? 'Update Resume' : 'Create Resume',
                    subtitle: 'Fill in your details',
                    color: Colors.deepPurple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ResumeFormScreen(existingResume: resume),
                      ),
                    ).then((_) => loadResume()),
                  ),
                  const SizedBox(height: 16),
                  // AI Generate Resume
                  _buildActionCard(
                    icon: Icons.auto_awesome,
                    title: 'Generate AI Resume',
                    subtitle: 'Let AI write your resume',
                    color: Colors.orange,
                    onTap: resume == null
                        ? null
                        : () async {
                            final result = await ApiService.generateResume();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AiResultsScreen(
                                  title: 'AI Generated Resume',
                                  content:
                                      result['ai_generated_resume'] ??
                                      'Error generating resume',
                                ),
                              ),
                            );
                          },
                  ),
                  const SizedBox(height: 16),
                  // AI Generate Portfolio
                  _buildActionCard(
                    icon: Icons.work,
                    title: 'Generate Portfolio',
                    subtitle: 'Create your portfolio bio',
                    color: Colors.teal,
                    onTap: resume == null
                        ? null
                        : () async {
                            final result = await ApiService.generatePortfolio();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AiResultsScreen(
                                  title: 'AI Generated Portfolio',
                                  content:
                                      result['ai_generated_portfolio'] ??
                                      'Error generating portfolio',
                                ),
                              ),
                            );
                          },
                  ),
                  const SizedBox(height: 16),
                  // Job Match
                  _buildActionCard(
                    icon: Icons.work_history,
                    title: 'Match Job Description',
                    subtitle: 'Tailor resume to a job',
                    color: Colors.blue,
                    onTap: resume == null
                        ? null
                        : () => _showJobDescriptionDialog('match'),
                  ),
                  const SizedBox(height: 16),
                  // ATS Score
                  _buildActionCard(
                    icon: Icons.score,
                    title: 'Check ATS Score',
                    subtitle: 'See how well you match',
                    color: Colors.green,
                    onTap: resume == null
                        ? null
                        : () => _showJobDescriptionDialog('ats'),
                  ),
                ],
              ),
            ),
    );
  }

  void _showJobDescriptionDialog(String type) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          type == 'match' ? 'Match Job Description' : 'Check ATS Score',
        ),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Paste the job description here...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (type == 'match') {
                final result = await ApiService.matchJob(controller.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AiResultsScreen(
                      title: 'Matched Resume',
                      content: result['matched_resume'] ?? 'Error',
                    ),
                  ),
                );
              } else {
                final result = await ApiService.checkAtsScore(controller.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AiResultsScreen(
                      title: 'ATS Score',
                      content: result['result'].toString(),
                    ),
                  ),
                );
              }
            },
            child: const Text('Analyse'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: onTap == null ? Colors.grey[100] : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: onTap == null ? Colors.grey[300]! : color.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: onTap == null ? Colors.grey : color, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: onTap == null ? Colors.grey : Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: onTap == null ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: onTap == null ? Colors.grey[300] : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
