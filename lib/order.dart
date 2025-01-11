import 'package:flutter/material.dart';
import 'package:projectflutter/coffeeStateProvider.dart';
import 'package:projectflutter/components/navigation.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}



class _OrderState extends State<Order> {

var deliveryAddress='';
var total=0;

void confirmOrder() async{
  final supabase=Supabase.instance.client;
  final user=supabase.auth.currentSession!.user.id;
  final DateTime currentDate=DateTime.now();
  final String formattedDate=DateFormat('yyyy--MM--dd').format(currentDate);
  try{
    var profile=await supabase.from('UserProfile').select('id').eq('user_id', user).single();
    var orderId;
    orderId=await supabase.from('orders').insert({
      'user_id':profile['id'],
      'date':formattedDate


    }).select('id').single();

    if(orderId==null)
      {
        print("Order creation failed");
        return;

      }
    final provider = Provider
        .of<coffeeProvider>(context, listen: false)
        .cart
        .toList();
    for (var i = 0; i < provider.length; i++) {
    await  supabase.from('order_details').insert({
       'coffee_name':provider[i].coffeeName,
      'photo':provider[i].photo,
       'smallQuantity':provider[i].quantity[0],
       'mediumQuantity':provider[i].quantity[1],
       'largeQuantity':provider[i].quantity[2],
       'smallPrice':provider[i].SizePrice[0],
       'mediumPrice':provider[i].SizePrice[1],
       'largePrice':provider[i].SizePrice[2],
       'order_id':orderId['id']

     });
    }



  }
  catch(error){
    print(error);
  }
}
  void information() async
  {

    final supabase=Supabase.instance.client;

    final  user=supabase.auth.currentSession!.user.id;
    try{
      var profile=await supabase.from('UserProfile').select('*').eq('user_id',user).single(
      );
     setState(() {
       deliveryAddress=profile['address']??'';
       total=Provider.of<coffeeProvider>(context,listen:false).getTotal();
     });

      print(deliveryAddress);




    }
    catch(error){
      print(error);
    }

  }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      information();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Order', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar:navigation(),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(

              decoration:BoxDecoration(
                color: const Color(0xFF252A32),
                border:Border.all(),
                borderRadius:BorderRadius.circular(20),

              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery or Pickup Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        color: Colors.green,
                        onPressed: () {},
                        child: const Text('Deliver', style: TextStyle(color: Colors.white)),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(style: BorderStyle.none),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      MaterialButton(
                        color: Colors.green,
                        onPressed: () {},
                        child: const Text('Pick up', style: TextStyle(color: Colors.white)),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(style: BorderStyle.none),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Delivery Address',style:TextStyle(color:Colors.white),),
                  // Address
                   Text(
                    deliveryAddress,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  // Payment Summary Header
                  const Text(
                    'Payment Summary',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Text('Price', style: TextStyle(color: Colors.white)),
                      Text('${total}',style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Delivery Fee
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Delivery Fee', style: TextStyle(color: Colors.white)),
                      Text('50 Rupees', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Payment Method

                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                   Text(
                    'Payment Method:',
                    style: TextStyle(color: Colors.white, fontSize: 16)
                  ),
                  Text('${Provider.of<coffeeProvider>(context,listen:false).payment}',style:TextStyle(color:Colors.white,fontSize:16),),

              ]
                  ),
                  // Confirm Order Button
                  Center(
                    child: MaterialButton(
                      color: Colors.green,
                      onPressed: () {
                        confirmOrder();
                        const snackbar=SnackBar(content: Text('Order confirmed'));

                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        Navigator.pushNamed(context, '/orderTracking');
                      },
                      child: const Text('Confirm Order', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}