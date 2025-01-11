import 'package:flutter/cupertino.dart';


class SizePrice {
  final String size;
  final double price;

  SizePrice(this.size, this.price);


}
class coffeeModel {
  final int ? id;
  final String? name;
  final String? description;
  final String? photo;
  final String ?category;

  const coffeeModel(

      {this.id,this.name, this.description, this.photo, this.category
      });

  static coffeeModel fromJson(Map<String,dynamic> json)=>coffeeModel
(name:json['name'] as String, description:json['description'], photo:json['photo'], category:json['category']);
  }

