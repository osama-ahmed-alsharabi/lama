import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'undertone_model.g.dart';
@HiveType(typeId: 0)
class UndertoneModel extends HiveObject{
  @HiveField(0)
  final String season;
  @HiveField(1)
  final Uint8List? image;

  UndertoneModel({required this.season , this.image});
}