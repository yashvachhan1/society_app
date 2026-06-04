import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

import '../data/demo_data.dart';
import '../models/owner_models.dart';

/// Onboard a new property — a step-by-step wizard. Details, Structure and
/// Services are built; Admin, Subscription and Review are placeholders for now.
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  static const _steps = [
    'Details',
    'Structure',
    'Admin',
    'Services',
    'Subscription',
    'Review',
  ];

  int _step = 0;
  int _typeIndex = 0;

  final _name = TextEditingController();
  final _city = TextEditingController();
  final _address = TextEditingController();

  int _towers = 4;
  int _floors = 12;
  int _unitsPerFloor = 4;

  late final Map<String, bool> _enabled = {
    for (final m in DemoData.serviceModules) m.name: m.onByDefault,
  };

  final _adminName = TextEditingController();
  final _adminEmail = TextEditingController();
  final _adminPhone = TextEditingController();
  int _roleIndex = 0;

  int _planIndex = 1; // Pro — most popular
  bool _annual = false;

  int get _totalUnits => _towers * _floors * _unitsPerFloor;
  int get _enabledCount => _enabled.values.where((on) => on).length;
  bool get _isLast => _step == _steps.length - 1;

  @override
  void dispose() {
    _name.dispose();
    _city.dispose();
    _address.dispose();
    _adminName.dispose();
    _adminEmail.dispose();
    _adminPhone.dispose();
    super.dispose();
  }

  void _next() => setState(() => _step = (_step + 1).clamp(0, _steps.length - 1));
  void _back() => setState(() => _step = (_step - 1).clamp(0, _steps.length - 1));

  void _create() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Property created (demo) — the backend will make it real.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      builder: (context, width) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Intro(),
          const SizedBox(height: 22),
          _Stepper(steps: _steps, current: _step),
          const SizedBox(height: 22),
          SectionCard(
            title: '${_step + 1}.  ${_steps[_step]}',
            action: _step == 3
                ? _EnabledChip(
                    count: _enabledCount,
                    total: DemoData.serviceModules.length,
                  )
                : null,
            child: _buildStep(),
          ),
          const SizedBox(height: 22),
          _Footer(
            isLast: _isLast,
            onBack: _step == 0 ? null : _back,
            onNext: _isLast ? _create : _next,
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _detailsStep();
      case 1:
        return _structureStep();
      case 2:
        return _adminStep();
      case 3:
        return _ModuleGrid(
          enabled: _enabled,
          onToggle: (name, on) => setState(() => _enabled[name] = on),
        );
      case 4:
        return _subscriptionStep();
      default:
        return _reviewStep();
    }
  }

  Widget _detailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Property type'),
        const SizedBox(height: 10),
        _TypeGrid(
          selected: _typeIndex,
          onSelect: (i) => setState(() => _typeIndex = i),
        ),
        const SizedBox(height: 20),
        _Field(
          label: 'Property name',
          hint: 'e.g. Sunrise Residency',
          controller: _name,
        ),
        const SizedBox(height: 16),
        _Field(label: 'City', hint: 'e.g. Pune', controller: _city),
        const SizedBox(height: 16),
        _Field(
          label: 'Full address',
          hint: 'Street, area, pincode',
          controller: _address,
        ),
      ],
    );
  }

  Widget _structureStep() {
    final unitWord = DemoData.propertyTypes[_typeIndex].unitLabel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Define how the property is organised — the total updates automatically.',
          style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _Counter(
              label: 'Towers / Wings',
              value: _towers,
              onChanged: (v) => setState(() => _towers = v),
            ),
            _Counter(
              label: 'Floors per tower',
              value: _floors,
              onChanged: (v) => setState(() => _floors = v),
            ),
            _Counter(
              label: 'Units per floor',
              value: _unitsPerFloor,
              onChanged: (v) => setState(() => _unitsPerFloor = v),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _TotalUnitsBanner(total: _totalUnits, unitWord: unitWord),
      ],
    );
  }

  Widget _adminStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'This person gets a login to manage the property day to day.',
          style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 18),
        _Field(
          label: 'Admin name',
          hint: 'e.g. Anil Kapoor',
          controller: _adminName,
        ),
        const SizedBox(height: 16),
        _Field(
          label: 'Email',
          hint: 'name@email.com',
          controller: _adminEmail,
        ),
        const SizedBox(height: 16),
        _Field(
          label: 'Phone',
          hint: '+91 98765 43210',
          controller: _adminPhone,
        ),
        const SizedBox(height: 20),
        const _FieldLabel('Designation'),
        const SizedBox(height: 10),
        _RoleChips(
          roles: DemoData.adminRoles,
          selected: _roleIndex,
          onSelect: (i) => setState(() => _roleIndex = i),
        ),
      ],
    );
  }

  Widget _subscriptionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PlanGrid(
          selected: _planIndex,
          onSelect: (i) => setState(() => _planIndex = i),
        ),
        const SizedBox(height: 20),
        const _FieldLabel('Billing cycle'),
        const SizedBox(height: 10),
        _CycleToggle(
          annual: _annual,
          onChanged: (v) => setState(() => _annual = v),
        ),
        const SizedBox(height: 20),
        _PriceBanner(plan: DemoData.plansCatalog[_planIndex], annual: _annual),
      ],
    );
  }

  Widget _reviewStep() {
    final type = DemoData.propertyTypes[_typeIndex];
    final plan = DemoData.plansCatalog[_planIndex];
    const dash = '—';
    return Column(
      children: [
        _SummaryRow(
          icon: Icons.domain_rounded,
          label: 'Property',
          value: _name.text.isEmpty
              ? type.name
              : '${_name.text}  ·  ${type.name}',
        ),
        const Divider(height: 22, color: AppColors.divider),
        _SummaryRow(
          icon: Icons.place_rounded,
          label: 'Location',
          value: _city.text.isEmpty ? dash : _city.text,
        ),
        const Divider(height: 22, color: AppColors.divider),
        _SummaryRow(
          icon: Icons.grid_view_rounded,
          label: 'Structure',
          value:
              '$_totalUnits ${type.unitLabel}  ($_towers × $_floors × $_unitsPerFloor)',
        ),
        const Divider(height: 22, color: AppColors.divider),
        _SummaryRow(
          icon: Icons.person_rounded,
          label: 'Admin',
          value: _adminName.text.isEmpty
              ? dash
              : '${_adminName.text}  ·  ${DemoData.adminRoles[_roleIndex]}',
        ),
        const Divider(height: 22, color: AppColors.divider),
        _SummaryRow(
          icon: Icons.tune_rounded,
          label: 'Services',
          value: '$_enabledCount of ${DemoData.serviceModules.length} enabled',
        ),
        const Divider(height: 22, color: AppColors.divider),
        _SummaryRow(
          icon: Icons.workspace_premium_rounded,
          label: 'Plan',
          value: '${plan.name}  ·  ${_annual ? 'Annual' : 'Monthly'}',
        ),
      ],
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Onboard a new property',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'A few quick steps to set up a society, corporate park or complex.',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.steps, required this.current});

  final List<String> steps;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Step ${current + 1} of ${steps.length}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            Text(
              '   ·   ${steps[current]}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (var i = 0; i < steps.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: i <= current ? AppColors.primary : AppColors.divider,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
  });

  final String label;
  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                _StepBtn(
                  icon: Icons.remove_rounded,
                  onTap: value > 1 ? () => onChanged(value - 1) : null,
                ),
                Expanded(
                  child: Text(
                    '$value',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                _StepBtn(
                  icon: Icons.add_rounded,
                  onTap: value < 99 ? () => onChanged(value + 1) : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.primary : AppColors.divider,
        ),
      ),
    );
  }
}

