import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class profileSettings extends StatefulWidget {
  const profileSettings({super.key});

  @override
  State<profileSettings> createState() => _profileSettingsState();
}

class _profileSettingsState extends State<profileSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor:Colors.black,
        title: Text('Profile Settings',style:GoogleFonts.poppins(color:Colors.white)),
        leading:const Icon(Icons.arrow_back,color:Colors.white,),
      ),
      body:build_ui(context),
      backgroundColor:Colors.black,
    );

  }
  Widget build_ui(BuildContext context){
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            label:Text('Name')
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText:'Address'
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText:'Bio'
          ),
        ),
        MaterialButton(onPressed: (){},child:Text('Update'),color:Colors.green,)

      ],
    );

  }
}
