import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';

class TitleApp extends StatelessWidget {
  const TitleApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Daily",
          style: GoogleFonts.nunito(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: defaultTextPrimaryLayoutColor,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          "List",
          style: GoogleFonts.nunito(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: createThemeColorSchema(
              darkColor: yellow,
              lightColor: orange,
            ),
          ),
        ),
      ],
    );
  }
}
