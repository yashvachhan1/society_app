import 'unit.dart';

/// How a person occupies a unit over time — mirrors the `unit_occupancies`
/// table. The current occupant is the record with a null [endDate]; history is
/// kept so dues liability survives an ownership transfer.
///
/// | Field | Column | Notes |
/// |---|---|---|
/// | [unitId] | `unit_id` | which flat |
/// | [type] | `occupancy_type` | owner / tenant |
/// | [agreementStart] | `agreement_start DATE` | tenants only |
/// | [agreementEnd] | `agreement_end DATE` | tenants only; drives expiry reminders |
/// | [startDate] | `start_date DATE` | when they moved in |
/// | [endDate] | `end_date DATE` | null = current occupant |
/// | [documentIds] | `documents JSONB` | references to `files.id` |
class UnitOccupancy {
  const UnitOccupancy({
    required this.unitId,
    required this.type,
    this.agreementStart,
    this.agreementEnd,
    this.startDate,
    this.endDate,
    this.documentIds = const [],
  });

  final int unitId;
  final OccupancyType type;
  final DateTime? agreementStart;
  final DateTime? agreementEnd;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<int> documentIds;

  /// True while this is the occupant in residence.
  bool get isCurrent => endDate == null;

  /// Only tenants have a rent agreement — owners leave these dates empty.
  bool get hasAgreement =>
      type == OccupancyType.tenant && agreementStart != null;

  /// True when a tenant's agreement has already lapsed.
  bool isAgreementExpired(DateTime now) =>
      agreementEnd != null && agreementEnd!.isBefore(now);
}
