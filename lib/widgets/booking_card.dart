import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatelessWidget {
  final int index;
  final String patientName;
  final String? treatmentName;
  final DateTime bookingDate;
  final String therapistName;
  final VoidCallback onTap;

  const BookingCard({
    Key? key,
    required this.index,
    required this.patientName,
    this.treatmentName,
    required this.bookingDate,
    required this.therapistName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(bookingDate);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$index. $patientName",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Text(
              treatmentName ?? "Treatment",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.teal,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.red),
                const SizedBox(width: 6),
                Text(formattedDate, style: const TextStyle(fontSize: 13)),

                const SizedBox(width: 16),
                const Icon(Icons.person, size: 16, color: Colors.orange),
                const SizedBox(width: 6),
                Text(therapistName, style: const TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.teal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("View Booking details"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
