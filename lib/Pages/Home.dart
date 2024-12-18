import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'transportation_page.dart';
import 'electricity_page.dart';

class HomePage extends StatelessWidget {
  final String userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _buildCategorySection(
                    title: "Transportation",
                    icons: _transportationIcons,
                    screenWidth: screenWidth,
                    context: context,
                    onItemTap: (icon) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransportationPage(
                            title: icon['label'],
                            transportId: icon['id'],
                            userId:userId,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildCategorySection(
                    title: "Electricity",
                    icons: _electricityIcons,
                    screenWidth: screenWidth,
                    context: context,
                    onItemTap: (icon) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ElectricityPage(
                            title: icon['label'],
                            electricityId: icon['id'],
                            userId:userId,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          _buildSummaryCard(),
        ],
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required List<Map<String, dynamic>> icons,
    required double screenWidth,
    required BuildContext context,
    required Function(Map<String, dynamic>) onItemTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: screenWidth < 600 ? 16 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenWidth < 600 ? 3 : 5,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
          itemCount: icons.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => onItemTap(icons[index]),
              child: _buildCategoryIcon(
                icons[index]['icon'] as IconData,
                icons[index]['label'] as String,
                screenWidth,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Carbon Footprint",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("(Category)", style: TextStyle(fontSize: 14)),
              Text("(Total Emissions)", style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Task", style: TextStyle(fontSize: 14)),
              ElevatedButton(
                onPressed: () {
                  // Tambahkan aksi untuk button
                },
                child: const Text("Details"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label, double screenWidth) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green.shade100,
          child: Icon(icon, color: Colors.green.shade700, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenWidth < 600 ? 12 : 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Data kategori ikon transportasi
final List<Map<String, dynamic>> _transportationIcons = [
  {'icon': MdiIcons.car, 'label': 'Passenger Car', 'id': 'CPT-Transport-1'},
  {'icon': MdiIcons.motorbike, 'label': 'Motorcycle', 'id': 'CPT-Transport-2'},
  {'icon': MdiIcons.bus, 'label': 'Bus TransJakarta', 'id': 'CPT-Transport-3'},
  {'icon': MdiIcons.taxi, 'label': 'Taxi 4 People', 'id': 'CPT-Transport-4'},
  {'icon': MdiIcons.taxi, 'label': 'Taxi 7 People', 'id': 'CPT-Transport-5'},
  {'icon': MdiIcons.train, 'label': 'Train', 'id': 'CPT-Transport-6'},
  {'icon': MdiIcons.subway, 'label': 'MRT-Train', 'id': 'CPT-Transport-7'},
];

// Data kategori ikon listrik
final List<Map<String, dynamic>> _electricityIcons = [
  {'icon': MdiIcons.lightbulbOutline, 'label': 'Lamps', 'id': 'CPT-ElectricPower-1'},
  {'icon': MdiIcons.fridgeOutline, 'label': 'Refrigerator', 'id': 'CPT-ElectricPower-2'},
  {'icon': MdiIcons.cellphoneCharging, 'label': 'Phone Charger', 'id': 'CPT-ElectricPower-3'},
  {'icon': MdiIcons.airConditioner, 'label': 'Air Conditioner', 'id': 'CPT-ElectricPower-4'},
  {'icon': MdiIcons.fan, 'label': 'Fan', 'id': 'CPT-ElectricPower-5'},
];
