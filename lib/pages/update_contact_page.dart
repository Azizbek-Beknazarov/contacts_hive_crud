//contact update qilish
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_example/main.dart';
import 'package:todo_example/model/contact_model.dart';

class UpdateContact extends StatefulWidget {
  //bu validatsiya uchun
  final formKey = GlobalKey<FormState>();
  final int index;
  final ContactModel? currentContact;

  UpdateContact({
    super.key,
    required this.index,
    required this.currentContact,
  });

  @override
  _UpdateContactState createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  // mana shu o'zgaruvchilarga textfielddagi valuelar olinadi.
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  @override
  void initState() {
    super.initState();

    name.text = widget.currentContact!.name;
    phoneNumber.text = widget.currentContact!.phoneNumber;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  //mana shu yerda boxdagi  info update qilinadi.
  void onUpdate(int index) {
    if (widget.formKey.currentState!.validate()) {
      //4 bizga kerakli box ochib olinadi.
      Box<ContactModel> contactsBox = Hive.box<ContactModel>(KEY_CONTACT);

      //siz bosgan itemni indexi boyicha update qilinadi.
      contactsBox.putAt(
        index,
        ContactModel(
          phoneNumber: phoneNumber.text,
          name: name.text,
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
                    controller: name,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    controller: phoneNumber,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone",
                    ),
                    onChanged: (value) {},
                  ),
                  TextButton(
                    child: const Text("Update"),
                    onPressed: () => onUpdate(widget.index),
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
