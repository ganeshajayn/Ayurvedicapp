import 'package:flutter/material.dart';
import 'package:noviindus_ayurvedic/provider/branch_treatprovider.dart';
import 'package:noviindus_ayurvedic/widgets/textfield_widgets.dart';
import 'package:provider/provider.dart';

// Treatment model class
class Treatment {
  final String name;
  final int price;
  final String duration;

  Treatment({required this.name, required this.price, required this.duration});
}

class RegisterScreen extends StatefulWidget {
  final String token;

  const RegisterScreen({super.key, required this.token});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController executiveController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();

  // Payment choice
  String selectedPayment = "Cash";

  // Dropdown values
  String? selectedLocation;
  String? selectedBranch;
  DateTime? selectedDate;

  final List<String> locations = ["Kochi", "Calicut", "Trivandrum"];
  final List<String> branches = ["Kumarakom", "Kottayam", "Ernakulam"];
  // Remove hardcoded treatments list - will use provider data instead

  // Treatment list with male/female counts
  List<Map<String, dynamic>> selectedTreatments = [];

  void _addTreatment(String treatment) {
    setState(() {
      selectedTreatments.add({"treatment": treatment, "male": 0, "female": 0});
    });
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch branch list and treatments when screen opens
    Future.microtask(() {
      final provider = Provider.of<Brachtreatmentprovider>(
        context,
        listen: false,
      );
      provider.fetchbranches(widget.token);
      provider.fetchtreatment(widget.token);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Patient')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(label: "Name", controller: nameController),
            CustomTextField(
              label: "Executive",
              controller: executiveController,
            ),
            CustomTextField(label: "Phone Number", controller: phoneController),
            CustomTextField(
              label: "Address",
              controller: addressController,
              maxLines: 4,
            ),

            const SizedBox(height: 16),

            /// Location Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Location",
              ),
              value: selectedLocation,
              items: locations
                  .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                  .toList(),
              onChanged: (val) => setState(() => selectedLocation = val),
            ),
            const SizedBox(height: 16),

            /// Branch Dropdown
            Consumer<Brachtreatmentprovider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.errorMessage != null) {
                  return Text(provider.errorMessage!);
                }
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Branch",
                  ),
                  value: selectedBranch,
                  items: provider.branches.map((branch) {
                    return DropdownMenuItem(
                      value: branch.id.toString(),
                      child: Text(branch.name),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedBranch = val),
                );
              },
            ),
            const SizedBox(height: 16),

            /// Treatments Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Treatments",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Consumer<Brachtreatmentprovider>(
                  builder: (context, provider, child) {
                    return IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.teal),
                      onPressed: () async {
                        if (provider.treatments.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("No treatments available"),
                            ),
                          );
                          return;
                        }

                        // Open a dialog to select treatment
                        final selected = await showDialog<Map<String, dynamic>>(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text("Select Treatment"),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: provider.treatments.length,
                                  itemBuilder: (context, index) {
                                    final treatment =
                                        provider.treatments[index];
                                    return ListTile(
                                      title: Text(treatment.name),
                                      subtitle: Text(
                                        "₹${treatment.price} • ${treatment.duration}",
                                      ),
                                      onTap: () {
                                        Navigator.pop(ctx, {
                                          "treatment": treatment.name,
                                          "male": 0,
                                          "female": 0,
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );

                        if (selected != null) {
                          setState(() {
                            selectedTreatments.add(selected);
                          });
                        }
                      },
                    );
                  },
                ),
              ],
            ),

            /// Selected Treatments List
            Column(
              children: selectedTreatments.map((t) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            t["treatment"],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Row(
                          children: [
                            const Text("Male: "),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  t["male"] = (t["male"] > 0)
                                      ? t["male"] - 1
                                      : 0;
                                });
                              },
                            ),
                            Text("${t["male"]}"),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() => t["male"]++);
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Female: "),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  t["female"] = (t["female"] > 0)
                                      ? t["female"] - 1
                                      : 0;
                                });
                              },
                            ),
                            Text("${t["female"]}"),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() => t["female"]++);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            /// Amount fields
            CustomTextField(
              label: "Total Amount",
              controller: totalAmountController,
            ),
            CustomTextField(
              label: "Discount Amount",
              controller: discountController,
            ),
            CustomTextField(
              label: "Advance Amount",
              controller: advanceController,
            ),
            CustomTextField(
              label: "Balance Amount",
              controller: balanceController,
            ),

            const SizedBox(height: 16),

            /// Date picker
            ListTile(
              title: Text(
                selectedDate == null
                    ? "Select Treatment Date"
                    : "Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),

            const SizedBox(height: 16),

            /// Payment Options
            const Text(
              "Payment Option",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                child: const Text(
                  "Register Now",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
