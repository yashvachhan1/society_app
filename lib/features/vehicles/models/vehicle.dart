import 'package:flutter/material.dart';

/// A resident's registered vehicle, used for parking management and gate
/// security checks.
class Vehicle {
  const Vehicle({
    required this.type,
    required this.make,
    required this.model,
    required this.numberPlate,
    required this.color,
    required this.parkingSlot,
    required this.icon,
    required this.accentColor,
  });

  final String type;
  final String make;
  final String model;
  final String numberPlate;
  final String color;
  final String parkingSlot;
  final IconData icon;
  final Color accentColor;

  String get displayName => '$make $model';
}
