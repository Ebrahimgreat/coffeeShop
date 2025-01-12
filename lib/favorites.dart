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
  final supabase = Supabase.instance.client;
  List<coffeeModel> favorites = [];
  List<int> favoritesId = [];
  var profileId = 0;

  Future<List<coffeeModel>> getData() async {
    try {
      final user = supabase.auth.currentSession!.user.id;

      final userId = await supabase
          .from('UserProfile')
          .select('id')
          .eq('user_id', user)
          .single();
      profileId = userId['id'];

      final items = await supabase
          .from('favorites')
          .select('*')
          .eq('user_profile', userId['id']);

      final coffeeIds = (items as List<dynamic>)
          .map((favorite) => favorite['coffee_id'])
          .toList();
      favoritesId =
          (items as List<dynamic>).map((item) => item['id'] as int).toList();
      final response = await supabase
          .from('coffee')
          .select('*')
          .or(coffeeIds.map((id) => 'id.eq.$id').join(','));

      final favs = await supabase.rpc('get_favorites');

      setState(() {
        favorites = (response as List<dynamic>)
            .map((json) => coffeeModel.fromJson(json as Map<String, dynamic>))
            .toList();
      });
    } catch (error) {
      print(error);
    }
    return favorites;
  }

  void initState() {
    getData();
  }

  void deleteItem(i) async {
    await supabase
        .from('favorites')
        .delete()
        .eq('id', i)
        .eq('user_profile', profileId);
    print(i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Favorites',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const Icon(Icons.arrow_back, color: Colors.white),
          actions: [
            const Icon(Icons.person, color: Colors.white),
          ],
          backgroundColor: const Color(0xFF0C0F14),
          elevation: 0,
        ),
        bottomNavigationBar: navigation(),
        body: _buildUI(context),
        backgroundColor: Color(0xFF0C0F14));
  }

  var index = 0;
  var itemCount = 0;

  Widget _buildUI(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<coffeeProvider>(
      builder: (context, coffee, child) {
        itemCount = favorites.length;
        if (itemCount == 0) {
          return Center(
            child: Text(
              'No favorites yet',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return PageView.builder(
          itemCount: itemCount,
          controller: PageController(viewportFraction: 1.0),
          onPageChanged: (int page) {
            setState(() {
              index = page;
            });
          },
          itemBuilder: (context, int i) {
            final favs = favorites[i];
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  '${favs.photo}',
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            favs.name ??
                                'Unknown Name', 
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            favs.description ??
                                'No description available.', 
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MaterialButton(
                                onPressed: () {},
                                child: const Text('S'),
                                color: Colors.green,
                              ),
                              MaterialButton(
                                onPressed: () {},
                                child: const Text('M'),
                                color: Colors.green,
                              ),
                              MaterialButton(
                                onPressed: () {},
                                child: const Text('L'),
                                color: Colors.green,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: MaterialButton(
                              onPressed: () {
                                deleteItem(favoritesId[i]);
                              },
                              child: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
