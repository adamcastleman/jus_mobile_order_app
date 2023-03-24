import 'package:flutter/cupertino.dart';

class ChevronRightIcon extends StatelessWidget {
  const ChevronRightIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      CupertinoIcons.chevron_right,
      size: 16,
    );
  }
}
