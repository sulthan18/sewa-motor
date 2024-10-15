import 'package:flutter/material.dart';
import 'package:sewa_motor/models/bike.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key, required this.bike});
  final Bike bike;

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
