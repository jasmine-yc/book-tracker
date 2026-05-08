import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
// models
import '../models/book_data.dart';

final bookProvider = StateNotifierProvider<BookNotifier, List<Book>>((ref) {
  return BookNotifier();
});

class BookNotifier extends StateNotifier<List<Book>> {
  BookNotifier() : super([]) {
    loadBooks();
  }

  final box = Hive.box<Book>('books');

  void loadBooks() {
    state = box.values.toList();
  }

  void addBook({required Book book}) {
    box.add(book);
    loadBooks();
  }

  void deleteBook(Book book) {
    book.delete();
    loadBooks();
  }

  void updateBook({required Book book}) {

  book.save(); // 存進 Hive

  // 這裡直接產生新 List 給 Riverpod state
  state = box.values.toList(growable: false);
}
}
