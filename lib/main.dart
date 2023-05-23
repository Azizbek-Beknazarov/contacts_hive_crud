import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_example/model/contact_model.dart';
import 'package:todo_example/pages/home_page.dart';

const String KEY_CONTACT = "KEY_CONTACT";

Future<void> main() async {
  //1 init qilinadi.
  await Hive.initFlutter();

  //2 adapter register qilinadi.
  Hive.registerAdapter(ContactModelAdapter());

  //3 model tipli box ochiladi key bilan.
  await Hive.openBox<ContactModel>(KEY_CONTACT);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Contacts',
      home: HomePage(),
    );
  }
}
