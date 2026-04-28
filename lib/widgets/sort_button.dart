import 'package:flutter/material.dart';

class SortButton extends StatelessWidget {
  final String text;
  const SortButton({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black54,
        overlayColor: const Color.fromARGB(255, 255, 255, 255),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
