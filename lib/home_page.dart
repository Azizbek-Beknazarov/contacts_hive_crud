import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _items = [];
  final _shop = Hive.box("shop");
  final nameC = TextEditingController();

  // final quantityC = TextEditingController();
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  @override
  Widget build(BuildContext context,) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ertangi vazifalar"),
      ),
      body: StreamBuilder(
        stream: null,
        builder: (context, snapshot) {
          return ListView.builder(
            itemBuilder: (_, index) {
              final currentItem = _items[index];
              return ListTile(
                onTap: () {
                  _showForm(context, currentItem["key"]);
                },
                title: Text(currentItem["name"]),
                contentPadding: EdgeInsets.zero,
                trailing: IconButton(
                  onPressed: () => _deleteItem(currentItem["key"]),
                  icon: Image.asset("assets/png/subway.png"),
                ),
              );
            },
            itemCount: _items.length,
          );

        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameC,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      )),
                      labelText: "Name",
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _showForm(
                    context,
                    null,
                  ),
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: const BoxDecoration(
                        color: Color(0xff333333),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        )),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showForm(BuildContext ctx, int? itemKey) async {
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element["key"] == itemKey);
      nameC.text = existingItem["name"];
      // quantityC.text = existingItem["quantity"];
    }

    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 0,
      context: ctx,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(
                hintText: 'name',
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (itemKey == null) {
                    _createItem({
                      "name": nameC.text,
                    });
                  }
                  if (itemKey != null) {
                    _updateItem(
                      itemKey,
                      {
                        "name": nameC.text,
                      },
                    );
                  }

                  nameC.clear();
                  Navigator.pop(context);
                },
                child:
                    itemKey == null ? const Text("save") : const Text("update"))
          ],
        ),
      ),
    );
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _shop.add(newItem);
    print("----> amount shop lenght: ${_shop.length}");
    _refreshItems();
  }

  Future<void> _updateItem(int itemKey, Map<String, dynamic> oldItem) async {
    await _shop.put(itemKey, oldItem);
    print("----> amount shop lenght: ${_shop.length}");
    _refreshItems();
  }

  Future<void> _deleteItem(int itemKey) async {
    await _shop.delete(itemKey);
    print("----> amount shop lenght: ${_shop.length}");
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("item deleted!!!")));
    _refreshItems();
  }

  void _refreshItems() {
    final data = _shop.keys.map((key) {
      final item = _shop.get(key);
      return {
        "key": key,
        "name": item["name"],
        // "quantity": item["quantity"],
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
      print("----> _items length: ${_items.length}");
    });
  }
}
