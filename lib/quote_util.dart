// quote_util.dart

import 'package:flutter/material.dart';
import 'package:quote/quote_page.dart';

void navigateToQuotePage(BuildContext context, int quoteId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => QuotePage(quoteId: quoteId),
    ),
  );
}
