// models
import 'package:book_app/models/book_data.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// providers
import '../providers/search_query_provider.dart';
import '../providers/selected_tags_provider.dart';
import '../providers/book_provider.dart';

final filteredBooksProvider= Provider<List<Book>>((ref) {
  final books = ref.watch(bookProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedTags = ref.watch(selectedTagsProvider);

  return books.where((book) {
    final title = book.title.toLowerCase();
    final author = book.author.toLowerCase();

    final matchesSearch =
        searchQuery.isEmpty ||
        title.contains(searchQuery) ||
        author.contains(searchQuery);

    final matchesTags =
        selectedTags.isEmpty ||
        selectedTags.contains('全部') ||
        selectedTags.every((tag) => book.hasTag(tag));

    return matchesSearch && matchesTags;
  }).toList();
}); 