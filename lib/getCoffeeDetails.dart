import 'package:flutter/material.dart';
 class coffeeDetails extends ChangeNotifier
{
  var coffee_id;
  void setCoffee(id)
  {
    this.coffee_id=id;
    notifyListeners();

  }
  int getId()
  {
    return coffee_id;
  }


}