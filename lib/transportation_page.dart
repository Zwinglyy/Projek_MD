import 'package:flutter/material.dart';

class TransportationPage extends StatelessWidget {
  const TransportationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController distanceController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transportation Details"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How far did you travel today (in kilometers)?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: distanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter distance (km)",
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
                        "You entered ${distanceController.text} km traveled."),
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
