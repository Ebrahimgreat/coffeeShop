import 'package:flutter/material.dart';
import 'package:projectflutter/models/coffeeModel.dart';
class CoffeeBans{
  String name;
  String origin;
  String photo;
  String price;
  final List<SizePrice> sizes;
  CoffeeBans(this.name,this.photo,this.price,this.origin,this.sizes);
}