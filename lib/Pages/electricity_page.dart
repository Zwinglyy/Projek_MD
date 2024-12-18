import 'package:flutter/material.dart';
import 'package:emisi_md/api_service_.dart';

class ElectricityPage extends StatefulWidget {
  final String title;
  final String electricityId;
  final String userId;

  const ElectricityPage({
    Key? key,
    required this.title,
    required this.electricityId,
    required this.userId,
  }) : super(key: key);

  @override
  State<ElectricityPage> createState() => _ElectricityPageState();
}

class _ElectricityPageState extends State<ElectricityPage> {
  final TextEditingController _durationController = TextEditingController();
  bool _isSubmitting = false;
  final ApiService _apiService = ApiService();

  Future<void> _submitDuration() async {
    final durationText = _durationController.text;

    if (durationText.isEmpty || double.tryParse(durationText) == null || double.parse(durationText) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid positive number for duration.")),
      );
      return;
    }

    final duration = double.parse(durationText);
    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await _apiService.postCarbonProduced(
        dateTime: DateTime.now().toIso8601String(),
        userId: widget.userId,
        carbonProducedTypeId: "CPT-ElectricPower",
        cptElectricpowId: widget.electricityId,
        duration: duration,
      );

      if (response['status'] == "SUCCESS") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Duration submitted successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['msg'] ?? "Failed to submit duration. Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How long (in Hours) did you turn on the ${widget.title}?",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter duration (Hr)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitDuration,
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }
}