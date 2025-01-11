import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectflutter/coffeeStateProvider.dart';
import 'package:projectflutter/components/navigation.dart';
import 'package:provider/provider.dart';
class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {

  void getPrice()
  {
    final provider=Provider.of<coffeeProvider>(context,listen:false);
    if(provider.cart.isEmpty){
      totalPrice=0;
      return;
    }
    totalPrice+=provider.cart[0].totalPrice??0;

  }
  void initState()
  {
    getPrice();
  }

  @override
  Widget build(BuildContext context) {
 return Scaffold(
   appBar:AppBar(
     backgroundColor:Colors.black,
     title: const Text('Cart',style:TextStyle(color:Colors.white)),
     leading:MaterialButton(onPressed: (){},child:Icon(Icons.arrow_back_ios,color:Colors.white,),),
    
     actions: [
       MaterialButton(onPressed: (){
         Navigator.pushNamed(context, '/account');
       }, child:Icon(Icons.person,color:Colors.white,))
     ],
   ),
   bottomNavigationBar:navigation(),
   body: _buildUI(context),
   backgroundColor:Colors.black,
 );
  }
  var itemCount=0;
  var  totalPrice=0;

  Widget _buildUI(BuildContext context){

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;


    return Consumer<coffeeProvider>(
      builder:(context,coffee,child){

        itemCount=coffee.cart.length;
        if(itemCount==0)
          {
            return const Text('No Items in cart',style:TextStyle(color:Colors.white),);
          }
        return Column(
          mainAxisAlignment:MainAxisAlignment.spaceAround,
          children: [

            Container(

                  width:screenWidth*0.8,
            height:screenHeight*0.3,
            decoration:BoxDecoration(
                color: Color(0XFF262B33),
              border:Border.all(

                


              ),
              borderRadius:BorderRadius.circular(20)
            ),
              child: ListView.builder(
                  itemCount:itemCount,
                itemBuilder:(context,int i){

                  final cart=coffee.cart[i];

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title:Row(
                      mainAxisAlignment:MainAxisAlignment.spaceEvenly,

                      children: [
                        Text('${itemCount}',style:TextStyle(color:Colors.white),),

                        Image(image:AssetImage('${cart.photo}'),width:screenWidth*0.2,),
                        Text('${cart.coffeeName}',style:TextStyle(color:Colors.white)),
                        Text('${cart.totalPrice}',style:GoogleFonts.poppins(color:Colors.white),)



                      ],
                    ),

                    subtitle: Container(
                  child:Column(



                  children: [



                    Container(
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                         MaterialButton(onPressed:
                             (
                             ){

                         },child:const Text('S',style:TextStyle(color:Colors.white)),color:Colors.black,minWidth:4,),


                          Text('${cart.SizePrice[0]}',style:TextStyle(color:Colors.white),),


                          MaterialButton(
                            onPressed:()
                          {
                            final provider=Provider.of<coffeeProvider>(context,listen:false).addToCart(cart.id,'small');
                            setState(() {
                              totalPrice+=cart.SizePrice[0];
                              print(totalPrice);
                            });



                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added')));

                          },child:const Icon(Icons.add,color:Colors.white,),color:Colors.green,minWidth:4),
                          Text('${cart.quantity[0]}',style:GoogleFonts.sora(color:Colors.white)

                          ),


                          MaterialButton(onPressed:() {
                            final provider=Provider.of<coffeeProvider>(context,listen:false).removeFromCart(cart.id,'small');
                            setState(() {
                              totalPrice-=cart.SizePrice[0];
                            });


                          },child:const Icon(Icons.remove,color:Colors.white,),color:Colors.green,minWidth:4,),



                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,

                        children: [
                          MaterialButton(onPressed: (){},child:const Text('M',style:TextStyle(color:Colors.white)),color:Colors.black,minWidth:4,),
                          Text('${cart.SizePrice[1]}',style:TextStyle(color:Colors.white)),



                          MaterialButton(onPressed:() {
                            final provider=Provider.of<coffeeProvider>(context,listen:false).addToCart(cart.id,'medium');
                            setState(() {
                              totalPrice+=cart.SizePrice[1];
                            });
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added')));

                          },child:const Icon(Icons.add,color:Colors.white,),color:Colors.green,minWidth:4,),

                    Text('${cart.quantity[1]}',style:GoogleFonts.poppins(color:Colors.white)),


                        MaterialButton(onPressed:() {
                          final provider=Provider.of<coffeeProvider>(context,listen:false).removeFromCart(cart.id,'medium');
                          setState(() {
                            totalPrice-=cart.SizePrice[1];
                          });


                        },child:const Icon(Icons.remove,color:Colors.white,),color:Colors.green,minWidth:4,),


                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(onPressed: (){},child:const Text('L',style:TextStyle(color:Colors.white)),color:Colors.black,minWidth:4,),
                          Text('${cart.SizePrice[2]}',style:TextStyle(color:Colors.white)),
                          MaterialButton(onPressed:() {
                            final provider=Provider.of<coffeeProvider>(context,listen:false).addToCart(cart.id,'large');


                          },child:const Icon(Icons.add,color:Colors.white,),color:Colors.green,minWidth:4,),
                          Text('${cart.quantity[2]}',style:GoogleFonts.poppins(color:Colors.white),),



                          MaterialButton(
                            shape:Border.all(

                            ),

                            onPressed:() {
                              final provider=Provider.of<coffeeProvider>(context,listen:false).removeFromCart(cart.id,'large');
                              setState(() {
                                totalPrice-=cart.SizePrice[2];
                              });


                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added')));

                          },child:const Icon(Icons.remove,color:Colors.white,),color:Colors.green,minWidth:4,),

                        ],
                      ),
                    ),






                  ],


                    ),
                    ),


                  );


                })
            ),
            SizedBox(
              height:0.1*screenHeight,
            ),

            Container(

              child:Row(
                mainAxisAlignment:MainAxisAlignment.spaceAround,

                children: [
                  Text('Total Price: ${totalPrice}',style:GoogleFonts.poppins(color:Colors.white),),


                  MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/payment');
                  },
                  color: Colors.green,
                  minWidth: 200.0, // Set width
                  height: 50.0,
                  child: Text('Pay', style: TextStyle(color: Colors.white)), // Set height
                )


          ],
        )
        )
        ]

        );


      }
    );

  }


}

