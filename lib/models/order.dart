import 'dart:convert';

import 'package:flutter/cupertino.dart';
class orders {

  final int ?orderId;
  final double ?totalPrice;
  final DateTime? time;

  const orders({
    this.orderId, this.time, this.totalPrice
  });

  static orders fromJson(Map<String,dynamic>json)=>orders(
  orderId:json['id'],totalPrice:json['totalPrice'],
  time:json['time']

  );
}

