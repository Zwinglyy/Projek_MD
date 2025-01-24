import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:emisi_md/api_service_.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carbon Emission Articles',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          _buildArticleItem(
            'The Impact of Carbon Emissions on Global Warming',
            'January 24, 2025',
            'An exploration of how increasing carbon emissions are contributing to global warming and its consequences for the planet.',
            context,
          ),
          _buildArticleItem(
            'Reducing Carbon Footprints: A Guide for Individuals',
            'January 23, 2025',
            'This article covers the most effective ways individuals can reduce their carbon footprints through lifestyle changes and mindful consumption.',
            context,
          ),
          _buildArticleItem(
            'Corporate Responsibility and Carbon Emissions',
            'January 22, 2025',
            'Corporate entities play a critical role in reducing global carbon emissions. This article discusses how businesses can adopt green practices.',
            context,
          ),
          _buildArticleItem(
            'Renewable Energy and Its Role in Combating Carbon Emissions',
            'January 20, 2025',
            'How renewable energy sources like wind and solar power are crucial in reducing carbon emissions and moving towards a sustainable future.',
            context,
          ),
          _buildArticleItem(
            'The Role of Governments in Mitigating Carbon Emissions',
            'January 19, 2025',
            'Governments around the world are implementing policies to combat climate change by reducing carbon emissions. This article explores various policies.',
            context,
          ),
        ],
      ),
    );
  }

  // Helper function to build an article item
  Widget _buildArticleItem(String title, String date, String summary, BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 8.0),
            Text(
              summary,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),

      ),
    );
  }
}
