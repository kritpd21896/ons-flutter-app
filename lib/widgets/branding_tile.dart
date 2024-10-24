// lib/widgets/branding_tile.dart

import 'package:flutter/material.dart';

import '../util/responsive.dart';

class BrandingTile extends StatelessWidget {
  final String imagePath;

  const BrandingTile({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.getWidth(0.02)),
      width: responsive.getWidth(0.6), // Set width based on screen size
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover, // Cover the entire space
        ),
      ),
    );
  }
}