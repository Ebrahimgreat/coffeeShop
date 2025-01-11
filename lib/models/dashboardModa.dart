

import 'package:flutter/cupertino.dart';
import 'package:projectflutter/dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'coffeeModel.dart';


class CoffeeDashboard extends ChangeNotifier{
  final int ? id;
  final String ? coffee_name;
  final int? coffee_price;
  final String ? variation_name;
  final String ? coffee_photo;
  final String? category;

   CoffeeDashboard({
     this.category,

  this.id,this.coffee_name, this.coffee_price, this.variation_name, this.coffee_photo
  }

);
  static CoffeeDashboard fromJson(Map<String,dynamic>json)=>CoffeeDashboard(
    id:json['id'],
coffee_name:json['coffee_name'] as String?, coffee_price:json['coffee_price'] as int?,variation_name:json['variation_name'],
    coffee_photo:json['coffee_photo'] as String?,category:json['coffee_category']




);
  List<CoffeeDashboard> dashboardCoffee=[];
  List<CoffeeDashboard> filteredCoffee=[];
  List<CoffeeDashboard> get coffee=>filteredCoffee;
  void getData() async{
    final supabase = Supabase.instance.client;
    final data = await supabase.from('coffee_price').select();
    final coffeeprices=await supabase.from('coffee_price').select();
    final items=await supabase.rpc('coffeedashboard14');



      dashboardCoffee= (items as List<dynamic>)
          .map((json) => CoffeeDashboard.fromJson(json as Map<String, dynamic>))
          .toList();
      filteredCoffee=List.from(dashboardCoffee);
      notifyListeners();



  }
  void searchCoffee(String query)
  {
   if(query.isEmpty){
     filteredCoffee=List.from(dashboardCoffee);

   }
   else{
     filteredCoffee=dashboardCoffee.where((item){
       return(item.coffee_name ?? '').toLowerCase().contains(query.toLowerCase());
     }).toList();

   }
   notifyListeners();

  }
  void filterCoffee(int category)
  {


    if(category==0) {
      filteredCoffee=List.from(dashboardCoffee);
    }
    else if(category==1){
      filteredCoffee=dashboardCoffee.where((item){
        return(item.category??'').toLowerCase()=='hot';
      }).toList();
    }
    else if(category==2){
      filteredCoffee=dashboardCoffee.where((item){
        return(item.category??'').toLowerCase()=='cold';
      }).toList();
    }
    else if(category==3){
      filteredCoffee=dashboardCoffee.where((item){
        return(item.category??'NO results').toLowerCase()=='decaf';
      }).toList();
    }



    notifyListeners();



  }



}