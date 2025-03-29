import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CarouselItem {
  final String   imageName  ;
  final String   description;
  final Color    color      ;
  final IconData icon       ;

  CarouselItem({
    required this.imageName  ,
    required this.description,
    required this.color      ,
    required this.icon       ,
  });
}