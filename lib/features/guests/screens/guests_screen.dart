import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class GuestsScreen extends StatefulWidget {
  const GuestsScreen({super.key});

  @override
  State<GuestsScreen> createState() => _GuestsScreenState();
}

class _GuestsScreenState extends State<GuestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<Map<String, dynamic>> _guestLog = [
    {
      'name': 'Ankit Mehta',
      'relation': 'Friend',
      'checkIn': '3 May 2025, 4:15 PM',
      'checkOut': '3 May 2025, 8:00 PM',
      'flat': '301',
      'vehicleNo': 'MH12AB1234',
      'status': 'Exited',
    },
    {
      'name': 'Priya & Rajesh Sharma',
      'relation': 'Relatives',
      'checkIn': '1 May 2025, 11:00 AM',
      'checkOut': '2 May 2025, 10:30 AM',
      'flat': '301',
      'vehicleNo': '—',
      'status': 'Exited',
    },
    {
      'name': 'Swiggy Delivery',
      'relation': 'Delivery',
      'checkIn': '30 Apr 2025, 7:45 PM',
      'checkOut': '30 Apr 2025, 7:52 PM',
      'flat': '301',
      'vehicleNo': 'MH01ZZ9999',
      'status': 'Exited',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

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
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
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
        children: [
          _GuestLogTab(guestLog: _guestLog),
          const _QRCodesTab(),
        ],
      ),
    );
  }
}

class _GuestLogTab extends StatelessWidget {
  final List<Map<String, dynamic>> guestLog;

  const _GuestLogTab({required this.guestLog});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
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
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: guestLog.length,
            itemBuilder: (context, index) =>
                _GuestCard(guest: guestLog[index]),
          ),
        ),
      ],
    );
  }
}

class _GuestCard extends StatelessWidget {
  final Map<String, dynamic> guest;

  const _GuestCard({required this.guest});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                child: Text(
                  (guest['name'] as String)[0].toUpperCase(),
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
                      guest['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        guest['relation'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Exited',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _InfoRow(
                  icon: Icons.login,
                  label: 'Check-in',
                  value: guest['checkIn'] as String,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _InfoRow(
                  icon: Icons.logout,
                  label: 'Check-out',
                  value: guest['checkOut'] as String,
                ),
              ),
            ],
          ),
          if (guest['vehicleNo'] != '—') ...[
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.directions_car_outlined,
              label: 'Vehicle',
              value: guest['vehicleNo'] as String,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _QRCodesTab extends StatelessWidget {
  const _QRCodesTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
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
          ),
          const SizedBox(height: 20),
          _QROptionCard(
            icon: Icons.access_time,
            title: 'Timed QR (4 hrs)',
            description: 'Valid for a single entry within 4 hours.',
          ),
          const SizedBox(height: 10),
          _QROptionCard(
            icon: Icons.calendar_month_outlined,
            title: 'Day Pass QR',
            description: 'Valid for the entire day.',
          ),
          const SizedBox(height: 10),
          _QROptionCard(
            icon: Icons.repeat,
            title: 'Recurring QR',
            description: 'For household staff — valid every day.',
          ),
        ],
      ),
    );
  }
}

class _QROptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _QROptionCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
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
