class ImageConstants {
  static ImageConstants? _instance;
  static ImageConstants get instance {
    return _instance ??= ImageConstants._init();
  }

  ImageConstants._init();

  String get whiteLogo => toPng('white-logo');

  String toPng(String name) => 'assets/images/$name.png';
}
