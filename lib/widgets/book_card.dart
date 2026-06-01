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

  String _getStatusText(BookStatus status) {
    switch (status) {
      case BookStatus.unRead:
        return '未讀';

      case BookStatus.reading:
        return '閱讀中';

      case BookStatus.finished:
        return '完讀';
    }
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: book.status == BookStatus.finished
          ? Colors.blueGrey[50] // 看完
          : Colors.lightGreen[50], // 未讀/閱讀中
      elevation: 2, // 陰影
      shape: const RoundedRectangleBorder(
        // 修改形狀
        side: BorderSide(
          color: Color.fromARGB(255, 79, 94, 122), // 邊框顏色
          style:BorderStyle.solid,
          width: 1.0, // 邊框寬度
        ),
        // 修改圓角
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),

      child: ListTile(        
        trailing: IconButton(
          onPressed:() async{
            await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditPage(book: book, bookKey: book.key,)),
            );
          },
          icon: Icon(Icons.edit),
          color: book.status== BookStatus.finished?Color.fromARGB(255, 83, 109, 165):Colors.blueGrey,
          
        ),

        // 前面有一個封面圖
        leading:
            (book.coverImagePath != null && book.coverImagePath!.isNotEmpty)
            ? CircleAvatar(
                radius:50,
                backgroundImage: FileImage(File(book.coverImagePath!)),
              )
            : CircleAvatar(
                backgroundColor: book.status== BookStatus.finished?Color.fromARGB(255, 83, 109, 165):Colors.blueGrey,
                child: Icon(
                  Icons.book,
                  color: Colors.grey[50],
                ),
              ),
        title: Text(
          book.title,
          maxLines:1,
          style: const TextStyle(
            // fontSize: 18,
            color: Color.fromARGB(255, 55, 52, 69),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("- 作者：${book.author}", maxLines:1, style: const TextStyle(color: Colors.black54),),
            Text("- 評分：${book.rate.toString()} / 閱讀狀態：${_getStatusText(book.status)}",maxLines:1, style: const TextStyle(color: Colors.black54)),
          ],
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
              title: Text('刪除'),
              content: Text('確認刪除「${book.title}」嗎？'),
              actions:[            
                TextButton(
                  child:const Text('取消'),
                  onPressed:(){
                    Navigator.of(context).pop();
                  }           
                ),
                TextButton(
                  child:Text('刪除', style:TextStyle(color:Colors.red[600])),
                  onPressed:(){
                    ref.read(bookProvider.notifier).deleteBook(book);
                    Navigator.of(context).pop();
                  }           
                ),
              ]
            )
          );
        },
      ),
    );
  }
}
