import 'package:hive/hive.dart';
part 'undertone_model.g.dart';
@HiveType(typeId: 0)
class UndertoneModel extends HiveObject{
  @HiveField(0)
  final String season;

  UndertoneModel({required this.season});
}