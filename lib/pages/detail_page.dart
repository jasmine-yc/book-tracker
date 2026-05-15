import 'package:flutter/material.dart';
import 'package:book_app/models/book_data.dart';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:book_app/pages/edit_page.dart';

class DetailPage extends StatelessWidget {
  final Book book;

  const DetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Book>('books').listenable(),
      builder: (context, Box<Book> box, _) {
        final updatedBook = box.get(book.key) ?? book;

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: Text(
                '檢視書籍',
                style: TextStyle(color: Colors.white70),
              ),
              backgroundColor: const Color.fromARGB(255, 150, 123, 182),
              actions: [
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.black,
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('刪除書籍'),
                        content: Text('確定要刪除「${updatedBook.title}」嗎?'),
                        actions: [
                          TextButton(
                            child: const Text('取消'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text(
                              '刪除',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              await updatedBook.delete();
                              if (!context.mounted) return;
                              Navigator.pop(context); // 關閉對話框
                              Navigator.pop(context); // 返回上一頁
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              bottom: TabBar(
                unselectedLabelColor: Colors.white60,
                labelColor: Colors.grey[100],
                indicatorColor: Colors.grey[100],
                tabs: [
                  Tab(text: 'INFO'),
                  Tab(text: 'NOTE'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // TAB 1：書籍資訊
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          image:
                              updatedBook.coverImagePath != null &&
                                  updatedBook.coverImagePath!.isNotEmpty
                              ? DecorationImage(
                                  image: FileImage(
                                    File(updatedBook.coverImagePath!),
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child:
                            updatedBook.coverImagePath == null ||
                                updatedBook.coverImagePath!.isEmpty
                            ? const Icon(Icons.book, size: 80)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        updatedBook.title,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.portrait),
                          const Text(
                            "作者：",
                            maxLines: 1,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            updatedBook.author,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 255, 0, 102),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('標籤：', style: TextStyle(fontSize: 18)),
                          Expanded(
                            child:
                                updatedBook.tags != null &&
                                    updatedBook.tags!.isNotEmpty
                                ? Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: updatedBook.tags!.map((tag) {
                                      return Text(
                                        tag,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                            255,
                                            39,
                                            32,
                                            255,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                : const Text(
                                    '(無)',
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "原始儲存時間：${updatedBook.saveDate}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "最新儲存時間：${updatedBook.saveDate}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text("評分：", style: TextStyle(fontSize: 18)),
                          updatedBook.rate != null
                              ? Text(
                                  "${updatedBook.rate}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 39, 32, 255),
                                  ),
                                )
                              : const Text(
                                  '(無)',
                                  style: TextStyle(fontSize: 18),
                                ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '狀態：${book.status}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // TAB 2：書評
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //const Text("筆記 >>", style: TextStyle(fontSize: 18)),
                      //const SizedBox(height: 8),
                      SelectableText(
                        updatedBook.note,
                        style: TextStyle(fontSize: 18, color: Colors.teal[800]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color.fromARGB(255,150,123,182),
              tooltip: '編輯',
              child: const Icon(Icons.edit, color: Colors.white),
              onPressed: () async {
                await Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) =>
                        EditPage(book: updatedBook, bookKey: updatedBook.key),
                  ),
                );
                print("original key: ${book.key}");
                print("updated key: ${updatedBook.key}");
              },
            ),
          ),
        );
      },
    );
  }
}
