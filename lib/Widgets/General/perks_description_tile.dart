import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';

class PerksDescriptionTileImageRight extends StatelessWidget {
  final String name;
  final String description;
  final String imageURL;

  const PerksDescriptionTileImageRight({
    required this.name,
    required this.description,
    required this.imageURL,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 5.0,
          left: 20.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 150,
                child: Text(
                  description,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            height: 200,
            width: 200,
            child: CachedNetworkImage(
              fit: BoxFit.fitHeight,
              imageUrl: imageURL,
              placeholder: (context, loading) => const Loading(),
            ),
          ),
        ),
      ],
    );
  }
}

class PerksDescriptionTileImageLeft extends StatelessWidget {
  final String name;
  final String description;
  final String imageURL;

  const PerksDescriptionTileImageLeft({
    required this.name,
    required this.description,
    required this.imageURL,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 5.0,
          right: 30.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 150,
                child: Text(
                  description,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            height: 200,
            width: 200,
            child: CachedNetworkImage(
              imageUrl: imageURL,
              fit: BoxFit.fitHeight,
              placeholder: (context, loading) => const Loading(),
            ),
          ),
        ),
      ],
    );
  }
}
