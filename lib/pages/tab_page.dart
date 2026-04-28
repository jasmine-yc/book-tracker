import 'package:flutter/material.dart';
import '../pages/library_page.dart'; // 你的首頁
// import 'setting_page.dart'; // 假設你以後會做一個設定頁

class MainTabPage extends StatelessWidget {
  const MainTabPage({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(), // 不要用滑的，只允許點 tab
          children: [
            LibraryPage(),
            Center(child: Text('即將推出')),
            Center(child: Text('設定')),
          ],
        ),
        bottomNavigationBar: const Material(
          color: Color.fromARGB(255, 79, 94, 122),
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.category)),
              Tab(icon: Icon(Icons.settings)),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
      ),
    );
  }
}
