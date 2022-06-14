import 'package:hive/hive.dart';
part 'monster.g.dart';

@HiveType(typeId: 1)
class Monster extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  int level;

  Monster(this.name, this.level);
}
