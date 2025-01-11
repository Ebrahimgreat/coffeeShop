import 'package:flutter/material.dart';
class navigation extends StatelessWidget {
  const navigation({super.key});

  @override

  Widget build(BuildContext context) {

      return  BottomNavigationBar(
        backgroundColor:Colors.black,
        type:BottomNavigationBarType.fixed,
        onTap:(index){
        if(index==0)
          {
            Navigator.pushNamed(context, '/dashboard');
          }
        else if(index==1){
          Navigator.pushNamed(context, '/favorites');
        }
        else if(index==2){
          Navigator.pushNamed(context, '/cart');
        }

        },


          items: const<BottomNavigationBarItem>[

       BottomNavigationBarItem(



         icon:Icon(Icons.home,color:Colors.white,),

         label: ''

       ),
        BottomNavigationBarItem(

            icon:Icon(Icons.favorite,color:Colors.red,),


            label: '',
        ),
        BottomNavigationBarItem(
            icon:Icon(Icons.shopping_bag_rounded,color:Colors.green,),
          label: '',
        ),

        BottomNavigationBarItem(
            icon:Icon(Icons.notifications,color:Colors.white,),
          label: '',
        )


      ]
      );
  }
}
