import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:society_app/core/constants/app_constants.dart';
import 'package:society_app/core/theme/app_theme.dart';
import 'package:society_app/core/widgets/widgets.dart';

/// Shown after a resident submits their registration. The membership row exists
/// with `status = 'pending'`; the society admin approves or rejects it
/// (requirement R4.1.5), and only then does the resident get in.
class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  static const _steps = [
    _ApprovalStep(
      title: 'Request submitted',
      subtitle: 'We received your details and document.',
      done: true,
    ),
    _ApprovalStep(
      title: 'Admin review',
      subtitle: 'The society admin is verifying your flat and proof.',
      done: false,
      active: true,
    ),
    _ApprovalStep(
      title: 'Account activated',
      subtitle: 'You will get a notification and can sign in.',
      done: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.hourglass_top_rounded,
                    size: 44,
                    color: AppColors.warning,
                  ),
                ),
              ),
              const SizedBox(height: 26),
              const Center(
                child: Text(
                  'Waiting for approval',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Your society admin will review your request, usually within a day.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              AppCard(
                child: Column(
                  children: [
                    for (var i = 0; i < _steps.length; i++)
                      _StepRow(step: _steps[i], isLast: i == _steps.length - 1),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const InfoBanner(
                message:
                    'We will notify you as soon as it is approved. You can close the app.',
                icon: Icons.notifications_active_outlined,
              ),
              const SizedBox(height: 26),
              OutlinedButton(
                onPressed: () => context.go(AppRoutes.login),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: AppColors.divider),
                  foregroundColor: AppColors.textPrimary,
                ),
                child: const Text('Back to login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApprovalStep {
  const _ApprovalStep({
    required this.title,
    required this.subtitle,
    required this.done,
    this.active = false,
  });

  final String title;
  final String subtitle;
  final bool done;
  final bool active;
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.isLast});

  final _ApprovalStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = step.done
        ? AppColors.success
        : step.active
        ? AppColors.warning
        : AppColors.textSecondary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: step.done || step.active ? 0.14 : 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  step.done
                      ? Icons.check_rounded
                      : step.active
                      ? Icons.more_horiz_rounded
                      : Icons.circle_outlined,
                  size: 16,
                  color: color,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppColors.divider),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: step.done || step.active
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    step.subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
