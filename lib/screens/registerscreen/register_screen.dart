import 'package:flutter/material.dart';
import 'package:noviindus_ayurvedic/widgets/textfield_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController executivecontroller = TextEditingController();
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController addresscontroller = TextEditingController();

  // Payment choice
  String selectedPayment = "Cash";

  // Dropdown values
  String? selectedLocation;
  String? selectedBranch;
  String? selectedTreatment;

  final List<String> locations = ["Kochi", "Calicut", "Trivandrum"];
  final List<String> branches = ["Kumarakom", "Kottayam", "Ernakulam"];
  final List<String> treatments = [
    "Head Massage",
    "Ayurvedic Therapy",
    "Panchakarma",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Patient')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(label: "Name", controller: namecontroller),
            CustomTextField(
              label: "Executive",
              controller: executivecontroller,
            ),
            CustomTextField(label: "Phone Number", controller: phonecontroller),
            CustomTextField(
              label: "Address",
              controller: addresscontroller,
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            /// Payment Choice Chips
            const Text(
              "Payment Method",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: ["Cash", "Card", "UPI"].map((method) {
                return ChoiceChip(
                  label: Text(method),
                  selected: selectedPayment == method,
                  onSelected: (selected) {
                    setState(() => selectedPayment = method);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// Location Dropdown
            const Text(
              "Location",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: selectedLocation,
              hint: const Text("Select Location"),
              items: locations.map((loc) {
                return DropdownMenuItem(value: loc, child: Text(loc));
              }).toList(),
              onChanged: (val) => setState(() => selectedLocation = val),
            ),
            const SizedBox(height: 20),

            /// Branch Dropdown
            const Text("Branch", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: selectedBranch,
              hint: const Text("Select Branch"),
              items: branches.map((branch) {
                return DropdownMenuItem(value: branch, child: Text(branch));
              }).toList(),
              onChanged: (val) => setState(() => selectedBranch = val),
            ),
            const SizedBox(height: 20),

            /// Treatment Dropdown
            const Text(
              "Treatment",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: selectedTreatment,
              hint: const Text("Select Treatment"),
              items: treatments.map((treat) {
                return DropdownMenuItem(value: treat, child: Text(treat));
              }).toList(),
              onChanged: (val) => setState(() => selectedTreatment = val),
            ),
            const SizedBox(height: 30),

            /// Register Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Register button pressed")),
                  );
                },
                child: const Text("Register", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
