import 'dart:io';
// package
import 'package:flutter/material.dart';
import 'package:book_app/models/book_data.dart';
import 'package:book_app/models/book_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// provider
import '../providers/book_provider.dart';
// page
import '../pages/detail_page.dart';
import '../pages/edit_page.dart';

class BookCard extends ConsumerWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: book.status == BookStatus.finished
          ? const Color.fromARGB(255, 242, 237, 237) // 看完
          : const Color.fromARGB(255, 243, 238, 244), // 未讀/閱讀中
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
        trailing: IconButton(
          onPressed:() async{
            await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditPage(book: book, bookKey: book.key,)),
            );
          },
          icon: Icon(Icons.edit),
          color: Colors.deepPurple,
        ),

        // 前面有一個封面圖
        leading:
            (book.coverImagePath != null && book.coverImagePath!.isNotEmpty)
            ? CircleAvatar(
                backgroundImage: FileImage(File(book.coverImagePath!)),
              )
            : CircleAvatar(
                backgroundColor: Colors.grey[50],
                child: Icon(
                  Icons.book,
                  color: book.status== BookStatus.finished?Color.fromARGB(255, 165, 83, 83):Color.fromARGB(255, 127, 91, 171),
                ),
              ),
        title: Text(
          book.status== BookStatus.finished
          ?'${book.title}[完讀✓]'
          :'${book.title}[未完]',
          maxLines:1,
          style: const TextStyle(
            color: Color.fromARGB(255, 65, 52, 69),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          book.author,
          maxLines:1,
          style: const TextStyle(color: Colors.black54),
        ),
        // 點擊進入檢視頁面 帶入書本資料
        onTap: () {
          Navigator.of(context).push<void>(
            MaterialPageRoute(builder: (context) => DetailPage(book: book)),
          );
        },
    
        onLongPress: () {
          showDialog(
            context: context,
            builder:(context)=>AlertDialog(
              contentPadding: const EdgeInsets.all(20.0),
              title: Text('確認刪除${book.title}嗎？'),
              content: const Text('將會永久刪除該書籍的相關紀錄'),
              actions:[
                TextButton(
                  child:const Text('刪除'),
                  onPressed:(){
                    ref.read(bookProvider.notifier).deleteBook(book);
                    Navigator.of(context).pop();
                  }           
                ),
                TextButton(
                  child:const Text('取消'),
                  onPressed:(){
                    Navigator.of(context).pop();
                  }           
                )
              ]
            )
          );
        },
      ),
    );
  }
}
