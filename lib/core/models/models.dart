/// Barrel file — the app's domain models, each mirroring a table in the
/// Society Management Platform database schema (v1.0):
///
/// `users` · `societies` · `towers` + `units` · `memberships` ·
/// `unit_occupancies`
///
/// ```dart
/// import 'package:society_app/core/models/models.dart';
/// ```
library;

export 'app_user.dart';
export 'membership.dart';
export 'society.dart';
export 'unit.dart';
export 'unit_occupancy.dart';
