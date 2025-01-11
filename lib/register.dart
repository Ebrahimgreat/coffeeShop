import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final supabase=Supabase.instance.client;
  final TextEditingController _controllerEmail=TextEditingController();
  final TextEditingController _controllerPassword=TextEditingController();
  final TextEditingController _controllerBio=TextEditingController();
  final TextEditingController _controllerAddress=TextEditingController();
  final TextEditingController _controllerName=TextEditingController();
  Future<void> signup() async {
  try {
    var newUser;


    newUser = await supabase.auth.signUp(
        email: _controllerEmail.text, password: _controllerPassword.text);
   if(newUser==null){
     print('error');
   }
   final newPerson=supabase.auth.currentSession?.user.id;
   await supabase.from('UserProfile').insert({
     'user_id':newPerson,
     'bio':_controllerBio.text,
     'address':_controllerAddress.text,
     'name':_controllerName.text
   });


  }
  catch (error) {
    print(error);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text('Register'),),

    body:Container(
      color:Colors.black,
      height:double.infinity,
      width:double.infinity,
      child:Column(
        children: [
          Image(image: AssetImage('assets/images/americano.png')),
          TextField(
            controller:_controllerName,
            style:TextStyle(color:Colors.white),
            decoration:InputDecoration(
              labelText:'Name',
              labelStyle:TextStyle(color:Colors.white)
            ),

          ),
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
          TextField(
            controller: _controllerBio,
            decoration:InputDecoration(
              labelText:'Bio',
              labelStyle:TextStyle(color:Colors.white)
            ),
          ),
          TextField(
            controller:_controllerAddress,
            decoration:InputDecoration(
              labelText:'Address',
              labelStyle:TextStyle(color:Colors.white)
            ),
          ),
          MaterialButton(onPressed: (){
         signup();

          },child:Text('Register',style:TextStyle(color:Colors.white),),),
          MaterialButton(onPressed: (){
            Navigator.pushNamed(context, '/forgetpassword');
          },child:Text('forget Password',style:TextStyle(color:Colors.white))),
          MaterialButton(onPressed: (){
            Navigator.pushNamed(context, '/register');
          },child:Text('Dont have an account? Register Here',style:TextStyle(color:Colors.white)))
        ],
      )
    )

    );
  }
}

