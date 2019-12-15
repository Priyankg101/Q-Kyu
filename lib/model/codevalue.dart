import 'package:flutter/foundation.dart';

class CodeValue {
  final String id;
  final String prodname;
  final double price;
   int qty;

  CodeValue(
    {
      @required this.id,
      @required this.prodname,
      @required this.price,
      @required this.qty
    }
  );
}