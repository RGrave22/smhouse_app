import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smhouse_app/AboutUs/AboutUsPage.dart';
import 'package:smhouse_app/HomePage.dart';
import 'package:smhouse_app/Login/LoginPage.dart';
import 'package:smhouse_app/Settings/SettingsPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smhouse_app/Profile/ProfilePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Allow only portrait mode
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SmHouse',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Colors.black),
          textTheme: const TextTheme(
            titleMedium: TextStyle(color: Colors.black),
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        home: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                  child: Image.asset(
                    'assets/Logo_init.jpeg',
                    width: 300,
                    height: 200,
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 70),
                    alignment: Alignment.center,
                    width: 350.0,
                    height: 550.0,
                    child: LoginScreen(),
                  ),
                ),
              ],
            ))));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  int currentIndex = 0;

  final _navigatorKey = GlobalKey<NavigatorState>();
  late String username = "";

  final List<Widget> tabBarScreens = [
    const HomePage(),
  ];

  final List<Tab> tabBarItems = const [
    Tab(icon: Icon(FontAwesomeIcons.house, color: Colors.white)),
  ];

  final List<Widget> hamburgerMenuScreens = [
    const HomePage(),
    const ProfilePage(),
    const AboutUsPage(),
    SettingsPage(),
    const MyApp()
  ];

  final List<Map<String, dynamic>> hamburgerMenuItems = [
    {'icon': FontAwesomeIcons.house, 'title': 'Menu Principal', 'index': 0},
    {'icon': FontAwesomeIcons.user, 'title': 'Profile', 'index': 1},
    {'icon': FontAwesomeIcons.circleInfo, 'title': 'About Us', 'index': 2},
    {'icon': FontAwesomeIcons.gear, 'title': 'Settings', 'index': 3},
    {'icon': Icons.logout, 'title': 'LogOut ', 'index': 4},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabBarItems.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onTabBarItemTapped(int index) {
    setState(() {
      currentIndex = index;
      _tabController.animateTo(index);
    });
  }

  void onHamburgerMenuItemTapped(int index) {
    Navigator.pop(context);
    if (index < tabBarScreens.length) {
      onTabBarItemTapped(index);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => hamburgerMenuScreens[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu, color: Colors.teal),
          iconSize: 50,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            icon: const Icon(Icons.account_circle, color: Colors.teal),
            iconSize: 50,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  heightFactor: 0.9,
                  child:
                      Image.asset('assets/Logo_init.jpeg', fit: BoxFit.contain),
                ),
              ),
            ),
            ...hamburgerMenuItems.map((item) {
              return ListTile(
                leading: FaIcon(item['icon']),
                title: Text(item['title']),
                onTap: () => onHamburgerMenuItemTapped(item['index']),
              );
            }).toList(),
          ],
        ),
      ),
      body: hamburgerMenuScreens[currentIndex], // Use the selected page
      // bottomNavigationBar: Container(
      //   height: 42,
      //   color: const Color.fromARGB(255, 2, 58, 103),
      //   child: TabBar(
      //     controller: _tabController,
      //     onTap: (index) => onTabBarItemTapped(index),
      //     tabs: tabBarItems,
      //   ),
      // ),
    );
  }
}
