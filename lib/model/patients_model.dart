class Patient {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String payment;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;
  final DateTime dateTime;
  final Branch branch;
  final List<TreatmentDetail> treatmentDetails;

  Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.payment,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateTime,
    required this.branch,
    required this.treatmentDetails,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      phone: json['phone'] ?? "",
      address: json['address'] ?? "",
      payment: json['payment'] ?? "",
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      advanceAmount: (json['advance_amount'] ?? 0).toDouble(),
      balanceAmount: (json['balance_amount'] ?? 0).toDouble(),
      dateTime:
          json['date_nd_time'] != null &&
              json['date_nd_time'].toString().isNotEmpty
          ? DateTime.tryParse(json['date_nd_time'].toString()) ?? DateTime.now()
          : DateTime.now(),
      branch: Branch.fromJson(json['branch'] ?? {}),
      treatmentDetails: (json['patientdetails_set'] as List? ?? [])
          .map((e) => TreatmentDetail.fromJson(e))
          .toList(),
    );
  }
}

class Branch {
  final int id;
  final String name;
  final String location;
  final String phone;
  final String mail;
  final String address;

  Branch({
    required this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.mail,
    required this.address,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      location: json['location'] ?? "",
      phone: json['phone'] ?? "",
      mail: json['mail'] ?? "",
      address: json['address'] ?? "",
    );
  }
}

class TreatmentDetail {
  final int id;
  final String male;
  final String female;
  final int treatmentId;
  final String treatmentName;

  TreatmentDetail({
    required this.id,
    required this.male,
    required this.female,
    required this.treatmentId,
    required this.treatmentName,
  });

  factory TreatmentDetail.fromJson(Map<String, dynamic> json) {
    return TreatmentDetail(
      id: json['id'] ?? 0,
      male: json['male']?.toString() ?? "0",
      female: json['female']?.toString() ?? "0",
      treatmentId: json['treatment'] ?? 0,
      treatmentName: json['treatment_name'] ?? "",
    );
  }
}
