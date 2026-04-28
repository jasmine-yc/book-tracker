// 標準深綠 Color.fromARGB(255, 79, 122, 95),
// 標準深藍 Color.fromARGB(255, 79, 94, 122),
// 更深藍 Color.fromARGB(255, 39, 46, 59),
import 'package:book_app/models/book_status.dart';
import 'package:flutter/material.dart';

import '../models/book_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/book_provider.dart';

class LibraryPage2 extends ConsumerWidget {
  const LibraryPage2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(bookProvider);

    return Scaffold(
      backgroundColor: Color.fromARGB(118, 196, 203, 217),
      appBar: AppBar(
        // leading: Image.asset("assets/icon/app_icon.jpg"),
        backgroundColor: Color.fromARGB(255, 79, 94, 122),
        title: const Text(
          '屬於你的書櫃^^ 記下閃閃發亮的日常',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),

      // 會跟著箱子更新而更新
      body: books.isEmpty
      ? Center(child: Text('你的書櫃空空如也，按加號新增書籍'))
      : ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          Book book = books[index];

          return ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                ref.read(bookProvider.notifier).deleteBook(book);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (_) => AddBookDialog());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddBookDialog extends ConsumerStatefulWidget {
  const AddBookDialog({super.key});

  @override
  ConsumerState<AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends ConsumerState<AddBookDialog> {
  final titleController = TextEditingController();
  final authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('新增書籍'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: '書名'),
          ),
          TextField(
            controller: authorController,
            decoration: InputDecoration(labelText: '作者'),
          ),
        ],
      ),
      actions: [
        TextButton(child: Text('取消'), onPressed: () => Navigator.pop(context)),
        ElevatedButton(
          child: Text('新增'),
          onPressed: () {
            ref
                .read(bookProvider.notifier)
                .addBook(
                  book:Book(
                    title: titleController.text,
                    author: authorController.text,
                    status: BookStatus.unRead,
                    saveDate: DateTime.now(),
                  ),
                );

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
