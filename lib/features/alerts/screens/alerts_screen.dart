import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  static const List<Map<String, dynamic>> _alertTypes = [
    {
      'label': 'Water Supply',
      'icon': Icons.water_drop_outlined,
      'color': Color(0xFF1E88E5),
      'description': 'Report water supply issues',
    },
    {
      'label': 'Power Outage',
      'icon': Icons.bolt,
      'color': Color(0xFFFB8C00),
      'description': 'Report electricity failure',
    },
    {
      'label': 'Lift Not Working',
      'icon': Icons.elevator,
      'color': Color(0xFFE53935),
      'description': 'Alert about lift breakdown',
    },
    {
      'label': 'Garbage',
      'icon': Icons.delete_outline,
      'color': Color(0xFF43A047),
      'description': 'Report garbage collection issues',
    },
    {
      'label': 'Parking Blocked',
      'icon': Icons.local_parking,
      'color': Color(0xFF8E24AA),
      'description': 'Report parking violations',
    },
    {
      'label': 'Noise',
      'icon': Icons.volume_up_outlined,
      'color': Color(0xFF00ACC1),
      'description': 'Report noise disturbance',
    },
  ];

  static const List<Map<String, dynamic>> _recentAlerts = [
    {
      'type': 'Water Supply',
      'message': 'Water supply disruption reported by flat 402.',
      'time': '2 hrs ago',
      'color': Color(0xFF1E88E5),
      'icon': Icons.water_drop_outlined,
    },
    {
      'type': 'Power Outage',
      'message': 'Power failure in Tower A staircase lights.',
      'time': '5 hrs ago',
      'color': Color(0xFFFB8C00),
      'icon': Icons.bolt,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quick Alerts'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoBanner(),
            const SizedBox(height: 20),
            const Text(
              'Tap to Send Alert',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: _alertTypes.length,
              itemBuilder: (context, index) => _AlertCard(
                alertType: _alertTypes[index],
                onTap: () => _sendAlert(context, _alertTypes[index]),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Alerts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ..._recentAlerts.map((a) => _RecentAlertTile(alert: a)),
          ],
        ),
      ),
    );
  }

  void _sendAlert(BuildContext context, Map<String, dynamic> alertType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(alertType['icon'] as IconData,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${alertType['label']} alert sent to society admin!',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: alertType['color'] as Color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: const [
          Icon(Icons.campaign_outlined, color: AppColors.accent, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tap any alert to instantly notify the society admin and security.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.accent,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final Map<String, dynamic> alertType;
  final VoidCallback onTap;

  const _AlertCard({required this.alertType, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = alertType['color'] as Color;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(alertType['icon'] as IconData,
                    color: color, size: 26),
              ),
              const SizedBox(height: 10),
              Text(
                alertType['label'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentAlertTile extends StatelessWidget {
  final Map<String, dynamic> alert;

  const _RecentAlertTile({required this.alert});

  @override
  Widget build(BuildContext context) {
    final color = alert['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(alert['icon'] as IconData, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['type'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  alert['message'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            alert['time'] as String,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
