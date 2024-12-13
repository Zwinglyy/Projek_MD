import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: const Text('Carbon Tracker'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Bagian atas (Header)
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.green.shade400,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
            ),
            child: Center(
              child: Text(
                'Lacak Penggunaan Karbon Anda',
                style: TextStyle(
                  fontSize: screenWidth < 600 ? 18 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Grid icon dengan Responsive Layout
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori Transportasi
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Transportasi",
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
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: _transportationIcons.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryIcon(
                        _transportationIcons[index]['icon'] as IconData,
                        _transportationIcons[index]['label'] as String,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Kategori Listrik
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Listrik",
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
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: _electricityIcons.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryIcon(
                        _electricityIcons[index]['icon'] as IconData,
                        _electricityIcons[index]['label'] as String,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Card bagian bawah
          Container(
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
                  "TOTAL EMISI KARBON",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("(kategori)", style: TextStyle(fontSize: 14)),
                    const Text("(Jumlah emisi)", style: TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Saran", style: TextStyle(fontSize: 14)),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Tambahkan aksi untuk button
                      },
                      child: const Text("Lihat Detail"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.green.shade400,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label) {
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
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

// Data kategori ikon transportasi
final List<Map<String, dynamic>> _transportationIcons = [
  {'icon': MdiIcons.car, 'label': 'Mobil'},
  {'icon': MdiIcons.motorbike, 'label': 'Motor'},
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
  {'icon': MdiIcons.fridgeOutline, 'label': 'Kulkas'},
  {'icon': MdiIcons.airConditioner, 'label': 'AC'},
  {'icon': MdiIcons.lightbulbOutline, 'label': 'Lampu'},
  {'icon': MdiIcons.fire, 'label': 'Gas'},
];

void main() => runApp(MaterialApp(
  home: HomePage(),
  debugShowCheckedModeBanner: false,
));
