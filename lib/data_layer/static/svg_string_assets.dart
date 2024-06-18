///Singleton class to store svg assets as [String]
class SvgStringAssets {
  ///factory constructor to always return the same instance of [SvgStringAssets]
  factory SvgStringAssets() => _svgStringAssets;
  SvgStringAssets._();

  static final SvgStringAssets _svgStringAssets = SvgStringAssets._();
}
