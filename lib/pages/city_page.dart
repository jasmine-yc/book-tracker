import 'package:flutter/material.dart';

class CityPage extends StatelessWidget {
  final String city;
  const CityPage({
    super.key,
    required this.city
    });

  @override
  Widget build(BuildContext context) {
    return Text(city);
  }
}