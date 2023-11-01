import 'package:hive/hive.dart';

part 'diary.g.dart';

@HiveType(typeId: 0)
class Diary {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int mood;

  @HiveField(2)
  final String contentJson;

  @HiveField(3)
  final String contentPlainText;

  @HiveField(4)
  final List<String> imgPaths;

  Diary(
      {required this.date,
      required this.mood,
      this.contentJson = '',
      this.contentPlainText = '',
      List<String>? imgPaths})
      : imgPaths = imgPaths ?? [];
}
