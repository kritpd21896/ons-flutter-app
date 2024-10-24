import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Set search bar background color (slightly grey)
        borderRadius: BorderRadius.circular(30), // Rounded corners
      ),
      child: Row(
        children: [
          // Text Field
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none, // Remove default border
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey), // Hint text color
                contentPadding: EdgeInsets.symmetric(horizontal: 16), // Padding for text field
              ),
            ),
          ),
          // Search Icon
          Icon(
            Icons.search,
            color: Colors.pink, // Set the search icon color to pink
          ),
          SizedBox(width: 8), // Space between the icon and text field
        ],
      ),
    );
  }
}