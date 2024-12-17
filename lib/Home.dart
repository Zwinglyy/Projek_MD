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
                  // Kategori Transportasi
                  _buildCategorySection(
                    title: "Transportation",
                    icons: _transportationIcons,
                    screenWidth: screenWidth,
                    context: context,
                    targetPage: TransportationPage(),
                  ),
                  const SizedBox(height: 20),
                  // Kategori Listrik
                  _buildCategorySection(
                    title: "Electricity",
                    icons: _electricityIcons,
                    screenWidth: screenWidth,
                    context: context,
                    targetPage: ElectricityPage(),
                  ),
                ],
              ),
            ),
          ),
          // Card bagian bawah
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
    required Widget targetPage,
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
            return _buildCategoryIcon(
              icons[index]['icon'] as IconData,
              icons[index]['label'] as String,
              screenWidth,
              context,
              targetPage,
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

  Widget _buildCategoryIcon(
      IconData icon,
      String label,
      double screenWidth,
      BuildContext context,
      Widget targetPage,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Column(
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
              fontSize: screenWidth < 600 ? 12 : 14, // Ukuran font responsif
              fontWeight: FontWeight.w500, // Kontrol ketebalan teks
            ),
          ),
        ],
      ),
    );
  }
}

// Data kategori ikon transportasi
final List<Map<String, dynamic>> _transportationIcons = [
  {'icon': MdiIcons.car, 'label': 'Car'},
  {'icon': MdiIcons.motorbike, 'label': 'Motorcycle'},
  {'icon': MdiIcons.bus, 'label': 'Big Bus'},
  {'icon': MdiIcons.busClock, 'label': 'Medium Bus'},
  {'icon': MdiIcons.busArticulatedEnd, 'label': 'Mini Bus'},
  {'icon': MdiIcons.taxi, 'label': 'Taxi'},
  {'icon': MdiIcons.truck, 'label': 'Big Truck'},
  {'icon': MdiIcons.truckDelivery, 'label': 'Medium Truck'},
  {'icon': MdiIcons.truckTrailer, 'label': 'Mini Truck'},
  {'icon': MdiIcons.train, 'label': 'Train'},
  {'icon': MdiIcons.subway, 'label': 'MRT-Train'},
];

// Data kategori ikon listrik
final List<Map<String, dynamic>> _electricityIcons = [
  {'icon': MdiIcons.fridgeOutline, 'label': 'Refrigerator'},
  {'icon': MdiIcons.airConditioner, 'label': 'Air Conditioner'},
  {'icon': MdiIcons.lightbulbOutline, 'label': 'Lamps'},
  {'icon': MdiIcons.cellphoneCharging, 'label': 'Phone Charger'},
];
