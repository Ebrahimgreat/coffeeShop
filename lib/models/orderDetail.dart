
 import 'package:projectflutter/coffee_detail.dart';

class OrderDetail{
  final String? coffee_name;
  final int ? smallQuantity;
  final int ? mediumQuantity;
  final int ? largeQuantity;
  final int? smallPrice;
  final int? mediumPrice;
  final int ?largePrice;
  final int ? order_id;
  final String? photo;
  const OrderDetail({
    this.coffee_name,this.smallQuantity,this.mediumQuantity,this.photo,
    this.largeQuantity,this.smallPrice,this.mediumPrice,this.largePrice,this.order_id

});
  static OrderDetail fromJson(Map<String,dynamic>json)=>OrderDetail(
    coffee_name:json['coffee_name'] as String, smallQuantity:json['smallQuantity'] as int, mediumQuantity:json['mediumQuantity'] as int,
    order_id:json['order_id'] as int,largeQuantity:json['largeQuantity'] as int,smallPrice:json['smallPrice'],mediumPrice:json['mediumPrice'],largePrice:json['largePrice'],
    photo:json['photo']
  );

}