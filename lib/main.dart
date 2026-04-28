// 標準深綠 Color.fromARGB(255, 79, 122, 95),
// 標準深藍 Color.fromARGB(255, 79, 94, 122),
// 更深藍 Color.fromARGB(255, 39, 46, 59),
// 亮藍色Color.fromARGB(255, 217, 227, 255)
// 紅色 Color.fromARGB(255, 205, 127, 127)
import 'package:flutter/material.dart';
import 'models/book_data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/library_page.dart';
//import 'pages/test_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './models/book_status.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(BookStatusAdapter());
  Hive.registerAdapter(BookAdapter());
  await Hive.openBox<Book>('books');

  runApp (
    ProviderScope(child: MyApp()),
  );
  
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '書籍記錄',
      home:LibraryPage(),
      color: Colors.grey[850],
      theme:ThemeData(
        colorSchemeSeed: Colors.black,
        textTheme: GoogleFonts.notoSerifTcTextTheme(),
      )
    );
  }
}