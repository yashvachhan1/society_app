/// Onboarding state of a society — mirrors the `societies.status` enum.
enum SocietyStatus { setup, live, suspended }

/// One tenant society — mirrors the `societies` table.
///
/// | Field | Column |
/// |---|---|
/// | [name] | `name TEXT` |
/// | [registrationNo] | `registration_no TEXT` (co-op registration number) |
/// | [address] | `address TEXT` |
/// | [city] / [state] / [pincode] | `city / state / pincode TEXT` |
/// | [logoUrl] | `logo_url TEXT` (nullable) |
/// | [status] | `status enum` |
class Society {
  const Society({
    required this.id,
    required this.name,
    required this.registrationNo,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.logoUrl,
    this.status = SocietyStatus.live,
  });

  final int id;
  final String name;
  final String registrationNo;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String? logoUrl;
  final SocietyStatus status;

  /// "Kothrud, Pune" — the short line shown under the society name.
  String get shortLocation => '$address, $city';

  /// Full address as one line, used on the review and profile screens.
  String get fullAddress => '$address, $city, $state - $pincode';
}
