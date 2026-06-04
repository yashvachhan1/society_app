import 'package:flutter/material.dart';

/// A standard scrollable dashboard page: responsive outer padding (28px on
/// desktop, 16px on phones) and the resulting content width handed to [builder]
/// (already minus the padding) so pages can lay out responsive grids.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.builder});

  /// Builds the page body. [width] is the available content width.
  final Widget Function(BuildContext context, double width) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pad = constraints.maxWidth < 600 ? 16.0 : 28.0;
        return SingleChildScrollView(
          padding: EdgeInsets.all(pad),
          child: builder(context, constraints.maxWidth - pad * 2),
        );
      },
    );
  }
}
