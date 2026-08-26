import 'package:flutter/material.dart';

class AttributeColor {
  static List<Color?> getColors() {
    return [
      // General colors
      Colors.red,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.grey,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.blueGrey,
      Colors.black,

      // Unique iPhone and Samsung colors

      // const Color(0xFF1C1C1E), // Midnight
      // const Color(0xFFFBFBFC), // Starlight
      // const Color(0xFF979797), // Silver (iPhone/Samsung)
      // const Color(0xFF3B3B3D), // Space Gray
      // const Color(0xFFB8B8B9), // Graphite
      // const Color(0xFFF1E3D3), // Gold
      // const Color(0xFF0A84FF), // Blue (iPhone)
      // const Color(0xFF007AFF), // Pacific Blue
      // const Color(0xFF6C3A5B), // Deep Purple (iPhone)
      // const Color(0xFF0A0A0A), // Phantom Black
      // const Color(0xFFD1D1D1), // Phantom Silver
      // const Color(0xFF8B572A), // Mystic Bronze
      // const Color(0xFFA8C5A7), // Cloud Mint
      // const Color(0xFFB9C8D3), // Cloud Blue
      // const Color(0xFF454545), // Cosmic Gray
      // const Color(0xFFF9EADA), // Aura Glow
    ];
  }

  static Color? getColor(String value) {
    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Purple') {
      return Colors.purple;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else if (value == 'Brown') {
      return Colors.brown;
    } else if (value == 'Teal') {
      return Colors.teal;
    } else if (value == 'Indigo') {
      return Colors.indigo;
    } else if (value == 'Yellow') {
      return Colors.yellow;
    } else if (value == 'Orange') {
      return Colors.orange;
    }
    return null;
  }

  static String getColorName(Color? color) {
    if (color == Colors.red) return 'Red';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.deepPurple) return 'DeepPurple';
    if (color == Colors.indigo) return 'Indigo';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.lightBlue) return 'Light Blue';
    if (color == Colors.cyan) return 'Cyan';
    if (color == Colors.teal) return 'Teal';
    if (color == Colors.green) return 'Green';
    if (color == Colors.lightGreen) return 'Light Green';
    if (color == Colors.lime) return 'Lime';
    if (color == Colors.yellow) return 'Yellow';
    if (color == Colors.amber) return 'Amber';
    if (color == Colors.grey) return 'Grey';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.deepOrange) return 'Deep Orange';
    if (color == Colors.brown) return 'Brown';
    if (color == Colors.blueGrey) return 'Blue Grey';
    if (color == Colors.black) return 'Black';

    return 'Null';
  }
}
