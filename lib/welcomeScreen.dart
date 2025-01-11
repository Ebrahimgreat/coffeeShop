import 'package:flutter/material.dart';
import 'package:projectflutter/components/navigation.dart';
import 'package:google_fonts/google_fonts.dart';

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      body:Stack(
        children: [
          Container(
        decoration:BoxDecoration(
          image:DecorationImage(
              image:AssetImage('assets/images/WelcomeImage.png'),
            fit:BoxFit.cover
        ),
        ),




      ),

          Container(

            alignment:Alignment.center,
              padding:EdgeInsets.only(top:MediaQuery.of(context).size.height*0.4),



              child:Column(


              mainAxisAlignment:MainAxisAlignment.center,
              children: [

                Text('Fall in Love with Coffee in Blissful Delight',

                  style:GoogleFonts.sora(fontSize:32,color:Colors.white,fontWeight:FontWeight.w600),


                ),
          Container(
            padding: EdgeInsets.only(bottom:40),


          ),


          Text('Welcome to our cozy coffee corner where every cup is '
              'delightful for you',style:GoogleFonts.sora(color:Colors.white,fontWeight:FontWeight.w900,fontSize:14)
          ),
                Container(
                  padding: EdgeInsets.only(bottom:40),

                ),


          Container(
              width: screenWidth * 1,
         height:screenHeight*0.06,

         child:  MaterialButton(
           color:Colors.green,

           onPressed: (){},child: Text('Get Started',style:GoogleFonts.sora(fontWeight:FontWeight.w400)),shape:RoundedRectangleBorder(

           side:BorderSide(style:BorderStyle.none),
           borderRadius:BorderRadius.circular(10)


          ),
           textColor:Colors.white,
          )
          ),
    ]

    )


    )
    ]
    )


    );
  }
}
