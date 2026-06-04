/// Society monorepo — shared core library.
///
/// One import gives an app the whole shared design system:
/// `import 'package:society_core/society_core.dart';`
///
/// Used by both `apps/resident` (mobile) and `apps/admin` (web dashboard)
/// so colors, typography, formatting and UI building blocks stay identical.
library;

export 'constants/app_constants.dart';
export 'theme/app_theme.dart';
export 'utils/formatters.dart';
export 'widgets/widgets.dart';
