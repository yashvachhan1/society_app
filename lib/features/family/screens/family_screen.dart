import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/widgets.dart';
import '../models/family_member.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  static const List<FamilyMember> _members = [
    FamilyMember(
      name: 'Rahul Sharma',
      relation: 'Self',
      age: 35,
      gender: 'Male',
      phone: '+91 98765 43210',
      kyc: 'Verified',
      avatar: 'RS',
    ),
    FamilyMember(
      name: 'Priya Sharma',
      relation: 'Spouse',
      age: 32,
      gender: 'Female',
      phone: '+91 91234 56789',
      kyc: 'Verified',
      avatar: 'PS',
    ),
    FamilyMember(
      name: 'Aryan Sharma',
      relation: 'Son',
      age: 8,
      gender: 'Male',
      phone: '—',
      kyc: 'Pending',
      avatar: 'AS',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final verified = _members.where((m) => m.isKycVerified).length;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Family Directory')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMemberSheet(context),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text(
          'Add Member',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          _FlatInfoHeader(memberCount: _members.length, verifiedCount: verified),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: _members.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _FamilyMemberCard(member: _members[i]),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMemberSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _AddMemberSheet(),
    );
  }
}

class _FlatInfoHeader extends StatelessWidget {
  const _FlatInfoHeader({
    required this.memberCount,
    required this.verifiedCount,
  });

  final int memberCount;
  final int verifiedCount;

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
            child: const Icon(Icons.home_outlined,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Flat 301, Tower A',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$memberCount members registered',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          StatusChip(
            label: '$verifiedCount Verified',
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}

class _FamilyMemberCard extends StatelessWidget {
  const _FamilyMemberCard({required this.member});

  final FamilyMember member;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: 18,
      child: Row(
        children: [
          _MemberAvatar(
            initials: member.avatar,
            color: member.accentColor,
            verified: member.isKycVerified,
          ),
          const SizedBox(width: 14),
          Expanded(child: _MemberDetails(member: member)),
          _MemberTrailing(member: member),
        ],
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({
    required this.initials,
    required this.color,
    required this.verified,
  });

  final String initials;
  final Color color;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withValues(alpha: 0.15),
          child: Text(
            initials,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        if (verified)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 2),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 10),
            ),
          ),
      ],
    );
  }
}

class _MemberDetails extends StatelessWidget {
  const _MemberDetails({required this.member});

  final FamilyMember member;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                member.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            StatusChip(label: member.relation, color: member.accentColor),
          ],
        ),
        const SizedBox(height: 4),
        _IconLine(
          icon: Icons.cake_outlined,
          text: '${member.age} yrs  •  ${member.gender}',
        ),
        if (member.hasPhone) ...[
          const SizedBox(height: 3),
          _IconLine(icon: Icons.phone_outlined, text: member.phone),
        ],
      ],
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _MemberTrailing extends StatelessWidget {
  const _MemberTrailing({required this.member});

  final FamilyMember member;

  @override
  Widget build(BuildContext context) {
    final verified = member.isKycVerified;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconChip(
          label: member.kyc,
          icon: verified ? Icons.verified_outlined : Icons.pending_outlined,
          color: verified ? AppColors.success : AppColors.warning,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.edit_outlined,
                size: 18, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _AddMemberSheet extends StatelessWidget {
  const _AddMemberSheet();

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
            'Add Family Member',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Relation',
              prefixIcon: Icon(Icons.family_restroom),
            ),
            items: const [
              DropdownMenuItem(value: 'Spouse', child: Text('Spouse')),
              DropdownMenuItem(value: 'Son', child: Text('Son')),
              DropdownMenuItem(value: 'Daughter', child: Text('Daughter')),
              DropdownMenuItem(value: 'Parent', child: Text('Parent')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          const TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Age',
              prefixIcon: Icon(Icons.cake_outlined),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add Member'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
