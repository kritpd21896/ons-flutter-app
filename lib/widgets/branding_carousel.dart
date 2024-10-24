import 'package:flutter/material.dart';
import '../util/responsive.dart';
import 'branding_tile.dart'; // Import the BrandingTile widget

class BrandingCarousel extends StatefulWidget {
  final List<String> brandingImages; // List of branding images

  BrandingCarousel({required this.brandingImages});

  @override
  _BrandingCarouselState createState() => _BrandingCarouselState();
}

class _BrandingCarouselState extends State<BrandingCarousel> {
  int _currentIndex = 0; // Track the current index of the carousel

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // BrandingTile Carousel
        Container(
          height: responsive.getHeight(0.25), // Set height for the carousel
          child: PageView.builder(
            itemCount: widget.brandingImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index; // Update current index when swiped
              });
            },
            itemBuilder: (context, index) {
              return BrandingTile(
                imagePath: widget.brandingImages[index],
              ); // Use BrandingTile to display the image
            },
          ),
        ),
        SizedBox(height: responsive.getHeight(0.01)), // Space between carousel and dots

        // Bullet Dots for active page indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.brandingImages.length,
                (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              height: 8.0,
              width: _currentIndex == index ? 20.0 : 8.0, // Size changes for active dot
              decoration: BoxDecoration(
                color: _currentIndex == index ? Colors.black : Colors.grey, // Active/inactive dot color
                borderRadius: BorderRadius.circular(12), // Rounded dots
              ),
            ),
          ),
        ),
      ],
    );
  }
}