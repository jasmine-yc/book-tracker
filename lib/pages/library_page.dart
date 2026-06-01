// packages
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// models
import '../models/book_data.dart';
// pages
import '../pages/edit_page.dart';

// widgets
import '../widgets/book_card.dart';
// providers
import '../providers/book_provider.dart';
import '../providers/search_query_provider.dart';
import '../providers/selected_tags_provider.dart';
import '../providers/filtered_books_provider.dart';
import '../providers/all_tags_provider.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  late final TextEditingController searchController;
  Timer? _debounce; // 搜尋框更新

  Widget _highlightText(
    String text,
    String pattern, {
    bool isSubtitle = false,
  }) {
    if (pattern.isEmpty) {
      return Text(
        text,
        style: isSubtitle ? const TextStyle(fontSize: 13) : null,
      );
    }

    final lowerText = text.toLowerCase();
    final matches = <Match>[];
    int start = 0;

    while ((start = lowerText.indexOf(pattern, start)) != -1) {
      matches.add(Match(start, start + pattern.length));
      start += pattern.length;
    }

    if (matches.isEmpty) {
      return Text(
        text,
        style: isSubtitle ? const TextStyle(fontSize: 13) : null,
      );
    }

    final spans = <TextSpan>[];
    int lastEnd = 0;

    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            backgroundColor: Color(0xFFE3F2FD),
          ),
        ),
      );
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: TextStyle(color: Colors.black87, fontSize: isSubtitle ? 13 : 16),
      ),
    );
  }

  Future<void> navigateToEditPage(BuildContext context, {Book? book}) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditPage(book: book, bookKey: book?.key),
      ),
    );

    // 保護：使用者按返回沒儲存
    if (result == null || result['book'] == null) {
      return;
    }

    final newBook = result['book'] as Book;
    final isNew = result['isNew'] as bool? ?? true; //防呆

    if (isNew) {
      // 新增
      ref.read(bookProvider.notifier).addBook(book: newBook);
    } else {
      // 編輯
      ref.read(bookProvider.notifier).updateBook(book: newBook);
    }
    if (!context.mounted) return;

    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(isNew ? "新增成功" : "編輯儲存成功"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    // 同步
    searchController.text = ref.read(searchQueryProvider);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(bookProvider);
    final allTags = ref.watch(allTagsProvider);
    final selectedTags = ref.watch(selectedTagsProvider);

    // 篩選書籍
    final filteredBooks = ref.watch(filteredBooksProvider);

    // TODO: 根據 SortButton 狀態做排序（可再加一個 sortProvider）

    // -----------------------------------------------------
    return Scaffold(
      backgroundColor: Colors.grey[100], // 淺灰
      appBar: AppBar(
        leading: Image.asset("assets/icon/app_icon.jpg"),
        // backgroundColor: Color.fromARGB(255, 176, 196, 222), // LightSteelBlue
        // backgroundColor: Color.fromARGB(255, 61, 93, 133),
        backgroundColor: Color.fromARGB(255, 79, 94, 122), // 標準藍
        centerTitle: true,
        title: const Text(
          'YOUR LIBRARY',
          style: TextStyle(color: Colors.white, letterSpacing: 4),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch, // 撐滿寬度
        children: [
          // 搜尋框
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: TypeAheadField<Book>(
              controller: searchController,
              suggestionsCallback: (pattern) {
                if (pattern.isEmpty) return const [];

                final lowerPattern = pattern.toLowerCase().trim();
                final books = ref.watch(bookProvider); // 用 set 避免重複

                // 過濾並排序
                return books
                    .where(
                      (book) =>
                          book.title.toLowerCase().contains(lowerPattern) ||
                          book.author.toLowerCase().contains(lowerPattern),
                    )
                    .toList()
                  ..sort((a, b) {
                    // 標題>作者
                    final aTitleMatch = a.title.toLowerCase().contains(
                      lowerPattern,
                    );
                    final bTitleMatch = b.title.toLowerCase().contains(
                      lowerPattern,
                    );
                    if (aTitleMatch != bTitleMatch) return aTitleMatch ? -1 : 1;
                    return 0;
                  });
              },
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: '搜尋（書名/作者）',
                    prefixIcon: const Icon(Icons.search_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: controller.text.isNotEmpty
                    ?IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        controller.clear();
                        ref.read(searchQueryProvider.notifier).state = '';

                        if (_debounce?.isActive ?? false) {
                          _debounce!.cancel();
                        }
                        FocusScope.of(context).unfocus();
                        setState(() {});
                      },
                    )
                    :null,
                  ),
                  onChanged: (value) {
                    // debounce
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 250), () {
                      ref.read(searchQueryProvider.notifier).state = value
                          .trim()
                          .toLowerCase();
                    });
                  },
                );
              },
              itemBuilder: (context, Book book) {
                final pattern = searchController.text.toLowerCase().trim();
                final title = book.title;
                final author = book.author;

                return ListTile(
                  leading: const Icon(Icons.search, color: Colors.blueGrey),
                  title: _highlightText(title, pattern),
                  subtitle: _highlightText(author, pattern, isSubtitle: true),
                  trailing: Text(
                    "書名 - 作者",
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                );
              },
              onSelected: (Book book) {
                searchController.text = book.title;
                ref.read(searchQueryProvider.notifier).state = book.title
                    .toLowerCase();

                FocusScope.of(context).unfocus(); // 關閉鍵盤
              },
              hideOnEmpty: true,
              hideOnLoading: true,
            ),
          ),
          // 標籤搜尋
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
            child: TypeAheadField<String>(
              suggestionsCallback: (pattern) {
                final results = allTags
                    .where(
                      (tag) =>
                          tag.toLowerCase().contains(pattern.toLowerCase()) &&
                          !selectedTags.contains(tag),
                    )
                    .take(5)
                    .toList();
                if (pattern.isNotEmpty &&
                    !allTags.contains(pattern) &&
                    !selectedTags.contains(pattern)) {
                  results.insert(0, '新增 "$pattern"');
                }
                return results;
              },
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: false,

                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.tag),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    border: UnderlineInputBorder(),
                    hintText: '標籤篩選',
                  ),
                );
              },
              itemBuilder: (context, suggestion) {
                return ListTile(title: Text(suggestion));
              },

              onSelected: (suggestion) {
                String tag = suggestion;
                if (suggestion.startsWith('新增')) {
                  tag = suggestion.replaceAll('新增 "', '').replaceAll('"', '');
                  ref.read(allTagsProvider.notifier).addTag(tag); // 加入全域 tag
                }
                if (!selectedTags.contains(tag)) {
                  ref.read(selectedTagsProvider.notifier).addTag(tag);
                }
              },
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.menu_book,
                      size: 40,
                      color: Color.fromARGB(255, 79, 94, 122),
                    ),
                    Text('閱讀目標'),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.auto_graph,
                      size: 40,
                      color: Color.fromARGB(255, 79, 94, 122),
                    ),
                    Text('閱讀進度'),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.bookmark,
                      size: 40,
                      color: Color.fromARGB(255, 79, 94, 122),
                    ),
                    Text('收藏書籍'),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),

          // 【卡片】書籍列表區
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Builder(
                builder: (context) {
                  if (books.isEmpty) {
                    return const Center(
                      child: Text(
                        '你的書櫃目前什麼都沒有哦！',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  if (filteredBooks.isEmpty) {
                    return const Center(
                      child: Text('無搜尋結果', style: TextStyle(fontSize: 18)),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      return BookCard(book: book);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // 新增書本懸浮紐 自動建立空資料
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 79, 94, 122),
        onPressed: () async {
          // 導航到編輯頁面
          navigateToEditPage(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class Match {
  final int start;
  final int end;
  Match(this.start, this.end);
}