class _TotalUnitsBanner extends StatelessWidget {
  const _TotalUnitsBanner({required this.total, required this.unitWord});

  final int total;
  final String unitWord;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.domain_rounded, color: AppColors.primary, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total $unitWord',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$total units',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
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

class _RoleChips extends StatelessWidget {
  const _RoleChips({
    required this.roles,
    required this.selected,
    required this.onSelect,
  });

  final List<String> roles;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < roles.length; i++)
          _Chip(
            label: roles[i],
            selected: i == selected,
            onTap: () => onSelect(i),
          ),
      ],
    );
  }
}

/// A small pill used by the role and billing-cycle selectors.
class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.background,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanGrid extends StatelessWidget {
  const _PlanGrid({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 14.0;
        final cols = constraints.maxWidth >= 640 ? 3 : 1;
        final cardWidth =
            ((constraints.maxWidth - gap * (cols - 1)) / cols).floorToDouble();
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < DemoData.plansCatalog.length; i++)
              SizedBox(
                width: cardWidth,
                child: _PlanCard(
                  plan: DemoData.plansCatalog[i],
                  selected: i == selected,
                  onTap: () => onSelect(i),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final SubscriptionPlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.06)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '₹${plan.monthly}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Text(
                  '  /mo',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              plan.tagline,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CycleToggle extends StatelessWidget {
  const _CycleToggle({required this.annual, required this.onChanged});

  final bool annual;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _Chip(
          label: 'Monthly',
          selected: !annual,
          onTap: () => onChanged(false),
        ),
        _Chip(
          label: 'Annual  ·  save 20%',
          selected: annual,
          onTap: () => onChanged(true),
        ),
      ],
    );
  }
}

