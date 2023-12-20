import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Widgets/General/web_home_banner_template.dart';
import 'package:jus_mobile_order_app/Widgets/General/web_home_products_carousel.dart';

class HomePageWeb extends StatelessWidget {
  const HomePageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      children: [
        WebHomeBannerTemplate(
          backgroundColor: const Color(0xffA4BEC4),
          imagePath: 'assets/bottles_stock_photo.jpeg',
          title: 'Elevate your health.',
          description: 'Nutrient-dense juices, smoothies, bowls, and cleanses '
              'designed to fuel your active, healthy life.',
          callToActionText: 'Order now',
          callToActionOnPressed: () {},
        ),
        Spacing.vertical(40),
        const WebHomeProductsCarousel(),
      ],
    );
  }
}
