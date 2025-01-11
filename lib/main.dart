import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:projectflutter/account.dart';
import 'package:projectflutter/cart.dart';
import 'package:projectflutter/coffeeStateProvider.dart';
import 'package:projectflutter/favorites.dart';
import 'package:projectflutter/coffee_detail.dart';
import 'package:projectflutter/models/dashboardModa.dart';
import 'package:projectflutter/orderHistory.dart';
import 'package:projectflutter/orderTracking.dart';
import 'package:projectflutter/payment.dart';
import 'package:projectflutter/profileSettings.dart';
import 'package:projectflutter/register.dart';
import 'package:projectflutter/signin.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'dashboard.dart';
import 'order.dart';
import 'welcomeScreen.dart';
import 'getCoffeeDetails.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: 'lib/.env');

    String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  }
  catch(error){
    print(error);
  }



      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => coffeeProvider()),
            ChangeNotifierProvider(create: (context) => coffeeDetails()),
            ChangeNotifierProvider(create: (context)=>CoffeeDashboard())
          ],
          child: const MyApp(),
        ),

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes:{
        '/coffee_detail':(context)=>orderDetail(),
        '/favorites':(context)=>Favorites(),
        '/register':(context)=>register(),
        '/dashboard':(context)=>dashboard(),
        '/signin':(context)=>signin(),
        '/cart':(context)=>cart(),
        '/account':(context)=>account(),
        '/payment':(context)=>payment(),
        '/order':(context)=>Order(),

      },



        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:signin()


    );
  }
}

