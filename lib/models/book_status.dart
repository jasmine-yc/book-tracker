import 'package:hive/hive.dart';

part 'book_status.g.dart';

@HiveType(typeId: 1)
enum BookStatus{
  @HiveField(0)
  unRead,

  @HiveField(1)
  reading,

  @HiveField(2)
  finished,
}