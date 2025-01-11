import 'package:flutter/cupertino.dart';
import 'package:projectflutter/models/coffeeModel.dart';
import 'package:projectflutter/models/dashboardModa.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class CartItem{
  int ? id;
  int ? coffeeid;
   String ?coffeeName;
   String ?variation;
  String ?photo;
  List <int>SizePrice=[];
  List<int> quantity=[];
  int totalPrice=0;


  CartItem({this.id, this.coffeeName, this.variation, this.photo
  });

 static CartItem fromJson(Map<String,dynamic>json)=>CartItem(
 id:json['id'], coffeeName:json['coffeename'], variation:json['variation'], photo:json['photo']);


}

class coffeeProvider extends ChangeNotifier{


  var total=0;
  var index=0;
  List<coffeeModel> _favorites = [];
  List<coffeeModel> get favorites=>_favorites;

  List<CartItem> _cart=[];
  List<CartItem> get cart=>_cart;



  String payment='';
  void  setPaymentMethod(String payment)
  {
    this.payment=payment;
    notifyListeners();

  }



  void removeFromCart(id,String value) async {
    int index = _cart.indexWhere((item) => item.id == id);
    if (index == -1) {
      print("items not found in the cart");
      return;
    }
    if (value == 'small') {
      if (_cart[index].quantity[0] > 0) {
        _cart[index].quantity[0]--;
        _cart[index].totalPrice -= _cart[index].SizePrice[0];
      }
      else {
        print("value cannot be below 0");
      }
    }

    else if (value == 'medium') {
      if (_cart[index].quantity[1] > 0) {
        _cart[index].quantity[1]--;
        _cart[index].totalPrice -= _cart[index].SizePrice[1];
      }
      else {
        print("cart quantity cannot be below 0");
      }
    }
    else if (value == 'large') {
      if (_cart[index].quantity[2] > 0) {
        _cart[index].quantity[2]--;
        _cart[index].totalPrice -= _cart[index].SizePrice[2];
      }
      else {
        print("cart quantity cannot be below 0");
      }


    }
    if(_cart[index].quantity.every((q)=>q==0)){
      print("Remoing item");
      _cart.removeAt(index);

    }
    notifyListeners();
  }

  void addToCart(id,String value) async
  {

    final supabase=Supabase.instance.client;
    final data=await supabase.rpc('get_coffee_details_by_id',params:{'coffee_id_input':id});
    print(data);

    final items=(data as List<dynamic>).map((json)=>CartItem.fromJson(json as Map<String,dynamic>)).toList();

 int index=_cart.indexWhere((item)=>item.id==id);
 print(index);
  if(index==-1)
    {
      _cart.add(items.first);
      _cart.last.SizePrice=[
        data[0]['price'],
        data[1]['price'],
        data[2]['price']
      ];

      _cart.last.quantity=[
        0,0,0



      ];
      index++;
    }

    if(value=='small')
      {
        _cart[index].quantity[0]++;
        _cart[index].totalPrice+= _cart[index].SizePrice[0];
      }
    else if(value=='medium')
    {
      _cart[index].quantity[1]++;
      _cart[index].totalPrice+= _cart[index].SizePrice[1];
    }
    else{
      if(value=='large')
      {
        _cart[index].quantity[2]++;
        _cart[index].totalPrice+= _cart[index].SizePrice[2];
      }
    }


notifyListeners();


  }






  int getTotal(){
    int total=0;
    for(int i=0; i<cart.length; i++)
      {
        total+=cart[i].totalPrice;

      }
    return total;
  }

  void addFavorites(coffeeModel item)
  {
    if(_favorites.contains(item))
      {
        _favorites.remove(item);
      }
    else{
      _favorites.add(item);
    }
    notifyListeners();


  }

  void setIndex(index)
  {
    this.index=index;

  }
  int getIndex()
  {
    return index;
  }



}