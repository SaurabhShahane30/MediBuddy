import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:medibuddy/localisation/locales.dart';

class LocatePharmaciesPage extends StatelessWidget {
  Future<void> _searchPharmacies() async {
    final Uri url = Uri.parse("https://www.google.com/maps/search/pharmacies+near+me");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch Google Maps search';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.locatepharmacy.getString(context)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Out of Stock Section
            Text(LocaleData.outofstock.getString(context),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Image.asset("assets/tablets.png", width: 40, height: 40), // Change image path
                  SizedBox(width: 10),
                  Text(
                    "Medicine 1",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Locate Pharmacies Section
            Center(
              child: ElevatedButton.icon(
                onPressed: _searchPharmacies,
                icon: Icon(Icons.location_on),
                label: Text(LocaleData.findnearbypharmacy.getString(context)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}