class _PriceBanner extends StatelessWidget {
  const _PriceBanner({required this.plan, required this.annual});

  final SubscriptionPlan plan;
  final bool annual;

  @override
  Widget build(BuildContext context) {
    final perMonth = annual ? (plan.monthly * 0.8).round() : plan.monthly;
    final cycleText = annual
        ? 'billed ₹${perMonth * 12} / year'
        : 'billed monthly';
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.receipt_long_rounded,
            color: AppColors.primary,
            size: 26,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${plan.name} plan  ·  $cycleText',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹$perMonth /month',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
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
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 14),
        SizedBox(
          width: 86,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.isLast,
    required this.onBack,
    required this.onNext,
  });

  final bool isLast;
  final VoidCallback? onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBack != null)
          OutlinedButton(
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.divider),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            child: const Text('Back'),
          ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: onNext,
          icon: Icon(isLast ? Icons.check_rounded : Icons.arrow_forward_rounded, size: 18),
          label: Text(isLast ? 'Create Property' : 'Next'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _EnabledChip extends StatelessWidget {
  const _EnabledChip({required this.count, required this.total});

  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count of $total enabled',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _TypeGrid extends StatelessWidget {
  const _TypeGrid({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 14.0;
        final cols = constraints.maxWidth >= 640 ? 3 : 1;
        final cardWidth =
            ((constraints.maxWidth - gap * (cols - 1)) / cols).floorToDouble();
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < DemoData.propertyTypes.length; i++)
              SizedBox(
                width: cardWidth,
                child: _TypeCard(
                  type: DemoData.propertyTypes[i],
                  selected: i == selected,
                  onTap: () => onSelect(i),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final PropertyType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.06)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: selected ? 0.14 : 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(type.icon, color: AppColors.primary, size: 23),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          type.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (selected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    type.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleGrid extends StatelessWidget {
  const _ModuleGrid({required this.enabled, required this.onToggle});

  final Map<String, bool> enabled;
  final void Function(String name, bool on) onToggle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 14.0;
        final cols = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 560
            ? 2
            : 1;
        final cardWidth =
            ((constraints.maxWidth - gap * (cols - 1)) / cols).floorToDouble();
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final module in DemoData.serviceModules)
              SizedBox(
                width: cardWidth,
                child: _ModuleToggle(
                  module: module,
                  on: enabled[module.name] ?? false,
                  onChanged: (on) => onToggle(module.name, on),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ModuleToggle extends StatelessWidget {
  const _ModuleToggle({
    required this.module,
    required this.on,
    required this.onChanged,
  });

  final ServiceModule module;
  final bool on;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final accent = on ? AppColors.primary : AppColors.textSecondary;
    return InkWell(
      onTap: () => onChanged(!on),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: on
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: on
                ? AppColors.primary.withValues(alpha: 0.5)
                : AppColors.divider,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(module.icon, size: 20, color: accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    module.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Switch(value: on, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
