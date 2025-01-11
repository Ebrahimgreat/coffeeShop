import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectflutter/coffeeStateProvider.dart';
import 'package:projectflutter/getCoffeeDetails.dart';
import 'package:projectflutter/models/coffeeModel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'components/navigation.dart';
import 'models/coffeePrice.dart';
import 'package:projectflutter/models/coffeeVariation.dart';
class orderDetail extends StatefulWidget {
  const orderDetail({super.key});

  @override
  State<orderDetail> createState() => _orderDetailState();
}



class _orderDetailState extends State<orderDetail> {
  List <coffeeModel> coffeeItems = [];
  List <coffeeVariation> coffeesVariant=[];
  List <CoffeePrice> coffeePrice=[];
  late coffeeDetails detail;
var itemPrice=0;
  void initState() {
    super.initState();
    detail = Provider.of<coffeeDetails>(context, listen: false);
    fetchData();

  }

  Future<List<coffeeModel>> fetchData() async
  {
    final supabase = Supabase.instance.client;
    final coffeeData = await supabase.from('coffee').select().eq(
        'id', detail.coffee_id);
    final coffeeVariations=await supabase.from('coffee_variations').select().eq(
      'coffee_id',detail.coffee_id);
    final coffeePrices = await Supabase.instance.client
        .rpc('get_coffee_price', params: {'coffee_id_input': detail.coffee_id});
    print(coffeePrices);
    setState(() {
      coffeeItems = (coffeeData as List<dynamic>)
          .map((json) => coffeeModel.fromJson(json as Map<String, dynamic>))
          .toList();

      coffeePrice=(coffeePrices as List<dynamic>).map((json)=>CoffeePrice.fromJson(json as
      Map<String,dynamic>)).toList();


    coffeesVariant=(coffeeVariations as List<dynamic>).map((json)=>coffeeVariation.fromJson(json as
          Map<String,dynamic>)).toList();
    });

    print(coffeePrice[1].price);
    return coffeeItems;
  }


  int setPrice( String value)
  {
    print('price updating');
    int? priceUpdate=0;
    if(value=="small")
      {
        priceUpdate=coffeePrice[0].price;

      }
    else if(value=='medium')
      {
        print(coffeePrice[1].price);

        priceUpdate=coffeePrice[1].price;
      }
    else{
      priceUpdate=coffeePrice[2].price;
    }
    setState(() {
      itemPrice=priceUpdate!;
      print(itemPrice);
    });

return itemPrice;
  }

  @override
  Widget build(BuildContext context) {
    var detail = Provider.of<coffeeDetails>(context, listen: true);

    return Scaffold(
      bottomNavigationBar: navigation(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Coffee Detail', style: TextStyle(color: Colors.white),),

      ),
      body:
      _buildUI(context),

      backgroundColor: Colors.black,

    );
  }

  var index = 0;
  var colorValue1=Colors.green;
  var colorValue2=Colors.green;
  var colorValue3=Colors.green;

  void setColor(int value)
  {
    setState(() {
      if(value==1)
        {
          colorValue1=Colors.blue;
          colorValue2=Colors.green;
          colorValue3=Colors.green;
        }
      else if(value==2)
        {
          colorValue1=Colors.green;
          colorValue2=Colors.blue;
          colorValue3=Colors.green;
        }
      else{
        colorValue1=Colors.green;
      colorValue2=Colors.green;
      colorValue3=Colors.blue;
      }




    });
  }


  Widget _buildUI(BuildContext context) {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Column(
      children: [
        if (coffeeItems.isEmpty)
          const Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
        else
          Expanded(
            child: PageView.builder(
              itemCount: coffeeItems.length,
              itemBuilder: (context, index) {
                final coffee = coffeeItems[index];
                final variant=coffeesVariant[index];
                final price=coffeePrice[index];
                return Column(
                  children: [
                    // Coffee Image

                     Image(

                       image: AssetImage('${coffee.photo}'),
                       height:screenHeight*0.3,
                       width:double.infinity,

                     ),


                    // Coffee Name
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.1,
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(20),


                      ),
                      child: Center(
                        child: Text(
                          '${coffee.name}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),

                    // Coffee Details
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Description',
                              style: TextStyle(color: Color(0xFFAEAEAE))),
                          Text(
                            '${coffee.description}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Category: ${coffee.category}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const Text('Size',style:TextStyle(color:Colors.grey),),


                   Container(

                   child: Row(
                     mainAxisAlignment:MainAxisAlignment.spaceEvenly,

                      children: [

                        MaterialButton(

                          onPressed:()

                        {
                          setColor(1);
                          setPrice('small');

                        },child: Text('S',style:TextStyle(color:Colors.white),),color:colorValue1,),
                        MaterialButton(onPressed: (){
                         setColor(2);
                          setPrice('medium');
                        },child:const Text('M',style:TextStyle(color:Colors.white)),color:colorValue2,),
                        MaterialButton(onPressed: (){
                          setColor(3);
                          setPrice('large');
                        },child:const Text('L',style:TextStyle(color:Colors.white)),color:colorValue3,),
                      ],
                    ),
                   ),
                    // Add to Cart Section
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.1,
                      padding: const EdgeInsets.symmetric(horizontal: 16),


                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                          MaterialButton(
                            color: Colors.orange,
                            onPressed: () {
                             const snackbar=SnackBar(content: Text('Added'
                                 'To Cart'));
                             ScaffoldMessenger.of(context).showSnackBar(snackbar);
                              // Handle Add to Cart
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Add To Cart',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                    ),

                    Text('${itemPrice}',style:TextStyle(color:Colors.white))
                  ],
                );
              },
            ),
          ),
      ],
    );
  }


}
