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
      totalAmount: _toDouble(json['total_amount']),
      discountAmount: _toDouble(json['discount_amount']),
      advanceAmount: _toDouble(json['advance_amount']),
      balanceAmount: _toDouble(json['balance_amount']),
      dateTime: _parseDate(json['date_nd_time']),
      branch: Branch.fromJson(json['branch'] ?? {}),
      treatmentDetails: (json['patientdetails_set'] as List? ?? [])
          .map((e) => TreatmentDetail.fromJson(e))
          .toList(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null || value.toString().isEmpty) return DateTime.now();
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }
}

class Branch {
  final int id;
  final String name;
  final String location;
  final String phone;
  final String mail;
  final String address;
  final bool isActive;

  Branch({
    required this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.mail,
    required this.address,
    required this.isActive,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      location: json['location'] ?? "",
      phone: json['phone'] ?? "",
      mail: json['mail'] ?? "",
      address: json['address'] ?? "",
      isActive: json['is_active'] ?? false,
    );
  }
}

class Treatment {
  final int id;
  final String name;
  final String duration;
  final String price;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Treatment({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      duration: json['duration'] ?? "",
      price: json['price'] ?? "0",
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? "") ?? DateTime.now(),
    );
  }
}

class TreatmentDetail {
  final int id;
  final int male;
  final int female;
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
      male: int.tryParse(json['male']?.toString() ?? "0") ?? 0,
      female: int.tryParse(json['female']?.toString() ?? "0") ?? 0,
      treatmentId: json['treatment'] ?? 0,
      treatmentName: json['treatment_name'] ?? "",
    );
  }
}
