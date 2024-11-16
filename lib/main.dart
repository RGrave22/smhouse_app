import 'package:flutter/material.dart';
import 'package:smhouse_app/HomePage.dart';
import 'package:smhouse_app/Light/LightPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smhouse_app/Profile/ProfilePage.dart';
import 'package:smhouse_app/RoomPage/RoomPage.dart';

import 'Login/LoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
          textTheme: const TextTheme(
            titleMedium: TextStyle(color: Colors.black),
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        home: Scaffold(
            backgroundColor:  Colors.white,
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
                )
            )
        ));
  }

}
class MainPage extends StatefulWidget {

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;

  late String username = "";

  int currentIndex = 0;

  void navigateToPage(int index) {
    setState(() { 
      currentIndex = index;
      _tabController.animateTo(index);
    });
  }

 @override
  void initState() {

    super.initState();
      _tabController = TabController(length: screens.length, vsync: this);
  }

  /**
   * ADICIONAR PAGINA NO ARRAY dos SCREENS E VERIFICAR O NUMERO PARA QUANDO CARREGAR LA IR PARA A PAGINA
   */
  final screens = [
    const HomePage(),
    //VER SE PODE FICAR AQUI ISTO ASSIM GRAVE
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
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
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.9, 
                  heightFactor: 0.9, 
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/Logo_init.jpeg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.house),
              title: const Text('Menu Principal'),
              onTap: () {
                navigateToPage(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.map),
              title: const Text('Mapa'),
              onTap: () {
                navigateToPage(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.userGroup),
              title: const Text('Grupos'),
              onTap: () {
                navigateToPage(3);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const FaIcon(FontAwesomeIcons.chalkboardUser),
              title: const Text('Tutores'),
              onTap: () {
                navigateToPage(4);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const FaIcon(FontAwesomeIcons.newspaper),
              title: const Text('Noticias'),
              onTap: () {
                navigateToPage(5);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const FaIcon(FontAwesomeIcons.searchengin),
              title: const Text('Perdidos e Achados'),
              onTap: () {
                navigateToPage(1);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const FaIcon(FontAwesomeIcons.utensils),
              title: const Text('Refeitorio'),
              onTap: () {
                navigateToPage(6);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const FaIcon(FontAwesomeIcons.circleInfo),
              title: const Text('Sobre Nós'),
              onTap: () {
                navigateToPage(7);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const FaIcon(FontAwesomeIcons.gear),
              title: const Text('Definições'),
              onTap: () {
                navigateToPage(8);
                Navigator.pop(context);
              },
            ),

      

          ],
        ),
      ),
      body: screens[
          currentIndex], 

      bottomNavigationBar: Container(
        height: 42,
        color: const Color.fromARGB(255, 2, 58, 103),
        child: TabBar(
          controller: _tabController,
          onTap: (index) => setState(() => currentIndex = index),
          isScrollable: true,
          tabs: const [
            SizedBox(
              width: 50,
              child: Tab(
                icon: Icon(
                  FontAwesomeIcons.house,
                  color: Colors.white,
                ),
              ),
            ),
          //   SizedBox(
          //     width: 50,
          //     child: Tab(
          //       icon: Icon(
          //         FontAwesomeIcons.searchengin,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          //   SizedBox(
          //     width: 50,
          //     child: Tab(
          //       icon: Icon(
          //         FontAwesomeIcons.map,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          //   SizedBox(
          //     width: 50,
          //     child: Tab(
          //       icon: FaIcon(
          //         FontAwesomeIcons.userGroup,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          //   SizedBox(
          //     width: 50,
          //     child: Tab(
          //       icon: FaIcon(
          //         FontAwesomeIcons.chalkboardUser,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          //   SizedBox(
          //     width: 50,
          //     child: Tab(
          //       icon: FaIcon(
          //         FontAwesomeIcons.newspaper,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          //   SizedBox(
          //     width: 50,
          //     child: Tab(
          //       icon: FaIcon(
          //         FontAwesomeIcons.utensils,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          //   SizedBox(
          //     width: 50,
          //     child: Tab(
          //       icon: FaIcon(
          //         FontAwesomeIcons.circleInfo,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          //   SizedBox(
          //     width: 50,
          //     child: Tab(
          //       icon: FaIcon(
          //         FontAwesomeIcons.gear,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          //   SizedBox(
          //     width: 50,
          //     child: Tab(
          //       icon: FaIcon(
          //         Icons.person,
          //         size: 38,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
           ],
        ),
      ),
    );
  }
}




