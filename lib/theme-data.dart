import 'package:flutter/material.dart';
// import './scoped-models/main.dart';

class AppTheme {
  AppTheme._();
  // final MainModel _model = MainModel();
  
  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFFFFFF);
  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color blueText = Color(0xff0057f7);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);

  static const TextTheme textTheme = TextTheme(
    display1: display1,
    headline: headline,
    title: title,
    subtitle: subtitle,
    body2: body2,
    body1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle( // h4 -> display1
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: nearlyWhite,
  );

    static const TextStyle displayDark = TextStyle( // h4 -> display1
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.w500,
    fontSize: 30,
    letterSpacing: 0.1,
    height: 0.9,
    color: Colors.white,
  );

  static const TextStyle headline = TextStyle( // h5 -> headline
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.w500,
    fontSize: 20,
    letterSpacing: 0.27,
    color: darkText
  );

    static const TextStyle headlineDarkBg = TextStyle( // h5 -> headline
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.w500,
    fontSize: 20,
    letterSpacing: 0.27,
    color: nearlyWhite
  );

      static const TextStyle headlineDarkBgLight = TextStyle( // h5 -> headline
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.normal,
    fontSize: 18,
    letterSpacing: 0.27,
    color: nearlyWhite
  );

  static const TextStyle headlineSuccess = TextStyle( // h5 -> headline
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.w500,
    fontSize: 20,
    letterSpacing: 0.27,
    color: Colors.green
  );

  static const TextStyle title = TextStyle( // h6 -> title
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );


  static const TextStyle titleDark54 = TextStyle( // h6 -> title
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.w700,
    fontSize: 15,
    letterSpacing: 0.18,
    color: Colors.black54,
  );

  static const TextStyle titleBlue = TextStyle( // h6 -> title
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.bold,
    fontSize: 14,
    letterSpacing: 0.18,
    color: Color(0xffffcc00),
  );

    static const TextStyle titleDarkBg = TextStyle( // h6 -> title
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.normal,
    fontSize: 14,
    letterSpacing: 0.18,
    color: nearlyWhite,
  );

  static const TextStyle subtitle = TextStyle( // subtitle2 -> subtitle
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );
    static const TextStyle subtitleDarkBg = TextStyle( // subtitle2 -> subtitle
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.w300,
    fontSize: 12,
    letterSpacing: -0.04,
    color: nearlyWhite,
  );

  static const TextStyle body2 = TextStyle( // body1 -> body2
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

    static const TextStyle body3 = TextStyle( // body1 -> body2
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.w400,
    fontSize: 15,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body3DarkBg = TextStyle( // body1 -> body2
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.w400,
    fontSize: 15,
    letterSpacing: 0.2,
    color: Colors.white,
  );

  static const TextStyle body1 = TextStyle( // body2 -> body1
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

    static const TextStyle body1DarkBg = TextStyle( // body2 -> body1
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: Colors.white,
  );

  static const TextStyle caption = TextStyle( // Caption -> caption
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: nearlyWhite, // was lightText
  );

    static const TextStyle captionDark = TextStyle( // Caption -> caption
    fontFamily: 'BigSpace',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: darkText, // was lightText
  );

}

// flexPlayThemeDarkBoxDecoration() {
//   final MainModel _model = MainModel();
//   return BoxDecoration(
//     gradient: LinearGradient(
//       // Where the linear gradient begins and ends
//       begin: Alignment.topRight,
//       end: Alignment.bottomLeft,
//       // Add one stop for each color. Stops should increase from 0 to 1
//       stops: [0.5, 0.4, 0.6, 0.8],
//       colors: [
//         // Colors are easy thanks to Flutter's Colors class.
//         Colors.black12,
//         Color(0xff767d89),
//         Colors.black54,
//         Colors.black,
//       ],
//     ),
//     // color: Colors.black
//   );
// }

// flexPlayThemeLightBoxDecoration() {
//   final MainModel _model = MainModel();
//   return BoxDecoration(
//     gradient: LinearGradient(
//       // Where the linear gradient begins and ends
//       begin: Alignment.topRight,
//       end: Alignment.bottomLeft,
//       // Add one stop for each color. Stops should increase from 0 to 1
//       stops: [0.5, 0.8],
//       colors: [
//         // Colors are easy thanks to Flutter's Colors class.
//         Colors.white,
//         // Colors.white60,
//         // Colors.white70,
//         Colors.white24,
//       ],
//     ),
//     // color: Colors.black
//   );
// }

// changeTheme() {
//   flexPlayThemeLightBoxDecoration();
// }
  

