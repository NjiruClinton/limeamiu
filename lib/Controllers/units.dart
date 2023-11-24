

import 'package:flutter/material.dart';

class Units{
  static BuildContext? context;


  static double pixel6measurements({required double measurement,
    bool? height,
    double? max,
    double? min,
  }) {
    final contextHeight = MediaQuery
        .sizeOf(context!)
        .height;
    final contextWidth = MediaQuery
        .sizeOf(context!)
        .width;

    if (height != null || height == true) {
      if (max != null &&
          max >= contextHeight * (measurement / 843.4285714285714)) {
        return max;
      } else {
        if (min != null &&
            min <= contextHeight * (measurement / 843.4285714285714)) {
          return min;
        } else {
          return contextHeight * (measurement / 843.4285714285714);
        }
      }
    } else {
      if (max != null &&
          max >= contextWidth * (measurement / 411.42857142857144)) {
        return max;
      } else {
        if (min != null &&
            min <= contextWidth * (measurement / 411.42857142857144)) {
          return min;
        } else {
          return contextWidth * (measurement / 411.42857142857144);
        }
      }
    }
  }
}