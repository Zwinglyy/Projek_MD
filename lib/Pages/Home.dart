import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'transportation_page.dart';
import 'electricity_page.dart';
import 'package:emisi_md/api_service_.dart';
import 'package:url_launcher/url_launcher.dart';

class _CircleClipper extends CustomClipper<Path> {
  final double percentage;

  _CircleClipper(this.percentage);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2));

    double fillHeight = (size.height * percentage) / 100;
    path.addRect(
        Rect.fromLTRB(0, size.height - fillHeight, size.width, size.height));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ApiService apiService;
  Map<String, dynamic>? summaryData;
  Map<String, double> categoryPercentages = {};
  bool isLoading = true;
  Map<String, double> percentageData = {};
  Map<String, double> emissionData = {};

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _fetchSummaryData();
    _fetchPercentageData();
    _fetchEmissionData();
  }

  _fetchSummaryData() async {
    try {
      final data = await apiService.getTotalEmisiForUser(userId: widget.userId);
      setState(() {
        summaryData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  _fetchPercentageData() async {
    try {
      final data = await apiService.percentageCPT(userId: widget.userId);
      print("Fetched percentage data: $data");

      setState(() {
        data['electricPower']?.forEach((id, value) {
          print("Electric Power $id: ${value['percentage']}");
          percentageData[id] =
              double.tryParse(value['percentage'].toString()) ?? 0.0;
        });

        data['transport']?.forEach((id, value) {
          print("Transport $id: ${value['percentage']}");
          percentageData[id] =
              double.tryParse(value['percentage'].toString()) ?? 0.0;
        });
      });
    } catch (e) {
      print("Error fetching percentage data: $e");
    }
  }

  _fetchEmissionData() async {
    try {
      final data =
          await apiService.getTotalCarbonEmission(userId: widget.userId);
      print("Fetched emission data: $data"); // Print the fetched data

      // Check the structure of the data
      if (data is Map) {
        // If it's a Map, let's print the keys to inspect it
        print("Data is a Map with keys: ${data.keys}");
      }

      setState(() {
        // Assuming data contains a key like 'entries' that holds the emission list
        if (data is Map && data['entries'] != null) {
          emissionData = {
            for (var entry
                in data['entries']) // Adjust this according to actual structure
              entry['id']: double.tryParse(entry['totalEmission']) ?? 0.0
          };
        } else {
          print("Emission data is not in expected format.");
        }
      });
    } catch (e) {
      print("Error fetching emission data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: Icon(MdiIcons.refresh), // Refresh Icon
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _fetchSummaryData(); // Refresh the summary data
              _fetchPercentageData(); // Refresh the percentage data
              _fetchEmissionData(); // Refresh the emission data
            },
          ),
        ],
      ),
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
                            userId: widget.userId,
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
                            userId: widget.userId,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Article(),
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
            style: GoogleFonts.poppins(
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
                icons[index]['id'],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryIcon(
      IconData icon, String label, double screenWidth, String id) {
    double percentage = percentageData[id] ?? 0.0;
    double emission = emissionData[id] ?? 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: screenWidth < 600 ? 12 : 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade100,
              ),
            ),
            ClipPath(
              clipper: _CircleClipper(percentage),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.shade700,
                ),
              ),
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${percentage.toStringAsFixed(1)}%', // Display percentage
          style:
              GoogleFonts.poppins(fontSize: 12, color: Colors.green.shade700),
        ),
        const SizedBox(height: 4),
        Text(
          '${emission.toStringAsFixed(2)} kg CO2', // Display emission
          style:
              GoogleFonts.poppins(fontSize: 12, color: Colors.green.shade700),
        ),
      ],
    );
  }

  Widget Article() {
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
          Text(
            "Article",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pengertian Carbon Emission",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              GestureDetector(
                onTap: () async {
                  const url =
                      'https://pgnlng.co.id/berita/wawasan/emisi-karbon/#:~:text=Pengertian%20Emisi%20Karbon&text=Dalam%20hal%20ini%2C%20emisi%20karbon,lepasnya%20gas%20CO2%20ke%20atmosfer.';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text(
                  "Click Here",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
  {
    'icon': MdiIcons.lightbulbOutline,
    'label': 'Lamps',
    'id': 'CPT-ElectricPower-1'
  },
  {
    'icon': MdiIcons.fridgeOutline,
    'label': 'Refrigerator',
    'id': 'CPT-ElectricPower-2'
  },
  {
    'icon': MdiIcons.airConditioner,
    'label': 'Air Conditioner',
    'id': 'CPT-ElectricPower-3'
  },
  {
    'icon': MdiIcons.television,
    'label': 'Television',
    'id': 'CPT-ElectricPower-4'
  },
  {
    'icon': MdiIcons.washingMachine,
    'label': 'Washing Machine',
    'id': 'CPT-ElectricPower-5'
  },
];
