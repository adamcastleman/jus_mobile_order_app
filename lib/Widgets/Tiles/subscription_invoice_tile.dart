import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Models/subscription_invoice_model.dart';

class SubscriptionInvoiceTile extends StatelessWidget {
  final SubscriptionInvoiceModel invoice;
  final bool? showTrailingDate;
  const SubscriptionInvoiceTile(
      {required this.invoice, this.showTrailingDate = true, super.key});

  @override
  Widget build(BuildContext context) {
    DateTime invoiceDate = DateTime.parse(invoice.paymentDate);
    String formattedInvoiceDate = DateFormat('M/d/yyyy').format(invoiceDate);
    return ListTile(
      dense: true,
      leading: const Icon(CupertinoIcons.refresh),
      title: Text(
        '\$${PricingHelpers.formatAsCurrency(invoice.price / 100)}',
        style: const TextStyle(fontSize: 18),
      ),
      subtitle: AutoSizeText(
        invoice.itemName,
        maxLines: 1,
        minFontSize: 12,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: showTrailingDate == true
          ? Text(
              formattedInvoiceDate,
              style: const TextStyle(fontSize: 16),
            )
          : const SizedBox(),
    );
  }
}
