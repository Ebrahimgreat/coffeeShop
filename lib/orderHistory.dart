

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectflutter/coffee_detail.dart';
import 'package:projectflutter/components/navigation.dart';
import 'package:projectflutter/getCoffeeDetails.dart';
import 'package:projectflutter/models/orderDetail.dart';
import 'package:projectflutter/order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/order.dart';

class orderHistory extends StatefulWidget {
  const orderHistory({super.key});

  @override
  State<orderHistory> createState() => _orderHistoryState();
}


class _orderHistoryState extends State<orderHistory> {
  @override
  final supabase=Supabase.instance.client;
  var userData;
  var orderIds=[];
  List<OrderDetail> orders=[];
  List<dynamic> orderDetails=[];
  Future<List<OrderDetail>> getUserData() async{
    userData=supabase.auth.currentUser;
    var userId=userData.id;
    var userProfile;



   

    try {
      userProfile = await supabase.from('UserProfile').select('id')
          .eq('user_id', userId)
          .single();

       orderIds = await supabase.from('orders').select('id,date').eq(
          'user_id', userProfile['id']);
      print(orderIds);

      for(var i=0; i<orderIds.length; i++)
        {
          final orderitem=await supabase.from('order_details').select('*').eq('order_id', orderIds[i]['id']);
         print(orderitem);
          if(orderitem!=null && orderitem is List<dynamic>){
          orderDetails.addAll(
            orderitem
            
          );
        }
          }

      
      
      setState(() {
        orders=orderDetails.map((item)=>OrderDetail.fromJson(item as Map<String,dynamic>)).toList();

      });

        }

    catch(error)
    {
      print(error);
    }

return orders;
  }


  void initState()
  {
    getUserData();


  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text('Order History',style:GoogleFonts.poppins(color:Colors.white
      )),
      backgroundColor:Colors.black,),
    backgroundColor:Colors.black,
      body: _buildUi(context),
      bottomNavigationBar:navigation(),
    );


  }
  Widget _buildUi(BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
        children: [
          Container(
            width:screenWidth*0.8,
          height:screenHeight*0.3,
          decoration:BoxDecoration(
            color:Color(0XFF262B33),
            border:Border.all(
              
            ),
            borderRadius:BorderRadius.circular(20)
          ),
         child: Expanded(child:

      ListView.builder(
            itemCount:orders.length,
              itemBuilder:(context,int i){
          final order=orders[i];
          return ListTile(

            title:Column(

              children: [
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,

                  children: [
                    Text('Order Date',style:GoogleFonts.poppins(color:Colors.white)),
                    Text('Total Amount',style:GoogleFonts.poppins(color:Colors.white),)
                  ],

                ),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: [
                Text('${orderIds[0]['date']}',style:GoogleFonts.poppins(color:Colors.white)),
                Text('2500',style:GoogleFonts.poppins(color:Colors.white))
              ]
                )

              

              ],

            ),
            subtitle: Container(
              child:Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                      children: [


                       Image(image: AssetImage('${order.photo}'),width:screenWidth*0.2,),
                        Text('${order.coffee_name}',style:GoogleFonts.poppins(color:Colors.white),),

                      ],
                    ),
                  ),




                  Container(
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                      children: [


                        MaterialButton(onPressed: (){},child:Text('S',style:TextStyle(color:Colors.white)),color:Colors.black,),
                        MaterialButton(onPressed: (){},child:Text('${order.smallPrice}',style:TextStyle(color:Colors.white)),color:Colors.black,),

                        Text('X ${order.smallQuantity}',style:GoogleFonts.poppins(color:Colors.white),),

                      ],
                    ),
                  ),
                ],
              ),
            ),

          );

          }
                )
          )
          )
        ],


      );



    }
}
