import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/widgets.dart';
import '../models/service_category.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  static const List<ServiceCategory> _services = [
    ServiceCategory(
      name: 'Electrician',
      description: 'Wiring, switches, fans',
      icon: Icons.electrical_services,
      color: Color(0xFFF9A825),
    ),
    ServiceCategory(
      name: 'Plumber',
      description: 'Leaks, taps, pipes',
      icon: Icons.plumbing,
      color: Color(0xFF0097A7),
    ),
    ServiceCategory(
      name: 'Carpenter',
      description: 'Doors, furniture, locks',
      icon: Icons.carpenter,
      color: Color(0xFF8D6E63),
    ),
    ServiceCategory(
      name: 'AC Repair',
      description: 'Service & gas refill',
      icon: Icons.ac_unit,
      color: Color(0xFF42A5F5),
    ),
    ServiceCategory(
      name: 'Cleaning',
      description: 'Deep clean, sofa, tank',
      icon: Icons.cleaning_services,
      color: Color(0xFF43A047),
    ),
    ServiceCategory(
      name: 'Painter',
      description: 'Walls, touch-up, POP',
      icon: Icons.format_paint,
      color: Color(0xFF7E57C2),
    ),
    ServiceCategory(
      name: 'Pest Control',
      description: 'Cockroach, termite',
      icon: Icons.pest_control,
      color: Color(0xFFE53935),
    ),
    ServiceCategory(
      name: 'Appliance Repair',
      description: 'Fridge, washing m/c',
      icon: Icons.home_repair_service,
      color: Color(0xFF5C6BC0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Home Services')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoBanner(
              message:
                  'Book society-verified professionals. Raise a request and the office assigns a pro to your flat.',
              icon: Icons.verified_user_outlined,
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Choose a Service'),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.45,
              ),
              itemCount: _services.length,
              itemBuilder: (_, i) => _ServiceCard(
                service: _services[i],
                onTap: () => _bookService(context, _services[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _bookService(BuildContext context, ServiceCategory service) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _BookServiceSheet(service: service),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.onTap});

  final ServiceCategory service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: service.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(service.icon, color: service.color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            service.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            service.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _BookServiceSheet extends StatelessWidget {
  const _BookServiceSheet({required this.service});

  final ServiceCategory service;

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
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: service.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(service.icon, color: service.color, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book ${service.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    service.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Describe the work needed',
              hintText: 'e.g. Fan in bedroom not working',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Preferred time',
              hintText: 'Today, 4:00 PM - 6:00 PM',
              prefixIcon: Icon(Icons.schedule),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.success,
                    content: Text(
                      '${service.name} request sent! The office will assign a professional.',
                    ),
                  ),
                );
              },
              child: const Text('Send Request'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
