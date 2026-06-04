import 'package:intl/intl.dart';

final NumberFormat _rupeeFormat =
    NumberFormat.currency(locale: 'en_IN', symbol: '₹ ', decimalDigits: 0);

/// Formats an amount as Indian Rupees with thousands grouping, e.g. `₹ 4,850`.
/// A single formatter keeps currency display consistent across every screen.
String formatRupees(num amount) => _rupeeFormat.format(amount);
