import 'package:hooks_riverpod/hooks_riverpod.dart';

final discountTotalProvider =
    StateNotifierProvider<DiscountTotal, List>((ref) => DiscountTotal());

class DiscountTotal extends StateNotifier<List> {
  DiscountTotal() : super([]);

  void add(List<Map<String, dynamic>> totals) {
    List<Map<String, dynamic>> newList = [...state];
    totals.sort((a, b) => b['price'].compareTo(a['price']));
    for (var total in totals) {
      var itemKey = total['itemKey'];
      var matchingItems = newList.where((item) => item['itemKey'] == itemKey);
      var matchingCount = matchingItems.length;

      if (matchingCount != total['itemQuantity']) {
        newList.add({
          'itemKey': itemKey,
          'quantity': 1,
          'amount': total['amount'],
          'price': total['price'],
          'memberPrice': total['memberPrice'],
          'source': total['source']
        });
        break;
      } else {
        Map<String, dynamic> nextHighestPrice = totals.firstWhere(
            (element) =>
                element['price'] < total['price'] &&
                newList
                        .where((item) => item['itemKey'] == element['itemKey'])
                        .length !=
                    element['itemQuantity'],
            orElse: () => {});

        if (nextHighestPrice.isNotEmpty) {
          itemKey = nextHighestPrice['itemKey'];
          matchingItems = newList.where((item) => item['itemKey'] == itemKey);
          matchingCount = matchingItems.length;
          newList.add({
            'itemKey': itemKey,
            'quantity': 1,
            'amount': nextHighestPrice['amount'],
            'price': nextHighestPrice['price'],
            'memberPrice': nextHighestPrice['memberPrice'],
            'source': nextHighestPrice['source'],
          });
          break;
        } else if (total == totals.last) {
          return;
        }
      }
    }
    state = [...newList];
  }

  void remove(int rewardValue) {
    final newList = [...state];
    final filteredList =
        newList.where((item) => item['amount'] == rewardValue).toList();

    if (filteredList.isNotEmpty) {
      filteredList.sort((a, b) => a['price'].compareTo(b['price']));
      final firstItem = filteredList.first;

      if (firstItem != null) {
        newList.remove(firstItem);
      }
    }

    state = newList;
  }

  void removeRewardDiscount() {
    var newList = state;
    newList.removeWhere((element) => element['source'] == 'points');
    state = [...newList];
  }
}
