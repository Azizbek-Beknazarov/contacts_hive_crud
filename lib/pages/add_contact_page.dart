//contact qo'shish
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_example/main.dart';
import 'package:todo_example/model/contact_model.dart';

class AddContact extends StatefulWidget {
  //bu validatsiya uchun
  final formKey = GlobalKey<FormState>();

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  // mana shu o'zgaruvchilarga textfielddagi valuelar olinadi.
  String? name;
  String? phoneNumber;

  //mana shu yerda boxga info kiritiladi.
  void onFormSubmit() {
    if (widget.formKey.currentState!.validate()) {
      //4 bizga kerakli box ochib olinadi.
      Box<ContactModel> contactsBox = Hive.box<ContactModel>(KEY_CONTACT);

      //5 add metodi orqali info qo'shiladi avvaldan yaratilgan model orqali.
      // add orqali qo'shilsa ketma-ket boxda saqlanib boraveradi. put metodi orqali qo'shilsa key bilan eng oxirgi info
      // saqlanadi, avvalgilari o'chib ketadi.
      contactsBox.add(
        ContactModel(
          phoneNumber: phoneNumber!,
          name: name!,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  //mana shu yerda boxdagi  info update qilinadi.
  void onUpdate(int index) {
    if (widget.formKey.currentState!.validate()) {
      //4 bizga kerakli box ochib olinadi.
      Box<ContactModel> contactsBox = Hive.box<ContactModel>(KEY_CONTACT);

      //5 add metodi orqali info qo'shiladi avvaldan yaratilgan model orqali.
      // add orqali qo'shilsa ketma-ket boxda saqlanib boraveradi. put metodi orqali qo'shilsa key bilan eng oxirgi info
      // saqlanadi, avvalgilari o'chib ketadi.
      contactsBox.putAt(
        index,
        ContactModel(
          phoneNumber: phoneNumber!,
          name: name!,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: widget.formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    initialValue: "",
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    initialValue: "",
                    decoration: const InputDecoration(
                      labelText: "Phone",
                    ),
                    onChanged: (value) {
                      setState(() {
                        phoneNumber = value;
                      });
                    },
                  ),
                  TextButton(
                    child: const Text("Submit"),
                    onPressed: onFormSubmit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}