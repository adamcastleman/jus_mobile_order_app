import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_web_small.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/image_card.dart';
import 'package:jus_mobile_order_app/constants.dart';
import 'package:jus_mobile_order_app/theme_data.dart';

class CallToActionBanner extends StatelessWidget {
  final Color backgroundColor;
  final String imagePath;
  final String title;
  final String description;
  final int? titleMaxLines;
  final int? descriptionMaxLines;
  final String callToActionText;
  final VoidCallback callToActionOnPressed;
  final bool? isImageOnRight;

  const CallToActionBanner({
    required this.backgroundColor,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.callToActionText,
    required this.callToActionOnPressed,
    this.isImageOnRight = true,
    this.titleMaxLines,
    this.descriptionMaxLines,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.width;

// Use mobile aspect ratio for screens up to 800px wide
    var aspectRatio = screenSize < AppConstants.mobilePhoneWidth
        ? AppConstants.aspectRatioMobilePhone
        : screenSize <= 800
            ? AppConstants.aspectRatioMobileBrowser
            : AppConstants.aspectRatioWeb;

// Use the mobile layout for screens up to 800px wide, and the web layout for larger screens
    return ResponsiveLayout(
      mobileBrowser: _mobilePhoneLayout(context),
      tablet: screenSize <= 800
          ? _tabletLayout(context)
          : AspectRatio(
              aspectRatio: aspectRatio,
              child: _webLayout(context),
            ),
      web: AspectRatio(
        aspectRatio: aspectRatio,
        child: _webLayout(context),
      ),
    );
  }

  Widget _mobilePhoneLayout(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacing.vertical(8),
          Flexible(
            child: ImageCard(
              imagePath: imagePath,
              backgroundColor: backgroundColor,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            height: AppConstants.screenHeight * 0.1,
            width: 450,
            child: _textColumn(
              titleFontSize: 28,
              descriptionFontSize: 18,
              buttonHeight: AppConstants.buttonHeightPhone,
              buttonWidth: AppConstants.buttonWidthPhone,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabletLayout(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.all(30.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(25),
                color: backgroundColor,
              ),
              height: AppConstants.screenHeight * 0.4,
              width: double.infinity,
              child: _textColumn(
                titleFontSize: 28,
                descriptionFontSize: 18,
                buttonHeight: AppConstants.buttonHeightPhone,
                buttonWidth: AppConstants.buttonWidthPhone,
              ),
            ),
          ),
          Flexible(
            child: ImageCard(
              imagePath: imagePath,
              backgroundColor: backgroundColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _webLayout(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      child: isImageOnRight == true
          ? _imageOnRightDisplay()
          : _imageOnLeftDisplay(),
    );
  }

  Widget _imageOnRightDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 60.0, vertical: 30.0),
            color: backgroundColor,
            child: _textColumn(
              titleFontSize: 40,
              descriptionFontSize: 20,
              buttonHeight: AppConstants.buttonHeightWeb,
              buttonWidth: AppConstants.buttonWidthWeb,
            ),
          ),
        ),
        Flexible(
          child: ImageCard(
            imagePath: imagePath,
            backgroundColor: backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget _imageOnLeftDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: ImageCard(
            imagePath: imagePath,
            backgroundColor: backgroundColor,
          ),
        ),
        Flexible(
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 60.0, vertical: 30.0),
            color: backgroundColor,
            child: _textColumn(
              titleFontSize: 40,
              descriptionFontSize: 20,
              buttonHeight: AppConstants.buttonHeightWeb,
              buttonWidth: AppConstants.buttonWidthWeb,
            ),
          ),
        ),
      ],
    );
  }

  Widget _textColumn(
      {required double titleFontSize,
      required double descriptionFontSize,
      required double buttonHeight,
      required double buttonWidth}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        TitleText(
          text: title,
          fontSize: titleFontSize,
          maxLines: titleMaxLines,
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
            child: DescriptionText(
              text: description,
              fontSize: descriptionFontSize,
              maxLines: descriptionMaxLines,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: PlatformUtils.isWeb() ? 12.0 : 0.0,
          ),
          child: SmallElevatedButtonWeb(
            buttonText: callToActionText,
            buttonHeight: buttonHeight,
            buttonWidth: buttonWidth,
            onPressed: callToActionOnPressed,
          ),
        ),
      ],
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return _mobilePhoneLayout(context);
  }
}
