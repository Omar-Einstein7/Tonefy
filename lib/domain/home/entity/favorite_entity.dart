
import 'package:hive/hive.dart';

part 'favorite_entity.g.dart';

@HiveType(typeId: 1)
class Favorite extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String artist;

  @HiveField(3)
  late String filePath;
}
