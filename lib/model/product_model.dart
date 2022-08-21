import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../components/extenstion.dart';

class ProductModel {
  late String pid,pname, image, brand, size;
  late int price;
  late Color color;

  ProductModel(
      {
        required this.pid,
        required this.pname,
        required this.image,
        required this.brand,
        required this.color,
        required this.size,
        required this.price});

  ProductModel.fromJson(Map<dynamic, dynamic> map) {
    pid=map['pid'];
    pname = map['pname'];
    image = map['image'];
    brand = map['brand'];
    color = HexColor.fromHex(map['color']);
    size = map['size'];
    price = map['price'];
  }

}
