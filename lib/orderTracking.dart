import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectflutter/components/navigation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class orderTracking extends StatefulWidget {
  const orderTracking({super.key});

  @override
  State<orderTracking> createState() => _orderTrackingState();
}

class _orderTrackingState extends State<orderTracking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('Order Tracking',style:GoogleFonts.poppins(color:Colors.white)),
            backgroundColor:Colors.black,
      ),
      bottomNavigationBar: navigation(),
      backgroundColor:Colors.black,
      body:Stack(
        
        children: [
          Text('Estimated time of Delivery',style:GoogleFonts.poppins(color:Colors.white),),
          Text('15-20 minutes',style:GoogleFonts.poppins(color:Colors.white),),
         FlutterMap(

           options:MapOptions(
             initialZoom:10,
             initialCenter:LatLng(30.3753,  69.3451)
           ),


             children:[
               TileLayer(
                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server

               ),
           MarkerLayer(markers: [
             Marker(point: LatLng(30.3753,  69.3451), child:Icon(Icons.delivery_dining_sharp)),
             Marker(point: LatLng(30.3753,  69.3451), child:Text('Your order is coming')),



           ]),
           RichAttributionWidget(attributions:[
             TextSourceAttribution('Ebrahim Coffee Shop'),
           ])

         ])
       
        ],

      )


    );

  }
}
