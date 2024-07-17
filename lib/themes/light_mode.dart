import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Color.fromARGB(
        255, 249, 233, 227), // A vibrant but not too bright color
    secondary: const Color.fromARGB(
        255, 240, 169, 169), // Complements the primary color
    tertiary: Color.fromARGB(
        255, 134, 152, 160), // Adds contrast for tertiary elements
    inversePrimary: Colors.deepPurple, // A rich, darker color for inverses
  ),
);
