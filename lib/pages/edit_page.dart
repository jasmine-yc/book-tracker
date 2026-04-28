// BookEditPage(帶 Tab，負責 Tab 切換 & 接收書籍資料)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// providers
import '../providers/selected_tags_provider.dart';
import '../providers/all_tags_provider.dart';
// models
import '../models/book_data.dart';
import '../models/book_status.dart';
// pages

class EditPage extends ConsumerStatefulWidget {
  final Book? book; // 編輯書籍（null = 新增）
  final dynamic bookKey;
  const EditPage({super.key, this.book, this.bookKey});

  @override
  ConsumerState<EditPage> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>(); //?
  //?
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController noteController;
  late TextEditingController tagController;

  late TabController _tabController;
  late BookStatus _status;
  int rate = 0;

  @override
  void initState() {
    super.initState();

    rate = widget.book?.rate ?? 0;
    // 初始化 controller
    titleController = TextEditingController(text: widget.book?.title ?? '');
    authorController = TextEditingController(text: widget.book?.author ?? '');
    noteController = TextEditingController(text: widget.book?.note ?? '');
    tagController = TextEditingController();

    _tabController = TabController(length: 2, vsync: this);

    _status = widget.book?.status ?? BookStatus.unRead;

    // 初始化 tags (編輯)
    Future.microtask(() {
      if (widget.book != null) {
        ref
            .read(selectedTagsProvider.notifier)
            .setTags(widget.book!.tags ?? []);
      }else{
        ref
          .read(selectedTagsProvider.notifier)
          .setTags([]);
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    noteController.dispose();
    tagController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final text = tag.trim();
    if (text.isEmpty) return;

    final selectedNotifier = ref.read(selectedTagsProvider.notifier);
    final selectedTags = ref.read(selectedTagsProvider);
    final allTagsNotifier= ref.read(allTagsProvider.notifier);

    if (!selectedTags.contains(text)) {
      selectedNotifier.addTag(text);
    }

    allTagsNotifier.addTag(text);
    tagController.clear();
  }

  void _removeTag(String tag) {
    ref.read(selectedTagsProvider.notifier).removeTag(tag);
  }

  // 儲存書籍並回傳結果
  Future<void> saveBook() async {
    print("🔥 saveBook 有被呼叫");
    // 收起鍵盤
    FocusScope.of(context).unfocus();
    final tags = ref.read(selectedTagsProvider);
    // 驗證
    if (_formKey.currentState!.validate()) {
      // 新增
      if (widget.book == null) {
        final newBook = Book(
          title: titleController.text.trim(),
          author: authorController.text.trim(),
          note: noteController.text.trim(),
          status: _status,
          tags: tags,
          rate: rate,
          saveDate: DateTime.now(),
        );

        if (!context.mounted) return;
        // 回傳給上一頁
        Navigator.of(context).pop({'book': newBook, 'isNew': true});
      } else if (widget.bookKey != null) {
        // edit
        print("bookKey: ${widget.bookKey}");
        // 編輯書籍：直接改 widget.book
        widget.book!.title = titleController.text.trim();
        widget.book!.author = authorController.text.trim();
        widget.book!.note = noteController.text.trim();
        widget.book!.status = _status;
        widget.book!.tags = tags;
        widget.book!.rate = rate;

        await widget.book!.save();

        if (!context.mounted) return;

        Navigator.of(context).pop({'book': widget.book!, 'isNew': false});
      }
    } else {
      // 顯示錯誤
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("請正確填寫資料")));
      return;
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    final selectedTags = ref.watch(selectedTagsProvider);
    final allTags = ref.watch(allTagsProvider);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 41, 43, 42),
        title: Text(
          widget.book == null ? "新增書籍" : widget.book!.title,
          style: TextStyle(color: Colors.white54),
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.white38,
          labelColor: Colors.grey[100],
          indicatorColor: Colors.grey[100],
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.bookmark), text: 'INFO'),
            Tab(icon: Icon(Icons.notes), text: 'NOTE'),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            // INFO TAB
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.title),
                        hintText: "書名",
                        border: UnderlineInputBorder(),
                      ),
                      //maxLength: 20,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "書名不可空白";
                        }
                        if (value.trim().length > 20) {
                          return "請勿填入超過 20 字";
                        }
                        return null;
                      },
                    ),
                    //SizedBox(height: 8),
                    TextFormField(
                      controller: authorController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.portrait),
                        hintText: "作者",
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "作者不可空白";
                        }
                        if (value.trim().length > 20) {
                          return "請勿填入超過 20 字";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    Wrap(
                      spacing: 8,
                      children: [
                        Text('閱讀狀態 (預設未讀)', style: TextStyle(fontSize: 16.0)),
                        ChoiceChip(
                          label: Text('未讀'),
                          selected: _status == BookStatus.unRead,
                          onSelected: (_) {
                            setState(() {
                              _status = BookStatus.unRead;
                            });
                          },
                        ),
                        ChoiceChip(
                          label: Text('閱讀中'),
                          selected: _status == BookStatus.reading,
                          onSelected: (_) {
                            setState(() {
                              _status = BookStatus.reading;
                            });
                          },
                        ),
                        ChoiceChip(
                          label: Text('完讀'),
                          selected: _status == BookStatus.finished,
                          onSelected: (_) {
                            setState(() {
                              _status = BookStatus.finished;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // TAG UI
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        final query = textEditingValue.text.trim();
                        final options = allTags
                            .where(
                              (tag) =>
                                  !selectedTags.contains(tag) &&
                                  tag.toLowerCase().contains(
                                    query.toLowerCase(),
                                  ),
                            )
                            .toList();
                        if (query.isNotEmpty &&
                            !options.contains(query) &&
                            !selectedTags.contains(query)) {
                          options.insert(0, '新增： 「$query」');
                        }

                        return options;
                      },
                      onSelected: (value) {
                        final tag = value
                            .replaceFirst('新增 "', '')
                            .replaceFirst('"', '');
                        _addTag(tag);
                      },
                      fieldViewBuilder: (context, controller, focusNode, _) {
                        tagController = controller;

                        return Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            // 已選標籤
                            ...selectedTags.map(
                              (tag) => Chip(
                                key: ValueKey(tag),
                                label: Text(tag),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () => _removeTag(tag),
                              ),
                            ),
                            // 輸入框
                            SizedBox(
                              width: 120,
                              child: IntrinsicWidth(
                                child: TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    border: UnderlineInputBorder(),
                                    hintText: '輸入標籤',
                                  ),
                                  onSubmitted: (value) => _addTag(value),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 12),
                    Container(  
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white54,
                      ),
                      child: Wrap(
                        spacing: 5,
                        children: List.generate(5, (index) {
                          return IconButton(
                            padding: EdgeInsets.all(1),
                            constraints: BoxConstraints(),
                            icon: Icon(
                              index < rate ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              setState(() {
                                rate = index + 1;
                              });
                            },
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // NOTE TAB
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: noteController,
                decoration: const InputDecoration(
                  hintText: "筆記",
                  border: OutlineInputBorder(),
                ),
                textAlignVertical: TextAlignVertical.top,
                expands: true,
                maxLines: null,
              ),
            ),
          ],
        ),

        // TAB 1
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 218, 235, 222),
        onPressed: () {
          saveBook();
          print('save button pressed');
        },
        child: const Icon(Icons.save, color: Color.fromARGB(255, 96, 132, 98),),
      ),
    );
  }
}
