/// A visitor logged against a flat, with check-in/out times and entry method.
class Guest {
  const Guest({
    required this.name,
    required this.relation,
    required this.checkIn,
    required this.checkOut,
    required this.flat,
    required this.vehicleNo,
    required this.status,
  });

  final String name;
  final String relation;
  final String checkIn;
  final String checkOut;
  final String flat;
  final String vehicleNo;
  final String status;

  bool get hasVehicle => vehicleNo != '—';

  String get initial => name.isEmpty ? '?' : name[0].toUpperCase();
}
