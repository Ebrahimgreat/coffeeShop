
class CoffeePrice{

  final int?  id;
  final int? price;
  final String? size;

  const CoffeePrice(
  {
    this.id,this.price,this.size,
}
      );
  static CoffeePrice fromJson(Map<String,dynamic>json)=>CoffeePrice(
  id:json['id'] as int?,price:json['price'] as int?,size:json['size'] as String?);
}