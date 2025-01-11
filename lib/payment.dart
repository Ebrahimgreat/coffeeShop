import 'package:flutter/material.dart';
import 'package:projectflutter/components/navigation.dart';
import 'package:provider/provider.dart';

import 'coffeeStateProvider.dart';
class payment extends StatefulWidget {
  const payment({super.key});

  @override
  State<payment> createState() => _paymentState();
}

var colorValue=[Color(0xFF252A32),Color(0xFF252A32),Color(0xFF252A32),Color(0xFF252A32)];

var paymentMethods = ['CreditCard', 'Wallet', 'EasyPaisa', 'Cash'];

var methodSelected=paymentMethods[0];
class _paymentState extends State<payment> with SingleTickerProviderStateMixin {
  @override
  @override
  Widget build(BuildContext context) {


    void selectValue(int value)
    {
      setState(() {

         if(value==0)
          {

            colorValue[0]=Colors.blue;
            colorValue[3]=Color(0xFF252A32);
            colorValue[2]=Color(0xFF252A32);
            colorValue[3]=Color(0xFF252A32);


          }
        else if(value==1)
          {
            colorValue[0]=Color(0xFF252A32);
            colorValue[1]=Colors.blue;
            colorValue[2]=Color(0xFF252A32);
            colorValue[3]=Color(0xFF252A32);




          }
        else if(value==2)
          {
            colorValue[0]=Color(0xFF252A32);
            colorValue[1]=Color(0xFF252A32);
            colorValue[3]=Colors.blue;
            colorValue[1]=Color(0xFF252A32);



          }
         else if(value==3)
         {
           colorValue[0]=Color(0xFF252A32);
           colorValue[1]=Color(0xFF252A32);
           colorValue[2]=Color(0xFF252A32);
           colorValue[3]=Colors.blue;


         }
      });


    }

    final total=Provider.of<coffeeProvider>(context,listen:false).getTotal();

    void buttonPress(index){
      print(index);

    }
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
        backgroundColor: Colors.black,

        appBar:
        AppBar(

          title: const Text('Payment', style: TextStyle(color: Colors.white)),

          backgroundColor: Colors.black,
        ),
        body: Column(

        children: [
          Expanded(child:ListView.builder
         (itemCount: paymentMethods.length,
            itemBuilder: (context, int i) {
              final payment = paymentMethods[i];
              return ListTile(
                  title: Column(
                      children: [
                        Container(

                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20),
                             color:colorValue[i]
                          ),
                          width: screenWidth * 0.8,

                          child: MaterialButton(onPressed: () {
                            Provider.of<coffeeProvider>(context,listen:false).setPaymentMethod(paymentMethods[i]);
                            setState(() {
                              selectValue(i);



                              methodSelected=payment;
                            });

                          },
                              child: Text('${payment}',
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ]
                  ),


              );
            }
              ),

          ),
          Padding(

            padding:const EdgeInsets.all(32),
              child:Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:${total}',style:TextStyle(color:Colors.white),),

                  MaterialButton(
                    color:Colors.green,
                    onPressed: (){
                      Navigator.pushNamed(context, '/order');
                    },
                  child:Text('${methodSelected}'),textColor:Colors.white,)
                ],
              )

          )


        ]
                  )
              );
            }
  }
