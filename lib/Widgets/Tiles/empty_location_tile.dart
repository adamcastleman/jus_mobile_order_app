import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class EmptyLocationTile extends StatelessWidget {
  const EmptyLocationTile({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No nearby stores',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: AutoSizeText(
              'It looks like we don\'t currently have any stores within this area, or we can\'t display them right now.',
              maxLines: 2,
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );

    //   Container(
    //   color: Colors.white,
    //   width: MediaQuery.of(context).size.width * 0.8,
    //   child: ListTile(
    //     isThreeLine: true,
    //     contentPadding: const EdgeInsets.all(15.0),
    //     tileColor: Colors.white,
    //     title: Text(
    //       'No nearby stores',
    //       style: Theme.of(context).textTheme.headlineSmall,
    //     ),
    //     subtitle: const Padding(
    //       padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             'It looks like we don\'t currently have any stores within this area. Or, we can\'t display them right now.',
    //             style: TextStyle(fontSize: 14),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
