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

class _dashboardState extends State<dashboard>
    with SingleTickerProviderStateMixin {
  List<coffeeModel> coffees = [];
  List<CoffeePrice> prices = [];
  List<CoffeeDashboard> dashboardItems = [];

  void addToFavorites(id) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentSession!.user.id;
    try {
      final userProfile = await supabase
          .from('UserProfile')
          .select('id')
          .eq('user_id', user)
          .single();

      await supabase
          .from('favorites')
          .insert({'coffee_id': id, 'user_profile': userProfile['id']});
    } catch (error) {
      print(error);
    }
  }

  late TabController _tabController;
  var dashboardCoffee = [];
  SearchController searchController = SearchController();

  @override
  void initState() {
    Provider.of<CoffeeDashboard>(context, listen: false).getData();
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
  }

  String query = '';

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      print(_tabController.index);
      Provider.of<CoffeeDashboard>(context, listen: false)
          .filterCoffee(_tabController.index);
    }
  }

  void filterData() {}

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    var items = ['Settings', 'Logout'];
    String dropdownvalue = 'Settings';

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0C0F14),
      bottomNavigationBar: navigation(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0F14),
        toolbarHeight: 100.0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Find The best',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                ),
              ),
              Text(
                'coffee for you',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 330,
                height: 45,
                child: TextField(
                  onChanged: (query) {
                    Provider.of<CoffeeDashboard>(context, listen: false)
                        .searchCoffee(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Find your coffee..',
                    hintStyle: const TextStyle(
                      color: Color(0xFF52555A),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF52555A),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF141921),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Hot Coffee'),
              Tab(text: 'Cold Coffee'),
              Tab(text: 'Decaf'),
            ],
            labelColor: Colors.red,
            unselectedLabelColor: Color(0xFF52555A),
            isScrollable: true,
            indicator: CircleTabIndicator(color: Colors.red, radius: 4),
            indicatorPadding: EdgeInsets.zero,
            dividerColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: Provider.of<CoffeeDashboard>(context, listen: true)
                  .coffee
                  .length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 0,
                childAspectRatio: 149 / 200,
              ),
              itemBuilder: (BuildContext context, int index) {
                final coffee =
                    Provider.of<CoffeeDashboard>(context, listen: true)
                        .coffee[index];
                return Container(
                  width: 149,
                  height: 246,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF0C0F14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 20,
                        left: 20,
                        right: 20,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            '${coffee.coffee_photo}',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image,
                                  color: Colors.white);
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${coffee.coffee_name}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'PKR ${coffee.coffee_price}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () => addToFavorites(coffee.id),
                                  icon: const Icon(Icons.favorite,
                                      color: Colors.white),
                                  iconSize: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    const snackbar = SnackBar(
                                        content: Text('Added To cart'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);

                                    Provider.of<coffeeProvider>(context,
                                            listen: false)
                                        .addToCart(coffee.id, 'small');
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD17842),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: const Icon(Icons.add,
                                        color: Colors.white, size: 18),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  final double radius;

  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  final double radius;

  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = color
      ..isAntiAlias = true;

    final Offset circleOffset = Offset(
      offset.dx + configuration.size!.width / 2,
      offset.dy + configuration.size!.height + radius,
    );

    canvas.drawCircle(circleOffset, radius, paint);
  }
}
