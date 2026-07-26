import 'package:intl/intl.dart';

final NumberFormat _rupeeFormat =
    NumberFormat.currency(locale: 'en_IN', symbol: '₹ ', decimalDigits: 0);

final DateFormat _dayFormat = DateFormat('d MMM yyyy');
final DateFormat _dayTimeFormat = DateFormat('d MMM yyyy, HH:mm');

/// Placeholder shown wherever a nullable field has no value.
const String kNoValue = '—';

/// Formats an amount as Indian Rupees with thousands grouping, e.g. `₹ 4,850`.
/// A single formatter keeps currency display consistent across every screen.
String formatRupees(num amount) => _rupeeFormat.format(amount);

/// Formats a date as `15 Jan 2024`, or [kNoValue] when null. Used for the
/// nullable `DATE` columns (membership start, agreement dates).
String formatDate(DateTime? date) =>
    date == null ? kNoValue : _dayFormat.format(date);

/// Formats a timestamp as `26 Jul 2026, 09:15`, or [kNoValue] when null. Used
/// for `TIMESTAMPTZ` columns such as `users.last_login_at`.
String formatDateTime(DateTime? timestamp) =>
    timestamp == null ? kNoValue : _dayTimeFormat.format(timestamp);
