import 'package:flutter/material.dart';

import 'package:society_core/theme/app_theme.dart';

/// A resident's family member, registered for identity and emergency records.
class FamilyMember {
  const FamilyMember({
    required this.name,
    required this.relation,
    required this.age,
    required this.gender,
    required this.phone,
    required this.kyc,
    required this.avatar,
  });

  final String name;
  final String relation;
  final int age;
  final String gender;
  final String phone;
  final String kyc;
  final String avatar;

  bool get isKycVerified => kyc == 'Verified';

  bool get hasPhone => phone != '—';

  Color get accentColor {
    switch (relation) {
      case 'Self':
        return AppColors.primary;
      case 'Spouse':
        return AppColors.accent;
      default:
        return AppColors.warning;
    }
  }
}
