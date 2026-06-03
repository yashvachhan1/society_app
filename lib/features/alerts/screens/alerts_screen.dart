import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/widgets.dart';
import '../models/alert.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  static const List<AlertType> _alertTypes = [
    AlertType(
      label: 'Water Supply',
      icon: Icons.water_drop_outlined,
      color: Color(0xFF1E88E5),
      description: 'Report water supply issues',
    ),
    AlertType(
      label: 'Power Outage',
      icon: Icons.bolt,
      color: Color(0xFFFB8C00),
      description: 'Report electricity failure',
    ),
    AlertType(
      label: 'Lift Not Working',
      icon: Icons.elevator,
      color: Color(0xFFE53935),
      description: 'Alert about lift breakdown',
    ),
    AlertType(
      label: 'Garbage',
      icon: Icons.delete_outline,
      color: Color(0xFF43A047),
      description: 'Report garbage collection issues',
    ),
    AlertType(
      label: 'Parking Blocked',
      icon: Icons.local_parking,
      color: Color(0xFF8E24AA),
      description: 'Report parking violations',
    ),
    AlertType(
      label: 'Noise',
      icon: Icons.volume_up_outlined,
      color: Color(0xFF00ACC1),
      description: 'Report noise disturbance',
    ),
  ];

  static const List<RecentAlert> _recentAlerts = [
    RecentAlert(
      type: 'Water Supply',
      message: 'Water supply disruption reported by flat 402.',
      time: '2 hrs ago',
      color: Color(0xFF1E88E5),
      icon: Icons.water_drop_outlined,
    ),
    RecentAlert(
      type: 'Power Outage',
      message: 'Power failure in Tower A staircase lights.',
      time: '5 hrs ago',
      color: Color(0xFFFB8C00),
      icon: Icons.bolt,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Quick Alerts')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoBanner(
              message:
                  'Tap any alert to instantly notify the society admin and security.',
              icon: Icons.campaign_outlined,
              color: AppColors.accent,
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Tap to Send Alert'),
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
              itemBuilder: (_, i) => _AlertCard(
                alert: _alertTypes[i],
                onTap: () => _sendAlert(context, _alertTypes[i]),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Recent Alerts'),
            const SizedBox(height: 12),
            for (final alert in _recentAlerts) ...[
              _RecentAlertTile(alert: alert),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }

  void _sendAlert(BuildContext context, AlertType alert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(alert.icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${alert.label} alert sent to society admin!',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: alert.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert, required this.onTap});

  final AlertType alert;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: alert.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(alert.icon, color: alert.color, size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            alert.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentAlertTile extends StatelessWidget {
  const _RecentAlertTile({required this.alert});

  final RecentAlert alert;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: alert.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(alert.icon, color: alert.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.type,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  alert.message,
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
            alert.time,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
