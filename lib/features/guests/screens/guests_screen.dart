import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/widgets.dart';
import '../models/guest.dart';

class GuestsScreen extends StatefulWidget {
  const GuestsScreen({super.key});

  @override
  State<GuestsScreen> createState() => _GuestsScreenState();
}

class _GuestsScreenState extends State<GuestsScreen>
    with SingleTickerProviderStateMixin {
  static const List<Guest> _guestLog = [
    Guest(
      name: 'Ankit Mehta',
      relation: 'Friend',
      checkIn: '3 May 2025, 4:15 PM',
      checkOut: '3 May 2025, 8:00 PM',
      flat: '301',
      vehicleNo: 'MH12AB1234',
      status: 'Exited',
    ),
    Guest(
      name: 'Priya & Rajesh Sharma',
      relation: 'Relatives',
      checkIn: '1 May 2025, 11:00 AM',
      checkOut: '2 May 2025, 10:30 AM',
      flat: '301',
      vehicleNo: '—',
      status: 'Exited',
    ),
    Guest(
      name: 'Swiggy Delivery',
      relation: 'Delivery',
      checkIn: '30 Apr 2025, 7:45 PM',
      checkOut: '30 Apr 2025, 7:52 PM',
      flat: '301',
      vehicleNo: 'MH01ZZ9999',
      status: 'Exited',
    ),
  ];

  late final TabController _tabController =
      TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Guest Management'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Guest Log'),
            Tab(text: 'QR Codes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _GuestLogTab(guestLog: _guestLog),
          _QrCodesTab(),
        ],
      ),
    );
  }
}

class _GuestLogTab extends StatelessWidget {
  const _GuestLogTab({required this.guestLog});

  final List<Guest> guestLog;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.info_outline,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                '${guestLog.length} guests visited this month',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: guestLog.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _GuestCard(guest: guestLog[i]),
          ),
        ),
      ],
    );
  }
}

class _GuestCard extends StatelessWidget {
  const _GuestCard({required this.guest});

  final Guest guest;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                child: Text(
                  guest.initial,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guest.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    StatusChip(label: guest.relation, color: AppColors.accent),
                  ],
                ),
              ),
              StatusChip.forStatus(guest.status),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.login,
            label: 'Check-in',
            value: guest.checkIn,
          ),
          const SizedBox(height: 6),
          _InfoRow(
            icon: Icons.logout,
            label: 'Check-out',
            value: guest.checkOut,
          ),
          if (guest.hasVehicle) ...[
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.directions_car_outlined,
              label: 'Vehicle',
              value: guest.vehicleNo,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _QrCodesTab extends StatelessWidget {
  const _QrCodesTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          _QrPreviewCard(),
          SizedBox(height: 20),
          _QrOptionCard(
            icon: Icons.access_time,
            title: 'Timed QR (4 hrs)',
            description: 'Valid for a single entry within 4 hours.',
          ),
          SizedBox(height: 10),
          _QrOptionCard(
            icon: Icons.calendar_month_outlined,
            title: 'Day Pass QR',
            description: 'Valid for the entire day.',
          ),
          SizedBox(height: 10),
          _QrOptionCard(
            icon: Icons.repeat,
            title: 'Recurring QR',
            description: 'For household staff — valid every day.',
          ),
        ],
      ),
    );
  }
}

class _QrPreviewCard extends StatelessWidget {
  const _QrPreviewCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 20,
      child: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_2,
                    size: 80,
                    color: AppColors.textSecondary.withValues(alpha: 0.3)),
                const SizedBox(height: 8),
                const Text(
                  'No active QR',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Generate a QR code to let your guests check in without calling you.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.qr_code),
            label: const Text('Generate QR Code'),
          ),
        ],
      ),
    );
  }
}

class _QrOptionCard extends StatelessWidget {
  const _QrOptionCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
