

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectflutter/Auth.dart';
import 'package:projectflutter/coffeeStateProvider.dart';
import 'package:projectflutter/components/navigation.dart';
import 'package:projectflutter/models/coffeeModel.dart';
import 'package:projectflutter/models/coffeePrice.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'getCoffeeDetails.dart';

import 'models/dashboardModa.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}




class _dashboardState extends State<dashboard> with SingleTickerProviderStateMixin {

  List<coffeeModel> coffees = [];
  List<CoffeePrice> prices=[];
  List<CoffeeDashboard> dashboardItems=[];


  void addToFavorites(id) async
  {
    final supabase=Supabase.instance.client;
    final user=supabase.auth.currentSession!.user.id;
    try{
     final userProfile= await supabase.from('UserProfile').select('id').eq('user_id', user).single();

      await supabase.from('favorites').insert({
        'coffee_id':id,
        'user_profile':userProfile['id']

      });




    }
    catch(error){
      print(error);
    }
  }

  late TabController _tabController;
  var dashboardCoffee=[];
  SearchController searchController= SearchController();



  @override
  void initState(){
    Provider.of<CoffeeDashboard>(context,listen:false).getData();
    super.initState();
    _tabController=TabController(length:4,vsync:this,initialIndex:0);
    _tabController.addListener(_handleTabSelection);


  }
  String query='';





_handleTabSelection()
{
  if(_tabController.indexIsChanging)
    {
      print(_tabController.index);



      Provider.of<CoffeeDashboard>(context,listen:false).filterCoffee(_tabController.index);


    }
}

void filterData()
{

}
@override
void dispose(){
    _tabController.dispose();
    super.dispose();
}



  Widget build(BuildContext context) {



var items=['Settings','Logout'];
String dropdownvalue='Settings';


    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:Color(0XFF0C0F14),
      bottomNavigationBar:navigation(),
      appBar:AppBar(

        backgroundColor:Colors.black,
        toolbarHeight:100.0,
        title:SizedBox(

          child: Column(

            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [


               Text('Find The Best ',style:GoogleFonts.poppins(
                 color:Colors.white,
                 fontWeight:FontWeight.w700,
               )),
              Text(' Cofeee for you',style:GoogleFonts.poppins(
                  color:Colors.white,
                fontWeight:FontWeight.w700
              )),

            ],

          ),




        ),

        actions: [
          MaterialButton(onPressed: (){
            Navigator.pushNamed(context, '/account');
          },
          child:const Icon(Icons.person,color:Colors.white,),)

              ],


      ),
      body:
      Column(
        mainAxisAlignment:MainAxisAlignment.end,
        children: [
          MaterialButton(onPressed: (){

          },child:Text('Logout'),),

         Container(

          width: screenWidth*1,

           child: SearchBar(



             onChanged:(query){
              Provider.of<CoffeeDashboard>(context,listen:false).searchCoffee(query);
             }


               )

           ),

          TabBar(
            controller:_tabController,

            tabs:

          [

            Tab(text:'All',),
            Tab(text:'Hot Coffee'),
            Tab(text:'Cold Coffee'),
            Tab(text:'Decaf')

          ],
              labelColor:Colors.red,

            unselectedLabelColor:Color(0XFF52555A),
            isScrollable:true,
            indicator:UnderlineTabIndicator(
              borderSide:BorderSide(
                width:3,
                color:Colors.red
              )



            )
          ),
          SizedBox(
            height:20
          ),



          Expanded(


            child:GridView.builder(
              itemCount:Provider.of<CoffeeDashboard>(context,listen:true).coffee.length,
              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
              crossAxisSpacing:8,mainAxisSpacing:8),
              itemBuilder:(BuildContext context,int index){
                final coffee=Provider.of<CoffeeDashboard>(context,listen:true).coffee[index];

                return Container(


                  decoration:BoxDecoration(
                    borderRadius:BorderRadius.circular(30),
                    color:Color(0XFF252A32),

                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                   Image(image: AssetImage('${coffee.coffee_photo}'),width:screenWidth*0.15,),
                      MaterialButton(onPressed: (){
                      Provider.of<coffeeDetails>(context,listen:false).setCoffee(coffee.id);
                        
                        Navigator.pushNamed(context, '/coffee_detail');
                        
                      },child:Text ('${coffee.coffee_name}',style:TextStyle(color:Colors.white),)),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [

                          Text('${coffee.coffee_price}',style:GoogleFonts.poppins(color:Colors.white),),

                          IconButton(onPressed:()=>
                              addToFavorites(coffee.id)






                          ,icon: const Icon(Icons.favorite)),
                          MaterialButton(
                            minWidth:10,
                            onPressed: (




                              ){
                              const snackbar=SnackBar(content: Text('Added To cart'));
                              ScaffoldMessenger.of(context).showSnackBar(snackbar);

                              final provider=Provider.of<coffeeProvider>(context,listen:false).addToCart(coffee.id,'small');

                            print('Added');

                          }, child: Icon(Icons.add,color:Colors.white),color:Color(0XFFD17842),),


                        ],
                      )
                    ],



                  ),


                );




              }


          )
          )




        ],


      ),






    );
  }
}
