/// A person's role inside one society — mirrors the `memberships.role` enum.
/// Permissions always come from a membership, never from a global user flag.
enum MembershipRole {
  admin('Admin'),
  chairman('Chairman'),
  treasurer('Treasurer'),
  committee('Committee Member'),
  owner('Owner'),
  tenant('Tenant'),
  guard('Guard'),
  staff('Staff'),
  accountant('Accountant');

  const MembershipRole(this.label);

  final String label;
}

/// Approval state of a membership — mirrors the `memberships.status` enum.
/// A self-registered resident starts as [pending] until an admin approves.
enum MembershipStatus {
  pending('Pending approval'),
  active('Active'),
  rejected('Rejected'),
  ended('Ended');

  const MembershipStatus(this.label);

  final String label;
}

/// The link between a user, a society and a role — mirrors the `memberships`
/// table, the heart of access control.
///
/// | Field | Column | Notes |
/// |---|---|---|
/// | [societyId] | `society_id` | which society |
/// | [role] | `role enum` | owner / tenant / admin … |
/// | [unitId] | `unit_id` | nullable; set for owner and tenant roles |
/// | [status] | `status enum` | pending until an admin approves |
/// | [startDate] | `start_date DATE` | |
/// | [endDate] | `end_date DATE` | set on move-out / role end |
class Membership {
  const Membership({
    required this.societyId,
    required this.role,
    this.unitId,
    this.status = MembershipStatus.pending,
    this.startDate,
    this.endDate,
  });

  final int societyId;
  final MembershipRole role;
  final int? unitId;
  final MembershipStatus status;
  final DateTime? startDate;
  final DateTime? endDate;

  bool get isActive => status == MembershipStatus.active;
  bool get isPending => status == MembershipStatus.pending;

  /// Residents (owner/tenant) are attached to a unit; committee roles are not.
  bool get isResident =>
      role == MembershipRole.owner || role == MembershipRole.tenant;
}
