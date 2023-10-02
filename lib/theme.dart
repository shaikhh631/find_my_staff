import 'package:flutter/material.dart';

Color primaryColor = Colors.black; // Initialize with default color

Color getColorIndex(int idx) {
  switch (idx) {
    case 1:
      return Colors.green;
      break;
  }
  return Colors.black;
}
