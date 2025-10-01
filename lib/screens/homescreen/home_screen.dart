import 'package:flutter/material.dart';
import 'package:noviindus_ayurvedic/provider/patient_provider.dart';
import 'package:noviindus_ayurvedic/screens/registerscreen/register_screen.dart';
import 'package:noviindus_ayurvedic/widgets/booking_card.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PatientProvider>(
        context,
        listen: false,
      ).Fetchpatients(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: const Text("Patients")),
      body: Consumer<PatientProvider>(
        builder: (context, provider, child) {
          if (provider.isloading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errormessagel != null) {
            return Center(child: Text(provider.errormessagel!));
          }
          if (provider.patients.isEmpty) {
            return const Center(child: Text("No patients found"));
          }

          return RefreshIndicator(
            onRefresh: () => provider.Fetchpatients(widget.token),
            child: ListView.builder(
              itemCount: provider.patients.length,
              itemBuilder: (context, index) {
                final patient = provider.patients[index];

                return BookingCard(
                  index: index + 1,
                  patientName: patient.name,
                  treatmentName: patient.treatmentDetails.isNotEmpty
                      ? patient.treatmentDetails.first.treatmentName
                      : "No treatment",
                  bookingDate: patient.dateTime,
                  therapistName: patient.branch.name,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Viewing ${patient.name} details"),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: height * 0.08,
          width: width * 0.8,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterScreen(token: widget.token),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 7, 115, 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: const Text(
              "Register Now",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
