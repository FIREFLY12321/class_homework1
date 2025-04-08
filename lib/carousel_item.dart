import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CarouselItem {
  final String       imageName;
  final String       description;
  final Color        color;
  final IconData     icon;
  final List<String> facts; // Adding interesting facts about each item
  final bool         isFavorite; // To enable favorites feature
  final String       soundEffect; // For optional sound effects

  CarouselItem({
    required this.imageName,
    required this.description,
    required this.color,
    required this.icon,
             this.facts          = const [], // Default empty list
             this.isFavorite     = false, // Default not favorite
             this.soundEffect    = '', // Default no sound
  });

  // Copy with method to create a new instance with some properties changed
  CarouselItem copyWith({
    String?       imageName,
    String?       description,
    Color?        color,
    IconData?     icon,
    List<String>? facts,
    bool?         isFavorite,
    String?       soundEffect,
  }) {
    return CarouselItem(
      imageName   : imageName   ?? this.imageName,
      description : description ?? this.description,
      color       : color       ?? this.color,
      icon        : icon        ?? this.icon,
      facts       : facts       ?? this.facts,
      isFavorite  : isFavorite  ?? this.isFavorite,
      soundEffect : soundEffect ?? this.soundEffect,
    );
  }
}