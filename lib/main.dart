import 'package:flutter/material.dart';
import 'models/book_data.dart';
import 'package:hive_flutter/hive_flutter.dart';
// page
import 'pages/main_page.dart';
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
      home:MainPage(),
      color: Colors.grey[850],
      theme:ThemeData(
        colorSchemeSeed: Color.fromARGB(255,150,123,182),
        textTheme: GoogleFonts.notoSerifTcTextTheme(),
      )
    );
  }
}