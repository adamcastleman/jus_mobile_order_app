import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class DescriptionTile {
  final dynamic data;
  final int index;

  DescriptionTile({required this.data, required this.index});

  right() {
    return Stack(
      children: [
        Positioned(
          top: 25.0,
          left: 20.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.perks[index]['name'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Spacing().vertical(10),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: SizedBox(
                  width: 150,
                  child: Text(
                    data.perks[index]['description'],
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            height: 225,
            width: 225,
            child: CachedNetworkImage(
              imageUrl: data.perks[index]['image'],
              placeholder: (context, loading) => const Loading(),
            ),
          ),
        ),
      ],
    );
  }

  left() {
    return Stack(
      children: [
        Positioned(
          top: 45.0,
          right: 20.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.perks[index]['name'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Spacing().vertical(10),
              SizedBox(
                width: 150,
                child: Text(
                  data.perks[index]['description'],
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            height: 225,
            width: 225,
            child: CachedNetworkImage(
              imageUrl: data.perks[index]['image'],
              placeholder: (context, loading) => const Loading(),
            ),
          ),
        ),
      ],
    );
  }
}
