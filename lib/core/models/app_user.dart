/// UI language a user can pick — mirrors the `users.language` enum
/// (`'en' | 'hi' | 'mr'`) in the database schema.
enum AppLanguage {
  en('en', 'English', 'English'),
  hi('hi', 'Hindi', 'हिंदी'),
  mr('mr', 'Marathi', 'मराठी');

  const AppLanguage(this.code, this.label, this.nativeLabel);

  /// Value stored in the database.
  final String code;

  /// English name, for admin-facing text.
  final String label;

  /// Name in its own script, shown in the language picker.
  final String nativeLabel;
}

/// Account state — mirrors the `users.status` enum.
enum UserStatus { active, blocked }

/// A person on the platform. One row per human, no matter how many societies
/// they belong to — mirrors the `users` table.
///
/// | Field | Column | Notes |
/// |---|---|---|
/// | [phone] | `phone VARCHAR(15)` | unique; the login identifier (OTP) |
/// | [name] | `name TEXT` | |
/// | [email] | `email TEXT` | nullable |
/// | [photoUrl] | `photo_url TEXT` | nullable |
/// | [language] | `language enum` | UI preference |
/// | [status] | `status enum` | active / blocked |
/// | [lastLoginAt] | `last_login_at TIMESTAMPTZ` | nullable |
class AppUser {
  const AppUser({
    required this.phone,
    required this.name,
    this.email,
    this.photoUrl,
    this.language = AppLanguage.en,
    this.status = UserStatus.active,
    this.lastLoginAt,
  });

  final String phone;
  final String name;
  final String? email;
  final String? photoUrl;
  final AppLanguage language;
  final UserStatus status;
  final DateTime? lastLoginAt;

  /// Up to two letters for the avatar, e.g. "Rahul Sharma" → "RS".
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  bool get hasEmail => email != null && email!.trim().isNotEmpty;

  AppUser copyWith({
    String? phone,
    String? name,
    String? email,
    String? photoUrl,
    AppLanguage? language,
  }) {
    return AppUser(
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      language: language ?? this.language,
      status: status,
      lastLoginAt: lastLoginAt,
    );
  }
}
