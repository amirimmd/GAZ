import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// Official National Iranian Gas Company / branch organization logo.
class GazLogo extends StatelessWidget {
  const GazLogo({
    super.key,
    this.height = 72,
    this.width,
    this.fit = BoxFit.contain,
  });

  final double height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppConstants.organizationLogoAsset,
      height: height,
      width: width,
      fit: fit,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, __, ___) => Icon(
        Icons.local_gas_station,
        size: height * 0.7,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
