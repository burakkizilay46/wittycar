import 'package:wittycar_mobile/core/extansions/string_extansions.dart';

class SVGImagePaths {
  static SVGImagePaths? _instance;
  static SVGImagePaths? get instance {
    return _instance ??= SVGImagePaths.init();
  }

  SVGImagePaths.init();

  final cameraSVG = 'camera'.toSVG;
}
