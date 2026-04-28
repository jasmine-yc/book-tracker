import 'package:hive/hive.dart';
import './book_status.dart';
part 'book_data.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {

  @HiveField(0)
  String title; // 書名-必

  @HiveField(1)
  String author; // 作者-必

  @HiveField(2)
  String? category; // 類型

  @HiveField(3)
  List<String>? tags; // 標籤

  @HiveField(4)
  String? coverImagePath; // 封面

  @HiveField(5)
  BookStatus status; // 閱讀狀態-必

  @HiveField(6)
  String note; // 筆記

  @HiveField(7)
  int? rate; // 評分 1-5

  @HiveField(8)
  DateTime saveDate; // 儲存時間

  @HiveField(9)
  DateTime? readingDate; // 閱讀日期

  Book({
    required this.title,
    required this.author,
    this.category,
    List<String>? tags,
    this.coverImagePath,
    this.status= BookStatus.unRead,
    this.note= "",
    this.rate,
    DateTime? saveDate,
    this.readingDate,
  }) : tags= tags?? [],
        saveDate= saveDate?? DateTime.now();
  Book copyWith({
    String? title,
    String? author,
    String? category,
    List<String>? tags,
    String? coverImagePath,
    BookStatus? status,
    String? note,
    int? rate,
    DateTime? readingDate,
  }) {
    return Book(
      title: title ?? this.title,
      author: author ?? this.author,
      category: category ?? this.category,
      tags: tags ?? List.from(this.tags as Iterable<dynamic>),
      coverImagePath: coverImagePath ?? this.coverImagePath,
      status: status ?? this.status,
      note: note ?? this.note,
      rate: rate ?? this.rate,
      saveDate: saveDate,           // 保存時間不變
      readingDate: readingDate ?? this.readingDate,
    );
  }

  bool get isValid =>title.trim().isNotEmpty && author.trim().isNotEmpty; // 儲存資料檢查
  bool hasTag(String tag) => tags!.contains(tag); // 是否有某個標籤
}