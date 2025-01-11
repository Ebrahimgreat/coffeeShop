import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectflutter/components/navigation.dart';
import 'package:projectflutter/register.dart';
import 'package:projectflutter/welcomeScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Auth.dart';
import 'dashboard.dart';
class signin extends StatefulWidget {
  const signin({super.key});

  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {

  String? errorMessage='';
  bool isLogin=true;
  final TextEditingController _controllerEmail=TextEditingController();
  final TextEditingController _controllerPassword=TextEditingController();
  late final StreamSubscription<AuthState> _authSubscription;
  bool _isLoading=false;
  final supabase = Supabase.instance.client;

  Future<void> signWithEmailAndPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await supabase.auth.signInWithPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in '))
      );
    }
    on AuthException catch (error) {
     setState(() {
       errorMessage=error.message;
     });
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(error.message))
     );

    }
    finally{
      if(mounted){
        setState(() {
          _isLoading=false;
        });
      }
    }
  }
  @override
  void initState()
  {
    _authSubscription=supabase.auth.onAuthStateChange.listen(
      (data) {
          final session = data.session;
          if (session != null) {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const dashboard(),
              ),
              );
            }
          }
        },
    onError:(error) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:Text(error is AuthException?error.message:'Unexpected error occured'))
      );


  }
    );
        }

  @override
  void dispose(){
    _controllerEmail.dispose();
    _authSubscription.cancel();
    _controllerPassword.dispose();
  }








  @override
    Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:Text('Sign in',style:TextStyle(color:Colors.white)),
        backgroundColor:Colors.black,
      ),

      body:Container(
        color:Colors.black,
        height:double.infinity,
        width:double.infinity,
        child:Column(
          children: [
            Image(image: AssetImage('assets/images/americano.jpg')),
            TextField(
              style:TextStyle(color:Colors.white),


              controller:_controllerEmail,
              decoration:InputDecoration(
                labelText:'Email',
                labelStyle:TextStyle(color:Colors.white)

              ),
            ),
            TextField(
              style:TextStyle(color:Colors.white),

              controller:_controllerPassword,
              decoration:InputDecoration(
                labelText:'Password',
                labelStyle:TextStyle(color:Colors.white)
              ),
              obscureText:true,
            ),
            ElevatedButton(onPressed:
             _isLoading?null: signWithEmailAndPassword,

            child: const Text('Login')
            ),
            MaterialButton(onPressed: (){
              Navigator.pushNamed(context, '/register');

            }),
            MaterialButton(onPressed: (){
              Navigator.pushNamed(context, '/forgetpassword');
            },child:Text('forget Password',style:TextStyle(color:Colors.white))),
            MaterialButton(onPressed: (){
              Navigator.pushNamed(context, '/register');
            },child:Text('Dont have an account? Register Here',style:TextStyle(color:Colors.white)))
          ],
        ),
      ),
    );
  }
  }

