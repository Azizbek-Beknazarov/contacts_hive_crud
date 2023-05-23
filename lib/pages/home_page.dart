import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_example/pages/add_contact_page.dart';

import '../main.dart';
import '../model/contact_model.dart';
import 'update_contact_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),

      // bu yerda infolar ko'rsatilinadi.
      body: ValueListenableBuilder(
        //6 bu yerda boxdan kelayotgan qiymatlar tinglab turiladi. yani agar yangi info qo'shilsa darhol aks ettiriladi.
        valueListenable: Hive.box<ContactModel>(KEY_CONTACT).listenable(),

        //shu tartibda builder yaratib olinadi. box.values orqali box ichidagi infolarga murajaat qilinadi.
        builder: (context, Box<ContactModel> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text("No contacts"),
            );
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              //7 Model tipli o'zgaruvchi ochilib aynan index orqali boxdan info olinadi.
              ContactModel? currentContact = box.getAt(index);
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  //uzoq vaqt bosib turilganda dialog chiqadi
                  onLongPress: () {
                    showDialog(
                      builder: (_) {
                        return AlertDialog(
                          content: Text(
                            "Do you want to delete ${currentContact?.name}?",
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text("No"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            ElevatedButton(
                              child: const Text("Yes"),
                              onPressed: () async {
                                // yes bo'lganda index orqali info delete qilinadi.
                                Navigator.of(context).pop();
                                await box.deleteAt(index);
                              },
                            ),
                          ],
                        );
                      },
                      context: context,
                      barrierDismissible: true,
                    );
                  },
                  onDoubleTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => UpdateContact(
                                  index: index,
                                  currentContact: currentContact,
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //bu yerda infolar ko'rsatilinadi.
                        const SizedBox(height: 5),
                        Text("Name: ${currentContact!.name}"),
                        const SizedBox(height: 5),
                        Text("Tel: ${currentContact.phoneNumber}"),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddContact()));
            },
          );
        },
      ),
    );
  }
}
