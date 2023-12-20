import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_web_small.dart';
import 'package:jus_mobile_order_app/constants.dart';

class WebHomeBannerTemplate extends StatelessWidget {
  final Color backgroundColor;
  final String imagePath;
  final String title;
  final String description;
  final String callToActionText;
  final VoidCallback callToActionOnPressed;

  const WebHomeBannerTemplate({
    required this.backgroundColor,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.callToActionText,
    required this.callToActionOnPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    var aspectRatio = screenSize.width < AppConstants.mobileWidth
        ? AppConstants.aspectRatioMobile
        : AppConstants.aspectRatioWeb;

    return ResponsiveLayout(
      mobile: _mobileLayout(context),
      web: AspectRatio(
        aspectRatio: aspectRatio,
        child: _webLayout(context),
      ),
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(30.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.circular(25),
              color: backgroundColor,
            ),
            height: AppConstants.screenHeight * 0.4,
            child: _textColumn(
              titleFontSize: 50,
              descriptionFontSize: 28,
              buttonHeight: 175,
              buttonWidth: 60,
            ),
          ),
          _imageCard(context),
        ],
      ),
    );
  }

  Widget _webLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 60.0, vertical: 30.0),
            color: backgroundColor,
            child: _textColumn(
              titleFontSize: 50,
              descriptionFontSize: 30,
              buttonHeight: 180,
              buttonWidth: 70,
            ),
          ),
        ),
        _imageCard(context),
      ],
    );
  }

  Widget _textColumn(
      {required double titleFontSize,
      required double descriptionFontSize,
      required double buttonHeight,
      required double buttonWidth}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TitleText(
          title: title,
          fontSize: titleFontSize,
        ),
        DescriptionText(
          description: description,
          fontSize: descriptionFontSize,
        ),
        SmallElevatedButtonWeb(
          buttonText: callToActionText,
          buttonHeight: buttonHeight,
          buttonWidth: buttonWidth,
          onPressed: callToActionOnPressed,
        ),
      ],
    );
  }

  Widget _imageCard(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  final String title;
  final double fontSize;

  const TitleText({required this.title, required this.fontSize, super.key});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      title,
      style: GoogleFonts.raleway(
          fontSize: fontSize, fontWeight: FontWeight.bold, letterSpacing: -3),
      textAlign: TextAlign.center,
      maxLines: 2,
    );
  }
}

class DescriptionText extends StatelessWidget {
  final String description;
  final double fontSize;

  const DescriptionText(
      {required this.description, required this.fontSize, super.key});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      description,
      style: TextStyle(fontSize: fontSize, letterSpacing: -1),
      textAlign: TextAlign.center,
      maxLines: 3,
    );
  }
}

class ImageCard extends StatelessWidget {
  final String imagePath;
  final Color backgroundColor;

  const ImageCard(
      {required this.imagePath, required this.backgroundColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      color: backgroundColor,
      height: AppConstants.screenHeight * 0.5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Card(
          child: Image.asset(
            imagePath,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
