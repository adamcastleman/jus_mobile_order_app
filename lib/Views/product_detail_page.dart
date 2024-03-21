import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_ingredients.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/product_modifier_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/favorite_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/allergy_info.dart';
import 'package:jus_mobile_order_app/Widgets/General/perks_info.dart';
import 'package:jus_mobile_order_app/Widgets/General/points_value_item_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/product_financial_details.dart';
import 'package:jus_mobile_order_app/Widgets/General/select_product_options.dart';
import 'package:jus_mobile_order_app/Widgets/General/size_selector.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/select_toppings_grid_view.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/unmodifiable_ingredient_grid.dart';
import 'package:jus_mobile_order_app/constants.dart';

import '../Widgets/General/nutrition_facts.dart';

class ProductDetailPage extends ConsumerWidget {
  final ProductModel product;
  final List<IngredientModel> ingredients;
  final VoidCallback? onNavigationChange;

  const ProductDetailPage(
      {required this.product,
      required this.ingredients,
      this.onNavigationChange,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final productOptionsColor = ref.watch(backgroundColorProvider);
    final editOrder = ref.watch(editOrderProvider);
    final pastelTan = ref.watch(pastelTanProvider);

    return ResponsiveLayout(
      mobileBrowser:
          _mobileLayout(context, ref, user, editOrder, productOptionsColor),
      tablet: _mobileLayout(context, ref, user, editOrder, productOptionsColor),
      web: _webLayout(
          context, ref, user, editOrder, productOptionsColor, pastelTan),
    );
  }

  _mobileLayout(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
    bool editOrder,
    Color productOptionsColor,
  ) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: editOrder != true
            ? FavoriteButton(product: product)
            : const SizedBox(),
        actions: [
          editOrder != true
              ? JusCloseButton(
                  onPressed: () => _handleCloseProviders(context, ref),
                )
              : const SizedBox(),
        ],
      ),
      body: OpenContainer(
        tappable: false,
        openColor: productOptionsColor,
        closedColor: productOptionsColor,
        closedElevation: 0,
        openElevation: 0,
        transitionDuration: const Duration(milliseconds: 900),
        transitionType: ContainerTransitionType.fadeThrough,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        openBuilder: (context, _) => SafeArea(
          bottom: false,
          child: ProductModifierPage(
            product: product,
            user: user,
          ),
        ),
        closedBuilder: (context, close) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
                primary: false,
                children: [
                  Center(
                    child: Hero(
                      tag: 'product-image',
                      child: SizedBox(
                        height: 300,
                        child: CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          imageUrl: product.image,
                          placeholder: (context, url) => const Loading(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  Spacing.vertical(40),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Spacing.vertical(20),
                  determineSizeSelector(),
                  ProductFinancialDetails(
                    user: user,
                    product: product,
                    memberInfoOnTap: () =>
                        _handleMemberOnTap(context, ref, user),
                  ),
                  Spacing.vertical(10),
                  PointsValueItemWidget(
                    padding: 4.0,
                    product: product,
                    fontSize: 14,
                    hasBorder: true,
                  ),
                  determineIngredientGrid(context, ref, close),
                  PerksInfo(product: product),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: NutritionFacts(
                        product: product,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: AllergyInfo(
                        product: product,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SelectProductOptions(
              product: product,
              close: close,
            ),
          ],
        ),
      ),
    );
  }

  _webLayout(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
    bool editOrder,
    Color productOptionsColor,
    Color productDetailsColor,
  ) {
    return OpenContainer(
      tappable: false,
      openColor: productOptionsColor,
      closedColor: productOptionsColor,
      closedElevation: 0,
      openElevation: 0,
      transitionDuration: const Duration(milliseconds: 900),
      transitionType: ContainerTransitionType.fadeThrough,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      openBuilder: (context, _) =>
          ProductModifierPage(user: user, product: product),
      closedBuilder: (context, close) => Row(
        children: [
          SizedBox(
            height: AppConstants.screenHeight,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 450,
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      bottom: 60.0,
                    ), // Bottom padding should be enough to not overlap with SelectProductOptions
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SheetHeader(
                            title: product.name,
                            trailingButtons: [
                              FavoriteButton(
                                product: product,
                              ),
                            ],
                            onClose: () => _handleCloseProviders(context, ref),
                          ),
                          Spacing.vertical(20),
                          determineSizeSelector(),
                          ProductFinancialDetails(
                            user: user,
                            product: product,
                            memberInfoOnTap: () =>
                                _handleMemberOnTap(context, ref, user),
                          ),
                          determineIngredientGrid(context, ref, close),
                          Spacing.vertical(20),
                          NutritionFacts(
                            product: product,
                          ),
                          Spacing.vertical(20),
                          PerksInfo(product: product),
                          Spacing.vertical(20),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: _determineBottomPadding()),
                            child: AllergyInfo(
                              product: product,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child:
                          SelectProductOptions(close: close, product: product),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: productDetailsColor,
              child: Center(
                child: Hero(
                  tag: 'product-image',
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 500,
                      maxWidth: 500,
                    ),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: product.image,
                      placeholder: (context, url) => const Loading(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  determineIngredientGrid(BuildContext context, WidgetRef ref, Function close) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
      child: !product.isModifiable && product.hasToppings
          ? const SelectToppingsGridView()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product.isModifiable ? 'Current ' : ''}${product.isScheduled ? 'Items' : 'Ingredients'}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Spacing.vertical(15),
                InkWell(
                  onTap: () {
                    determineModificationPageNavigation(ref, close);
                  },
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: UnmodifiableIngredientGridView(
                      product: product,
                      ingredients: ingredients,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  determineSizeSelector() {
    if (product.isScheduled) {
      return const SizedBox();
    } else if (!product.isModifiable && !product.hasToppings) {
      return const SizedBox();
    } else {
      return SizeSelector(
        product: product,
      );
    }
  }

  determineModificationPageNavigation(WidgetRef ref, Function close) {
    if (product.isModifiable) {
      HapticFeedback.lightImpact();
      StandardIngredients(ref: ref).add();
      close();
    } else {
      return null;
    }
  }

  void _handleCloseProviders(BuildContext context, WidgetRef ref) {
    HapticFeedback.lightImpact();
    ref.invalidate(selectedIngredientsProvider);
    ref.invalidate(selectedAllergiesProvider);
    ref.invalidate(itemQuantityProvider);
    ref.invalidate(scheduledQuantityProvider);
    ref.invalidate(itemSizeProvider);
    ref.invalidate(selectedProductIdProvider);
    ref.invalidate(favoriteItemNameProvider);
    Navigator.pop(context);
  }

  double _determineBottomPadding() {
    if (AppConstants.screenWidth > AppConstants.tabletWidth) {
      return product.isScheduled ? 200.0 : 100.0;
    } else {
      return 20.0;
    }
  }

  void _handleMemberOnTap(BuildContext context, WidgetRef ref, UserModel user) {
    if (PlatformUtils.isWeb()) {
      onNavigationChange
          ?.call(); // Assuming this is a callback function, use ?.call() to safely invoke it if it's not null
      NavigationHelpers.popEndDrawer(context);
      _handleCloseProviders(context, ref);
    } else {
      HapticFeedback.lightImpact();
      NavigationHelpers.handleMembershipNavigation(
        context,
        ref,
        user,
        showCloseButton: true,
      );
    }
  }
}
