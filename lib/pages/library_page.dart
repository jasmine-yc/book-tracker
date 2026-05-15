// packages
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
      backgroundColor: Colors.grey[50], // 淺灰
      appBar: AppBar(
        leading: Image.asset("assets/icon/app_icon.jpg"),
        // backgroundColor: Color.fromARGB(255, 176, 196, 222), // LightSteelBlue
        // backgroundColor: Color.fromARGB(255, 61, 93, 133),
        backgroundColor: Color.fromARGB(255, 150, 123, 182), // 紫羅蘭色
        centerTitle: true,
        title: const Text(
          'BOOK TRACKER',
          style: TextStyle(color: Colors.white, letterSpacing: 4),
        ),
      ),
      body: Column(
        children: [
          // 搜尋框
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
            child: TypeAheadField<String>(
              controller: searchController,
              suggestionsCallback: (pattern) {
                final suggestions = <String>{};
                // 書名 & 作者
                for (var book in books) {
                  if (book.title.toLowerCase().contains(
                    pattern.toLowerCase(),
                  )) {
                    suggestions.add(book.title);
                  }
                  //
                  if (book.author.toLowerCase().contains(
                    pattern.toLowerCase(),
                  )) {
                    suggestions.add(book.author);
                  }
                }
                return suggestions.take(10).toList();
              },

              builder: (context, controller, focusNode) {
                return TextField(
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value
                        .trim()
                        .toLowerCase();
                  },
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search by book title or author',
                    // suffixText: '<10字',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search_outlined),
                    iconColor: Colors.black,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                    ),
                    // 邊框
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 120, 133, 164),
                      ),
                    ),
                  ),
                );
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  leading: Icon(Icons.search),
                  title: Text(suggestion),
                );
              },
              onSelected: (suggestion) {
                searchController.text = suggestion;
                ref.read(searchQueryProvider.notifier).state = suggestion
                    .toLowerCase();
              },
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

          // 選擇排列方式
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setModalState) {
                            return ListView(
                              children: allTags.map((tag) {
                                return CheckboxListTile(
                                  title: Text(tag),
                                  value: selectedTags.contains(tag),
                                  onChanged: (selected) {
                                    setModalState(() {
                                      if (selected == true) {
                                        selectedTags.add(tag);
                                      } else {
                                        selectedTags.remove(tag);
                                      }
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                );
                              }).toList(),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Text('標籤篩選'),
                ),
              ],
            ),
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
        backgroundColor: const Color.fromARGB(255, 150, 123, 182),
        onPressed: () async {
          // 導航到編輯頁面
          navigateToEditPage(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
