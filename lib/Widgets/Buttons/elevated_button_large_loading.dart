import 'package:flutter/material.dart';

class LargeElevatedLoadingButton extends StatelessWidget {
  final Color? buttonColor;
  final Color? iconColor;
  final bool? border;
  final Color? borderColor;
  const LargeElevatedLoadingButton(
      {this.buttonColor,
      this.iconColor,
      this.borderColor,
      this.border,
      super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            Size(MediaQuery.of(context).size.width * 0.9, 50.0),
          ),
          backgroundColor: MaterialStateProperty.all(buttonColor),
          side: border != null
              ? MaterialStateProperty.all(
                  BorderSide(
                    color: border == null
                        ? Colors.transparent
                        : borderColor == null
                            ? Colors.black
                            : borderColor!,
                    width: 1.0,
                  ),
                )
              : null,
        ),
        onPressed: () {},
        child: SizedBox(
          height: 20,
          width: 20,
          child: Center(
            child: CircularProgressIndicator(color: iconColor ?? Colors.white),
          ),
        ),
      ),
    );
  }
}
