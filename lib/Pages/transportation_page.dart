import 'package:flutter/material.dart';
import 'package:emisi_md/api_service_.dart';

class TransportationPage extends StatefulWidget {
  final String title;
  final String transportId;
  final String userId;

  const TransportationPage({
    Key? key,
    required this.title,
    required this.transportId,
    required this.userId,
  }) : super(key: key);

  @override
  State<TransportationPage> createState() => _TransportationPageState();
}

class _TransportationPageState extends State<TransportationPage> {
  final TextEditingController _distanceController = TextEditingController();
  bool _isSubmitting = false;
  final ApiService _apiService = ApiService();

  Future<void> _submitDistance() async {
    final distanceText = _distanceController.text;

    if (distanceText.isEmpty || double.tryParse(distanceText) == null || double.parse(distanceText) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid positive number for distance.")),
      );
      return;
    }

    final distance = double.parse(distanceText);
    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await _apiService.postCarbonProduced(
        dateTime: DateTime.now().toIso8601String(),
        userId: widget.userId,
        carbonProducedTypeId: "CPT-Transport",
        cptTransportId: widget.transportId,
        distance: distance,
      );

      if (response['status'] == "SUCCESS") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Distance submitted successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['msg'] ?? "Failed to submit distance. Please try again.")),
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
              "How far did you travel today (in Kilometers) using ${widget.title}?",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _distanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter distance (km)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitDistance,
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
    _distanceController.dispose();
    super.dispose();
  }
}
