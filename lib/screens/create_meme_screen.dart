import 'package:flutter/material.dart';
import 'template_screen.dart';

class CreateMemeScreen extends StatefulWidget {
  const CreateMemeScreen({super.key});

  @override
  State<CreateMemeScreen> createState() => _CreateMemeScreenState();
}

class _CreateMemeScreenState extends State<CreateMemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Meme")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              context,
              label: "Create with Latest Templates",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TemplateScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              context,
              label: "Create from Gallery",
              onPressed: () {
                // Implement your image picker logic here
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 3,
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }
}
