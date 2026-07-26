import '../models/models.dart';

/// Placeholder data used while the backend is being built.
///
/// Everything here will come from the API later: societies and their towers and
/// units are fetched during registration, and the signed-in user plus their
/// membership come from the session.
class DemoData {
  const DemoData._();

  /// Societies a resident can pick during registration (`societies` table).
  static const societies = <Society>[
    Society(
      id: 1,
      name: 'Sunrise Residency',
      registrationNo: 'PNE/CO-OP/2015/4821',
      address: 'Kothrud',
      city: 'Pune',
      state: 'Maharashtra',
      pincode: '411038',
    ),
    Society(
      id: 2,
      name: 'Green Valley Heights',
      registrationNo: 'MUM/CO-OP/2012/1190',
      address: 'Powai',
      city: 'Mumbai',
      state: 'Maharashtra',
      pincode: '400076',
    ),
    Society(
      id: 3,
      name: 'Palm Meadows',
      registrationNo: 'PNE/CO-OP/2018/7734',
      address: 'Baner',
      city: 'Pune',
      state: 'Maharashtra',
      pincode: '411045',
    ),
    Society(
      id: 4,
      name: 'Lake View Towers',
      registrationNo: 'BLR/CO-OP/2016/2287',
      address: 'Whitefield',
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560066',
    ),
  ];

  /// Towers of the selected society (`towers` table).
  static const towers = <Tower>[
    Tower(id: 1, name: 'A Wing'),
    Tower(id: 2, name: 'B Wing'),
    Tower(id: 3, name: 'C Wing'),
  ];

  /// Units available to claim (`units` table).
  static const units = <Unit>[
    Unit(
      id: 101,
      towerId: 1,
      floor: 4,
      unitNo: '402',
      unitType: '2BHK',
      areaSqft: 985,
      parkingSlots: 1,
    ),
    Unit(
      id: 102,
      towerId: 1,
      floor: 2,
      unitNo: '204',
      unitType: '1BHK',
      areaSqft: 640,
      parkingSlots: 1,
    ),
    Unit(
      id: 103,
      towerId: 2,
      floor: 1,
      unitNo: '101',
      unitType: '3BHK',
      areaSqft: 1320,
      parkingSlots: 2,
    ),
    Unit(
      id: 104,
      towerId: 2,
      floor: 7,
      unitNo: '703',
      unitType: '2BHK',
      areaSqft: 1010,
      parkingSlots: 1,
    ),
    Unit(
      id: 105,
      towerId: 3,
      floor: 3,
      unitNo: '305',
      unitType: '2BHK',
      areaSqft: 995,
      parkingSlots: 1,
    ),
  ];

  /// The signed-in user (`users` table).
  static final signedInUser = AppUser(
    phone: '+91 98765 43210',
    name: 'Rahul Sharma',
    email: 'rahul.sharma@email.com',
    lastLoginAt: DateTime(2026, 7, 26, 9, 15),
  );

  /// Their membership in the current society (`memberships` table).
  static final currentMembership = Membership(
    societyId: 1,
    role: MembershipRole.owner,
    unitId: 101,
    status: MembershipStatus.active,
    startDate: DateTime(2024, 1, 15),
  );

  static Society get currentSociety => societies.first;

  static Unit get currentUnit => units.first;

  static Tower get currentTower =>
      towers.firstWhere((t) => t.id == currentUnit.towerId);
}
