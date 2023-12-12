import 'package:admin/screens/donations/add_donations_screen.dart';
import 'package:admin/screens/donations/components/donations.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/Donation.dart';
import '../../service/DonationApiService.dart';

class DonationScreen extends StatefulWidget {
  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final DonationApiService apiService = DonationApiService(baseUrl: 'http://localhost:7001');
  late Future<List<Map<String, dynamic>>> donations;

  @override
  void initState() {
    super.initState();
    donations = apiService.getAllDonations();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Donations'),
        ),

        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: donations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No donations available.');
            } else {
              // Clear existing donations before adding new ones
              Donation.clearDonations();
              // Populate the list of donations

            snapshot.data!.forEach((donation) {
                Donation.allDonations.add(Donation(
                  quantite: donation['quantite'] ?? 0, // Provide a default value (e.g., 0)
                  date: donation['date'] ?? '', // Provide a default value (e.g., an empty string)
                  etat: donation['etat'] ?? '',  // Provide a default value (e.g., an empty string)
                ));
              });


              return Donations();
            }
          },
        ),
      ),
    );
  }
}
