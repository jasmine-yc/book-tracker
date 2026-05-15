// package
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("設定")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("關於 App"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AboutDialog(
                  applicationIcon: Image.asset("assets/icon/app_icon.jpg", width:80),
                  applicationLegalese: 'Legalese',
                  applicationName: '季夏',
                  applicationVersion: 'version 1.0.0',
                ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text("版本"),
            subtitle: const Text("1.0.0"),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text("隱私政策"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("登出"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}