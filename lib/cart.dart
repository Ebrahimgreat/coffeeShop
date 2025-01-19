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
  void getPrice() {
    final provider = Provider.of<coffeeProvider>(context, listen: false);
    if (provider.cart.isEmpty) {
      totalPrice = 0;
      return;
    }
    totalPrice += provider.cart[0].totalPrice;
  }

  void initState() {
    getPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Cart', style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold)),
      
        leading: MaterialButton(
          onPressed: () {},
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
          MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/account');
              },
              child: Icon(
                Icons.person,
                color: Colors.white,
              ))
        ],
      ),
      bottomNavigationBar: navigation(),
      body: _buildUI(context),
      backgroundColor: Colors.black,
    );
  }

  var itemCount = 0;
  var totalPrice = 0;

  Widget _buildUI(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<coffeeProvider>(builder: (context, coffee, child) {
      itemCount = coffee.cart.length;
      if (itemCount == 0) {
        return const Text(
          'No Items in cart',
          style: TextStyle(color: Colors.white),
        );
      }
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                    color: Color(0XFF262B33),
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)),
                child: ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (context, int i) {
                      final cart = coffee.cart[i];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Text('${itemCount}',style:TextStyle(color:Colors.white),),

                            Image(
                              image: AssetImage('${cart.photo}'),
                              width: screenWidth * 0.3,
                            ),
                            Text('${cart.coffeeName}',
                                style: TextStyle(color: Colors.white)),
                            // Text('${cart.totalPrice}',style:GoogleFonts.poppins(color:Colors.white),)
                          ],
                        ),
                        subtitle: Container(
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {},
                                      child: const Text('S',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      color: Colors.black,
                                      minWidth: 4,
                                    ),
                                    Text(
                                      '${cart.SizePrice[0]}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      onPressed: () {
                                        final provider =
                                            Provider.of<coffeeProvider>(context,
                                                    listen: false)
                                                .addToCart(cart.id, 'small');
                                        setState(() {
                                          totalPrice += cart.SizePrice[0];
                                          print(totalPrice);
                                        });

                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(
                                        //   const SnackBar(
                                        //       content: Text('Added')),
                                        // );
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      color: Color(0xFFD17842),
                                      minWidth: 4,
                                    ),
                                    Container(
                                      width: 50, 
                                      height: 30, 
                                      alignment: Alignment
                                          .center,
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xFF0C0F14), 
                                        borderRadius: BorderRadius.circular(
                                            10), 
                                        border: Border.all(
                                          color:
                                              Color(0xFFD17842), 
                                          width: 2,
                                        ),
                                      ),
                                      child: Text(
                                        '${cart.quantity[0]}', 
                                        style: TextStyle(
                                          color: Colors.white, 
                                          fontSize:
                                              16,
                                        ),
                                      ),
                                    ),

                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      onPressed: () {
                                        final provider =
                                            Provider.of<coffeeProvider>(context,
                                                listen: false);
                                        if (cart.quantity[0] > 0) {
                                          provider.removeFromCart(
                                              cart.id, 'small');
                                          setState(() {
                                            totalPrice -= cart.SizePrice[0];
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Quantity cannot be less than 0')),
                                          );
                                        }
                                      },
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                      color: Color(0xFFD17842),
                                      minWidth: 29,
                                      height: 29,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {},
                                      child: const Text('M',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      color: Colors.black,
                                      minWidth: 4,
                                    ),
                                    Text('${cart.SizePrice[1]}',
                                        style: TextStyle(color: Colors.white)),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      onPressed: () {
                                        final provider =
                                            Provider.of<coffeeProvider>(context,
                                                    listen: false)
                                                .addToCart(cart.id, 'medium');
                                        setState(() {
                                          totalPrice += cart.SizePrice[1];
                                          print(totalPrice);
                                        });

                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(
                                        //   const SnackBar(
                                        //       content: Text('Added')),
                                        // );
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      color: Color(0xFFD17842),
                                      minWidth: 4,
                                    ),
                                    Container(
                                      width: 50, 
                                      height: 30, 
                                      alignment: Alignment
                                          .center, 
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xFF0C0F14), 
                                        borderRadius: BorderRadius.circular(
                                            10), 
                                        border: Border.all(
                                          color:
                                              Color(0xFFD17842), 
                                          width: 2, 
                                        ),
                                      ),
                                      child: Text(
                                        '${cart.quantity[1]}', 
                                        style: TextStyle(
                                          color: Colors.white, 
                                          fontSize:
                                              16, 
                                        ),
                                      ),
                                    ),

                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      onPressed: () {
                                        final provider =
                                            Provider.of<coffeeProvider>(context,
                                                listen: false);
                                        if (cart.quantity[1] > 0) {
                                          provider.removeFromCart(
                                              cart.id, 'medium');
                                          setState(() {
                                            totalPrice -= cart.SizePrice[1];
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Quantity cannot be less than 0')),
                                          );
                                        }
                                      },

                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                      color: Color(0xFFD17842),
                                      minWidth: 29,
                                      height: 29,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {},
                                      child: const Text('L',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      color: Colors.black,
                                      minWidth: 4,
                                    ),
                                    Text('${cart.SizePrice[2]}',
                                        style: TextStyle(color: Colors.white)),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      onPressed: () {
                                        final provider =
                                            Provider.of<coffeeProvider>(context,
                                                    listen: false)
                                                .addToCart(cart.id, 'large');
                                        setState(() {
                                          totalPrice += cart.SizePrice[2];
                                          print(totalPrice);
                                        });

                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(
                                        //   const SnackBar(
                                        //       content: Text('Added')),
                                        // );
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      color: Color(0xFFD17842),
                                      minWidth: 4,
                                    ),
                                    Container(
                                      width: 50, 
                                      height: 30, 
                                      alignment: Alignment
                                          .center,
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xFF0C0F14), 
                                        borderRadius: BorderRadius.circular(
                                            10), 
                                        border: Border.all(
                                          color:
                                              Color(0xFFD17842), 
                                          width: 2, 
                                        ),
                                      ),
                                      child: Text(
                                        '${cart.quantity[2]}',
                                        style: TextStyle(
                                          color: Colors.white, 
                                          fontSize:
                                              16, 
                                        ),
                                      ),
                                    ),

                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      onPressed: () {
                                        final provider =
                                            Provider.of<coffeeProvider>(context,
                                                listen: false);
                                        if (cart.quantity[2] > 0) {
                                          provider.removeFromCart(
                                              cart.id, 'large');
                                          setState(() {
                                            totalPrice -= cart.SizePrice[2];
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Quantity cannot be less than 0')),
                                          );
                                        }
                                      },
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                      color: Color(0xFFD17842),
                                      minWidth: 29,
                                      height: 29,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })),
            SizedBox(
              height: 0.40 * screenHeight,
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RichText(
                  textAlign: TextAlign.center, 
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      color: Colors.white, 
                      fontSize: 16, 
                    ),
                    children: [
                      TextSpan(
                        text: 'Total Price\n', 
                        style: TextStyle(
                          color: Color(0xFFAEAEAE),
                          )
                      ),
                      TextSpan(
                        text: 'PKR ${totalPrice}', 
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold, 
                          fontSize:
                              18, 
                        ),
                      ),
                    ],
                  ),
                ),


                MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/payment');
                  },
                  color: Colors.green,
                  minWidth: 200.0, 
                  height: 50.0, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25), 
                  ),
                  child: Text(
                    'Pay',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold, 
                      fontSize: 16, 
                    ),
                  ),
                ),

              ],
            ))
          ]);
    });
  }
}
