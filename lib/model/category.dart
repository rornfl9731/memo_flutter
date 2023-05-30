import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Memo extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String content;

  @HiveField(2)
  late DateTime dateTime;

  @HiveField(3)
  late Category? category; // 카테고리를 나타내는 필드


  Memo({required this.title, required this.content, required this.dateTime, this.category});
}

@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late List<Memo> memos;

  Category({required this.name, required this.memos});
}