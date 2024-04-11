import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/product_financial_details.dart';
import 'package:jus_mobile_order_app/Widgets/General/select_modifier_options.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/ingredient_grid_view.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/modify_ingredients_grid.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/modify_ingredients_list.dart';
import 'package:jus_mobile_order_app/constants.dart';

class ProductModifierPage extends StatelessWidget {
  final UserModel user;
  final ProductModel product;
  const ProductModifierPage(
      {required this.product, required this.user, super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBrowser: _mobileLayout(context),
      tablet: _mobileLayout(context),
      web: _webLayout(context),
    );
  }

  _mobileLayout(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 12.0),
                  child: Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 18.0),
                    child: Consumer(
                      builder: (context, ref, child) => ProductFinancialDetails(
                        user: user,
                        product: product,
                        memberInfoOnTap: () {
                          _handleMemberOnTap(context, ref);
                        },
                      ),
                    )),
                const Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: ModifyIngredientsList(),
                ),
                Spacing.vertical(10),
                const Divider(
                  thickness: 0.5,
                  color: Colors.black,
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600,
                      ),
                      child: IngredientGridView(
                        product: product,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SelectModifierOptions(
              product: product,
            ),
          ),
        ],
      ),
    );
  }

  _webLayout(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final pastelTan = ref.watch(pastelTanProvider);
      return Row(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SheetHeader(
                            title: product.name,
                            showCloseButton: false,
                          ),
                          Spacing.vertical(20),
                          ProductFinancialDetails(
                            user: user,
                            product: product,
                            memberInfoOnTap: () {
                              _handleMemberOnTap(context, ref);
                            },
                          ),
                          Spacing.vertical(20),
                          const Flexible(
                            child: ModifyIngredientsGrid(),
                          ),
                          Spacing.vertical(50),
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
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SelectModifierOptions(product: product),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: pastelTan,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: IngredientGridView(
                    product: product,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  void _handleMemberOnTap(BuildContext context, WidgetRef ref) {
    if (ResponsiveLayout.isMobileBrowser(context)) {
      Navigator.pop(context);
      Navigator.pop(context);
      NavigationHelpers.handleMembershipNavigation(
        context,
        ref,
        user,
      );
    } else if (ResponsiveLayout.isWeb(context)) {
      Navigator.pop(context);
      NavigationHelpers.handleMembershipNavigation(
        context,
        ref,
        user,
      );
    } else {
      NavigationHelpers.handleMembershipNavigation(
        context,
        ref,
        user,
      );
    }
  }
}
