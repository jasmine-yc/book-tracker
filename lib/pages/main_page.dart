// package
import 'package:flutter/material.dart';
// page
import './library_page.dart';
import './setting_page.dart';
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currIndex= 0;
  List<Widget> body= [
    LibraryPage(),
    Icon(Icons.menu),
    Icon(Icons.person),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Center(
        child: body[_currIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white24,
        onTap:(int newIndex){
          setState((){
            _currIndex= newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            backgroundColor:Color.fromARGB(255, 97, 100, 158),
            label: 'Home',
            icon:Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Category',
            icon:Icon(Icons.category_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon:Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'Setting',
            icon:Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}