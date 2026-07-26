/// A tower / wing inside a society — mirrors the `towers` table
/// (`id`, `society_id`, `name`).
class Tower {
  const Tower({required this.id, required this.name});

  final int id;

  /// e.g. "A Wing".
  final String name;
}

/// Occupancy state of a unit — mirrors the `units.status` enum.
enum UnitStatus { occupied, vacant, locked }

/// An individual flat / unit — mirrors the `units` table.
///
/// | Field | Column | Notes |
/// |---|---|---|
/// | [towerId] | `tower_id` | which wing it belongs to |
/// | [floor] | `floor SMALLINT` | |
/// | [unitNo] | `unit_no TEXT` | unique within (society, tower) |
/// | [unitType] | `unit_type TEXT` | 1BHK / 2BHK / shop / office |
/// | [areaSqft] | `area_sqft NUMERIC(8,2)` | basis for per-sqft billing |
/// | [parkingSlots] | `parking_slots SMALLINT` | count |
/// | [status] | `status enum` | occupied / vacant / locked |
class Unit {
  const Unit({
    required this.id,
    required this.towerId,
    required this.floor,
    required this.unitNo,
    required this.unitType,
    required this.areaSqft,
    required this.parkingSlots,
    this.status = UnitStatus.vacant,
  });

  final int id;
  final int towerId;
  final int floor;
  final String unitNo;
  final String unitType;
  final double areaSqft;
  final int parkingSlots;
  final UnitStatus status;

  /// "A-402" style label built from the tower name.
  String labelWith(Tower tower) => '${tower.name.split(' ').first}-$unitNo';
}

/// How a person occupies a unit — mirrors the `unit_occupancies.occupancy_type`
/// enum. Owners and tenants see different things in the app.
enum OccupancyType {
  owner('Owner', 'I own this flat'),
  tenant('Tenant', 'I rent this flat');

  const OccupancyType(this.label, this.description);

  final String label;
  final String description;
}
