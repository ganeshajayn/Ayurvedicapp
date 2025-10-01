import 'package:flutter/material.dart';

class ElevatedbuttonWidgets extends StatelessWidget {
  final VoidCallback? onpressed;
  final String label;
  final Color? color;
  final Color? textcolor;
  const ElevatedbuttonWidgets({
    super.key,
    this.onpressed,
    required this.label,
    this.color,
    this.textcolor,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        height: height * 0.06,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onpressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textcolor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
