import 'package:flutter/material.dart';

/// A home-service category a resident can book from the app (electrician,
/// plumber, etc.). The society assigns a verified professional to the request.
class ServiceCategory {
  const ServiceCategory({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String name;
  final String description;
  final IconData icon;
  final Color color;
}
