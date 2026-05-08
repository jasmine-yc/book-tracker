import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String text;
  const TagChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:100,
      child: Chip(
        backgroundColor: Colors.white,
        label: Text(text, style: TextStyle(fontSize: 14)),
        onDeleted: () {},
        deleteIcon: Icon(Icons.cancel, size: 18),
        labelPadding: EdgeInsets.symmetric(horizontal: 0),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
