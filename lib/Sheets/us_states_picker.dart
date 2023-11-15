import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/confirm_button.dart';
import 'package:us_states/us_states.dart';

class USStatesPicker extends ConsumerWidget {
  final TextEditingController controller;
  const USStatesPicker({required this.controller, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usStates = USStates.getAllNames();
    final usStateName = ref.watch(usStateNameProvider);
    final initialIndex =
        usStateName.isEmpty ? 0 : usStates.indexOf(usStateName);
    final scrollController =
        FixedExtentScrollController(initialItem: initialIndex);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.51,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: ConfirmButton(),
          ),
          Expanded(
            child: CupertinoPicker(
              scrollController: scrollController,
              itemExtent: 40,
              onSelectedItemChanged: (value) {
                controller.text = USStates.getAbbreviation(usStates[value])!;
                ref.read(usStateNameProvider.notifier).state = usStates[value];
              },
              children: usStates
                  .map(
                    (state) => Center(
                      child: Text(state),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
