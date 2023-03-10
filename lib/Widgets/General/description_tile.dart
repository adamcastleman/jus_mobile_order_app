import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';

class DescriptionTile {
  final dynamic data;
  final int index;

  DescriptionTile({required this.data, required this.index});

  imageRight() {
    return Stack(
      children: [
        Positioned(
          top: 5.0,
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
          alignment: Alignment.bottomRight,
          child: SizedBox(
            height: 200,
            width: 200,
            child: CachedNetworkImage(
              fit: BoxFit.fitHeight,
              imageUrl: data.perks[index]['image'],
              placeholder: (context, loading) => const Loading(),
            ),
          ),
        ),
      ],
    );
  }

  imageLeft({bool? largeImage}) {
    return Stack(
      children: [
        Positioned(
          top: 5.0,
          right: 30.0,
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
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            height: 200,
            width: 200,
            child: CachedNetworkImage(
              imageUrl: data.perks[index]['image'],
              fit: BoxFit.fitHeight,
              placeholder: (context, loading) => const Loading(),
            ),
          ),
        ),
      ],
    );
  }
}
