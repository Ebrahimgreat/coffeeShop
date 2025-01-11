
class coffeeVariation{
  final int?  id;
  final String? name;


  const coffeeVariation(
      {
        this.id,this.name
      }
      );
  static coffeeVariation fromJson(Map<String,dynamic>json)=>coffeeVariation(
      id:json['id'] as int?,name:json['name'] as String?);

}