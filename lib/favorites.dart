import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectflutter/components/navigation.dart';
import 'package:projectflutter/models/coffeeModel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'coffeeStateProvider.dart';
class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final supabase=Supabase.instance.client;
  List<coffeeModel> favorites=[];
  List<int> favoritesId=[];
  var profileId=0;

  Future<List<coffeeModel>> getData() async{
    try{
     final  user=supabase.auth.currentSession!.user.id;

     final userId=await supabase.from('UserProfile').select('id').eq('user_id',user).single();
     profileId=userId['id'];


     final items=await supabase.from('favorites').select('*').eq('user_profile',userId['id']);

    final coffeeIds=(items as List<dynamic>).map((favorite)=>favorite['coffee_id']).toList();
     favoritesId = (items as List<dynamic>)
         .map((item) => item['id'] as int) // Cast `item['id']` to int
         .toList();
     final response = await supabase
         .from('coffee')
         .select('*')
         .or(coffeeIds.map((id) => 'id.eq.$id').join(','));




      final favs=await supabase.rpc('get_favorites');

      setState(() {
        favorites=(response as List<dynamic>).map((json)=>coffeeModel.fromJson(json as Map<String,dynamic>)).toList();


      });



    }
    catch(error){
      print(error);
    }
return favorites;


  }
  void initState(){
    getData();
  }

 void deleteItem(i) async{
    await supabase.from('favorites').delete().eq('id',i).eq('user_profile',profileId);
    print(i);

 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Favorites'),
        leading:const Icon(Icons.arrow_back),
        actions: [
          const Icon(Icons.person)
        ],

      ),
      bottomNavigationBar:navigation(),
      body:_buildUI(context),
      backgroundColor:Colors.black,
    );
  }
  var index=0;
  var itemCount=0;

  Widget _buildUI(BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;


    return Consumer<coffeeProvider>(
      builder:(context,coffee,child){
        itemCount=favorites.length;
        if(itemCount==0)
          {
            return Text('No favorties yet');
          }
        return Column(
          children: [
        Text('Total Favorties: $itemCount',style:TextStyle(color:Colors.white),),
           

            Expanded(child:

            PageView.builder(

              itemCount:itemCount,
                controller:PageController(viewportFraction:1.0),
                onPageChanged:(int page){
                setState(() {
                  index=page;
                });

        },

                itemBuilder:( context, int i){

                final favs=favorites[i];
return Padding(
               padding:const EdgeInsets.all(8.0),
    child:Column(
                  children: [
                    MaterialButton(onPressed: (){
                     coffee.addFavorites(favs);
                    },child:Icon(Icons.delete)),

                   Image(image: AssetImage('${favs.photo}'),width:screenHeight*0.2,),

                  Container(
                    decoration:BoxDecoration(

                      borderRadius:BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:Colors.black.withOpacity(0.2)
                        )
                      ]
                    ),


                      padding: const EdgeInsets.all(8.0), // Optional padding inside the container
                      width:double.infinity,
                     child: Column(

                       crossAxisAlignment:CrossAxisAlignment.center,

                     children: [



                       Text('${favs.name}',style:GoogleFonts.poppins(color:Colors.white),),
                       Text('',style:TextStyle(color:Colors.white)),

                  ]
                     )

                   ),


                        Container(
                         color:Color(0XFF262B33),


                          height:screenHeight*0.2,
                          child:Column(
                              crossAxisAlignment:CrossAxisAlignment.start,


                              children: [
                                SizedBox(
                                  height:screenHeight*0.02,
                                ),
                    const Text('Description',style:TextStyle(color:Color(0XFFAEAEAE))),
                          SizedBox(
                            height:screenWidth*0.05,

                          ),
                          Text('${favs.description}',style:TextStyle(color:Colors.white)),
]
                          )

                        ),
                    Text('Sizes ',style:TextStyle(color:Colors.white),),

                    Container(
                      child:Row(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(onPressed: (){},child:const Text('S'
                          ),color:Colors.green,),
                          MaterialButton(onPressed: (){},child:const Text('M'
                          ),color:Colors.green,),
                          MaterialButton(onPressed: (){},child:const Text('L'
                          ),color:Colors.green,)




                        ],
                      ),
                    ),



                    Center(
                      child:MaterialButton(onPressed: (


                          ){
                        deleteItem(favoritesId[i]);

                      },
                      child:const Icon(Icons.delete),color:Colors.red,)
                    )



                 ],

                      ),










                );



            }
        )
            )


          ],

        );



      },
    );

  }
}
