import 'package:flutter/material.dart';
import 'package:noviindus_ayurvedic/provider/branch_treatprovider.dart';
import 'package:noviindus_ayurvedic/provider/patient_provider.dart';
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Treatment name row with delete button
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                t["treatment"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  selectedTreatments.remove(t);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Count controls in a more organized layout
                        Row(
                          children: [
                            // Male count section
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Male",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.remove,
                                              size: 14,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                t["male"] = (t["male"] > 0)
                                                    ? t["male"] - 1
                                                    : 0;
                                              });
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${t["male"]}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.add,
                                              size: 14,
                                            ),
                                            onPressed: () {
                                              setState(() => t["male"]++);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Female count section
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.pink.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Female",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.remove,
                                              size: 14,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                t["female"] = (t["female"] > 0)
                                                    ? t["female"] - 1
                                                    : 0;
                                              });
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${t["female"]}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.add,
                                              size: 14,
                                            ),
                                            onPressed: () {
                                              setState(() => t["female"]++);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
            Consumer<PatientProvider>(
              builder: (context, patientProvider, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      // Validate form data
                      if (nameController.text.trim().isEmpty ||
                          executiveController.text.trim().isEmpty ||
                          phoneController.text.trim().isEmpty ||
                          addressController.text.trim().isEmpty ||
                          selectedBranch == null ||
                          selectedDate == null ||
                          totalAmountController.text.trim().isEmpty ||
                          selectedTreatments.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all required fields"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Validate that at least one treatment has a count > 0
                      bool hasValidTreatments = selectedTreatments.any(
                        (treatment) =>
                            treatment["male"] > 0 || treatment["female"] > 0,
                      );

                      if (!hasValidTreatments) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please select at least one treatment with quantity",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      try {
                        // Collect treatment IDs based on male/female counts
                        List<int> maleTreatmentIds = [];
                        List<int> femaleTreatmentIds = [];

                        final treatmentProvider =
                            Provider.of<Brachtreatmentprovider>(
                              context,
                              listen: false,
                            );

                        for (var selectedTreatment in selectedTreatments) {
                          // Find treatment ID by name
                          final treatment = treatmentProvider.treatments
                              .firstWhere(
                                (t) => t.name == selectedTreatment["treatment"],
                                orElse: () =>
                                    throw Exception("Treatment not found"),
                              );

                          // Add treatment ID based on male count
                          for (int i = 0; i < selectedTreatment["male"]; i++) {
                            maleTreatmentIds.add(treatment.id);
                          }

                          // Add treatment ID based on female count
                          for (
                            int i = 0;
                            i < selectedTreatment["female"];
                            i++
                          ) {
                            femaleTreatmentIds.add(treatment.id);
                          }
                        }

                        // Format date for API (01/02/2024-10:24 AM) - as confirmed by Postman
                        final now = DateTime.now();
                        String hour12 = now.hour == 0
                            ? "12"
                            : now.hour > 12
                            ? (now.hour - 12).toString()
                            : now.hour.toString();
                        String amPm = now.hour >= 12 ? "PM" : "AM";
                        final formattedDate =
                            "${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}-${hour12.padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $amPm";

                        // Call the API
                        final patientProvider = Provider.of<PatientProvider>(
                          context,
                          listen: false,
                        );

                        print("=== CLIENT DEBUG ===");
                        print("Token: ${widget.token.substring(0, 20)}...");
                        print("Formatted Date: $formattedDate");
                        print("Branch ID: $selectedBranch");
                        print("Male Treatment IDs: $maleTreatmentIds");
                        print("Female Treatment IDs: $femaleTreatmentIds");
                        print(
                          "Total Amount: ${double.tryParse(totalAmountController.text) ?? 0.0}",
                        );
                        print("====================");

                        final success = await patientProvider.addPatient(
                          token: widget.token,
                          name: nameController.text.trim(),
                          executive: executiveController.text.trim(),
                          payment: selectedPayment,
                          phone: phoneController.text.trim(),
                          address: addressController.text.trim(),
                          totalAmount:
                              double.tryParse(totalAmountController.text) ??
                              0.0,
                          discountAmount:
                              double.tryParse(discountController.text) ?? 0.0,
                          advanceAmount:
                              double.tryParse(advanceController.text) ?? 0.0,
                          balanceAmount:
                              double.tryParse(balanceController.text) ?? 0.0,
                          dateTime: formattedDate,
                          branchId: selectedBranch!,
                          maleTreatmentIds: maleTreatmentIds,
                          femaleTreatmentIds: femaleTreatmentIds,
                        );

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Patient registered successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // Clear form
                          nameController.clear();
                          executiveController.clear();
                          phoneController.clear();
                          addressController.clear();
                          totalAmountController.clear();
                          discountController.clear();
                          advanceController.clear();
                          balanceController.clear();
                          setState(() {
                            selectedTreatments.clear();
                            selectedBranch = null;
                            selectedDate = null;
                            selectedPayment = "Cash";
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                patientProvider.errorMessage ??
                                    "Registration failed",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: patientProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Register Now",
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
