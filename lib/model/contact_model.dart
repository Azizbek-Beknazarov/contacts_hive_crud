import 'package:hive/hive.dart';

part "contact_model.g.dart";

@HiveType(typeId: 0)
class ContactModel {
  @HiveField(0)
  String name;
  @HiveField(1)
  String phoneNumber;

  ContactModel({
    required this.name,
    required this.phoneNumber,
  });
}
