import 'dart:io';
import 'package:flutter/material.dart';
import 'package:book_app/models/book_data.dart';
import 'package:book_app/models/book_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/book_provider.dart';
import '../pages/detail_page.dart';

class BookCard extends ConsumerWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: book.status == BookStatus.finished
          ? const Color.fromARGB(255, 238, 226, 226)
          : const Color.fromARGB(255, 178, 207, 223),
      elevation: 2, // 陰影
      shape: const RoundedRectangleBorder(
        // 修改形狀
        side: BorderSide(
          color: Colors.black87, // 邊框顏色
          width: 1, // 邊框寬度
        ),
        // 修改圓角
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),

      child: ListTile(
        trailing: Icon(Icons.keyboard_arrow_right_rounded),

        // 前面有一個封面圖
        leading:
            (book.coverImagePath != null && book.coverImagePath!.isNotEmpty)
            ? CircleAvatar(
                backgroundImage: FileImage(File(book.coverImagePath!)),
              )
            : CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.book,
                  color: book.status== BookStatus.finished?Color.fromARGB(255, 165, 83, 83):Color.fromARGB(255, 83, 110, 165),
                ),
              ),
        title: Text(
          book.title,
          style: const TextStyle(
            color: Color.fromARGB(255, 52, 69, 56),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          book.author,
          style: const TextStyle(color: Colors.black54),
        ),
        // 點擊進入檢視頁面 帶入書本資料
        onTap: () {
          Navigator.of(context).push<void>(
            MaterialPageRoute(builder: (context) => DetailPage(book: book)),
          );
        },
        onLongPress: () {
          ref.read(bookProvider.notifier).deleteBook(book);
        },
      ),
    );
  }
}
