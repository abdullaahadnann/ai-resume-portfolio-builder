import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ResumeFormScreen extends StatefulWidget {
  final Map<String, dynamic>? existingResume;
  const ResumeFormScreen({super.key, this.existingResume});

  @override
  State<ResumeFormScreen> createState() => _ResumeFormScreenState();
}

class _ResumeFormScreenState extends State<ResumeFormScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final summaryController = TextEditingController();
  final educationController = TextEditingController();
  final experienceController = TextEditingController();
  final skillsController = TextEditingController();

  bool isLoading = false;
  String message = '';

  @override
  void initState() {
    super.initState();
    // If resume exists, pre-fill the form
    if (widget.existingResume != null) {
      fullNameController.text = widget.existingResume!['full_name'] ?? '';
      emailController.text = widget.existingResume!['email'] ?? '';
      phoneController.text = widget.existingResume!['phone'] ?? '';
      summaryController.text = widget.existingResume!['summary'] ?? '';
      educationController.text = widget.existingResume!['education'] ?? '';
      experienceController.text = widget.existingResume!['experience'] ?? '';
      skillsController.text = widget.existingResume!['skills'] ?? '';
    }
  }

  void saveResume() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    final resumeData = {
      'full_name': fullNameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'summary': summaryController.text,
      'education': educationController.text,
      'experience': experienceController.text,
      'skills': skillsController.text,
    };

    Map<String, dynamic> result;

    // If resume exists update it, otherwise create new
    if (widget.existingResume != null) {
      result = await ApiService.updateResume(resumeData);
    } else {
      result = await ApiService.createResume(resumeData);
    }

    setState(() {
      isLoading = false;
      message = result.containsKey('id')
          ? 'Resume saved successfully!'
          : 'Error saving resume';
    });

    if (result.containsKey('id')) {
      Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
    }
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Enter your $label',
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.existingResume != null ? 'Update Resume' : 'Create Resume',
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField('Full Name', fullNameController),
            _buildField('Email', emailController),
            _buildField('Phone', phoneController),
            _buildField('Summary', summaryController, maxLines: 3),
            _buildField('Education', educationController, maxLines: 3),
            _buildField('Experience', experienceController, maxLines: 4),
            _buildField('Skills', skillsController, maxLines: 2),
            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(
                  color: message.contains('success')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveResume,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Resume',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
