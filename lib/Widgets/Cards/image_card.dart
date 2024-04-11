import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imagePath;
  final Color backgroundColor;
  final BoxFit? boxFit;

  const ImageCard({
    required this.imagePath,
    required this.backgroundColor,
    this.boxFit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 500;
    final double aspectRatio = isSmallScreen ? 1 : 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      color: backgroundColor,
      padding: isSmallScreen
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.all(30.0),
      child: AspectRatio(
        aspectRatio: aspectRatio, // Use the defined aspect ratio
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: CachedNetworkImage(
            imageUrl: imagePath,
            placeholder: (context, image) => Center(
              child: Container(
                color: backgroundColor,
              ),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.error, size: 50.0, color: Colors.black),
            ),
            fit: boxFit ?? BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
