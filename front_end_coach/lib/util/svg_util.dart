import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class SvgUtil {
  static Widget getSvg(String name,
      {double? width,
      double? height,
      ColorFilter? colorFilter,
      String? semanticsLabel}) {
    return SvgPicture.asset(
      'assets/$name.svg',
      width: width,
      height: height,
      colorFilter: colorFilter,
      semanticsLabel: semanticsLabel,
    );
  }
}
