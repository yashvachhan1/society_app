import 'package:flutter/material.dart';

import 'package:society_core/theme/app_theme.dart';
import 'package:society_core/widgets/widgets.dart';
import '../models/vehicle.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  static const List<Vehicle> _vehicles = [
    Vehicle(
      type: 'Car',
      make: 'Maruti Suzuki',
      model: 'Swift Dzire',
      numberPlate: 'MH 12 AB 1234',
      color: 'White',
      parkingSlot: 'B-14',
      icon: Icons.directions_car,
      accentColor: Color(0xFF1565C0),
    ),
    Vehicle(
      type: 'Bike',
      make: 'Honda',
      model: 'Activa 6G',
      numberPlate: 'MH 12 ZZ 9876',
      color: 'Black',
      parkingSlot: 'TW-07',
      icon: Icons.two_wheeler,
      accentColor: Color(0xFF00ACC1),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Vehicle Registry')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddVehicleSheet(context),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Vehicle',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          const _ParkingInfoBanner(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: _vehicles.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _VehicleCard(vehicle: _vehicles[i]),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddVehicleSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _AddVehicleSheet(),
    );
  }
}

class _ParkingInfoBanner extends StatelessWidget {
  const _ParkingInfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_parking,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flat 301 — 2 Vehicles',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Covered parking: B-14  |  TW parking: TW-07',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      borderRadius: 18,
      child: Column(
        children: [
          _VehicleHeader(vehicle: vehicle),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _VehicleDetail(
                    icon: Icons.palette_outlined,
                    label: 'Color',
                    value: vehicle.color,
                  ),
                ),
                const _DetailDivider(),
                Expanded(
                  child: _VehicleDetail(
                    icon: Icons.local_parking,
                    label: 'Parking Slot',
                    value: vehicle.parkingSlot,
                    valueColor: vehicle.accentColor,
                  ),
                ),
                const _DetailDivider(),
                Expanded(
                  child: _VehicleDetail(
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    value: 'Update',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleHeader extends StatelessWidget {
  const _VehicleHeader({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final accent = vehicle.accentColor;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, accent.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(vehicle.icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    vehicle.numberPlate,
                    style: TextStyle(
                      color: accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              vehicle.type,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  const _DetailDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 36, width: 1, color: AppColors.divider);
  }
}

class _VehicleDetail extends StatelessWidget {
  const _VehicleDetail({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        Icon(icon, size: 18, color: valueColor ?? AppColors.textSecondary),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: content,
    );
  }
}

class _AddVehicleSheet extends StatelessWidget {
  const _AddVehicleSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Add Vehicle',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Vehicle Type',
              prefixIcon: Icon(Icons.directions_car_outlined),
            ),
            items: const [
              DropdownMenuItem(value: 'Car', child: Text('Car')),
              DropdownMenuItem(value: 'Bike', child: Text('Bike / Scooter')),
              DropdownMenuItem(value: 'SUV', child: Text('SUV')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Number Plate',
              prefixIcon: Icon(Icons.badge_outlined),
              hintText: 'e.g. MH 12 AB 1234',
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Make & Model',
              prefixIcon: Icon(Icons.info_outline),
              hintText: 'e.g. Maruti Swift',
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Color',
              prefixIcon: Icon(Icons.palette_outlined),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Register Vehicle'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
