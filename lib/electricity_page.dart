import 'package:flutter/material.dart';

class ElectricityPage extends StatelessWidget {
  const ElectricityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController usageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Electricity Details"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How many hours did you use the device today?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter usage time (hours)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Aksi saat button diklik
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "You entered ${usageController.text} hours of usage."),
                  ),
                );
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
