part of 'theme_cubit.dart';

///App theme state
class ThemeState extends Equatable {
  ///Default constructor for [ThemeState] takes in [isLight] parameter to
  ///determine app colors accordingly
  ThemeState({required this.isLight}) {
    primaryColor = isLight ? Colors.deepPurpleAccent : Colors.black;
    secondaryColor = isLight ? Colors.white : Colors.black;
    primaryTextColor = isLight ? Colors.white : Colors.black;
    secondaryTextColor = isLight ? Colors.black : Colors.white;
    errorColor = Colors.red;

    appBarTitleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: primaryTextColor,
      fontSize: 20,
    );

    errorTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      color: errorColor,
      fontSize: 18,
    );

    primaryTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      color: secondaryTextColor,
      fontSize: 14,
    );

    primaryTitleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: secondaryTextColor,
      fontSize: 18,
    );

    secondaryTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      color: secondaryTextColor.withOpacity(0.6),
      fontSize: 14,
    );
  }

  ///[isLight] parameter determines app colors according to
  ///light and dark themes
  final bool isLight;

  ///Primary app color
  late final Color primaryColor;

  ///Secondary app color
  late final Color secondaryColor;

  ///Primary Text color
  late final Color primaryTextColor;

  ///Secondary text color
  late final Color secondaryTextColor;

  ///Error text color
  late final Color errorColor;

  ///Style for app bar text
  late final TextStyle appBarTitleStyle;

  ///Style for error text
  late final TextStyle errorTextStyle;

  ///Style for primary text
  late final TextStyle primaryTextStyle;

  ///Style for secondary text
  late final TextStyle secondaryTextStyle;

  ///Style for title text
  late final TextStyle primaryTitleStyle;

  @override
  List<Object?> get props => [isLight];
}
