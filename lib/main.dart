import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_example/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("shop");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

/// with provider path
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:todo_example/todo_model.dart';
//
// const String todoBoxName = "todo";
//
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   final document = await getApplicationDocumentsDirectory();
//   Hive.init(document.path);
//   Hive.registerAdapter(TodoModelAdapter());
//   await Hive.openBox<TodoModel>(todoBoxName);
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// enum TodoFilter {ALL, COMPLETED, INCOMPLETED}
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   late Box<TodoModel> todoBox;
//
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController detailController = TextEditingController();
//
//   TodoFilter filter = TodoFilter.ALL;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     todoBox = Hive.box<TodoModel>(todoBoxName);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Hive Todo"),
//         actions: <Widget>[
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               ///Todo : Take action accordingly
//               ///
//               if(value.compareTo("All") == 0){
//                 setState(() {
//                   filter = TodoFilter.ALL;
//                 });
//               }else if (value.compareTo("Compeleted") == 0){
//                 setState(() {
//                   filter = TodoFilter.COMPLETED;
//                 });
//               }else{
//                 setState(() {
//                   filter = TodoFilter.INCOMPLETED;
//                 });
//               }
//             },
//             itemBuilder: (BuildContext context) {
//               return ["All", "Compeleted", "Incompleted"].map((option) {
//                 return PopupMenuItem(
//                   value: option,
//                   child: Text(option),
//                 );
//               }).toList();
//             },
//           )
//         ],
//       ),
//
//       body: Column(
//         children: <Widget>[
//           ValueListenableBuilder(
//             valueListenable: todoBox.listenable(),
//
//             builder: (context, Box<TodoModel> todos, _){
//
//               List<int> keys;
//
//               if(filter == TodoFilter.ALL){
//                 keys = todos.keys.cast<int>().toList();
//               }else if(filter == TodoFilter.COMPLETED){
//                 keys = todos.keys.cast<int>().where((key) => todos.get(key)!.isCompleted).toList();
//               }else{
//                 keys = todos.keys.cast<int>().where((key) => !todos.get(key)!.isCompleted).toList();
//               }
//
//               return ListView.separated(
//                 itemBuilder:(_, index){
//
//                   final int key = keys[index];
//                   final TodoModel? todo = todos.get(key);
//
//
//                   return ListTile(
//                     title: Text(todo.title, style: TextStyle(fontSize: 24),),
//                     subtitle: Text(todo.detail,style: TextStyle(fontSize: 20)),
//                     leading: Text("$key"),
//                     trailing: Icon(Icons.check, color: todo.isCompleted ? Colors.green : Colors.red,),
//                     onTap: (){
//                       showDialog(
//                           context: context,
//                           child: Dialog(
//                               child: Container(
//                                 padding: EdgeInsets.all(16),
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//
//                                     FlatButton(
//                                       child: Text("Mark as completed"),
//                                       onPressed: () {
//                                         TodoModel mTodo = TodoModel(
//                                             title: todo.title,
//                                             detail: todo.detail,
//                                             isCompleted: true
//                                         );
//
//                                         todoBox.put(key, mTodo);
//
//                                         Navigator.pop(context);
//                                       },
//                                     )
//                                   ],
//                                 ),
//                               )
//                           )
//                       );
//                     },
//                   );
//                 },
//                 separatorBuilder: (_, index) => Divider(),
//                 itemCount: keys.length,
//                 shrinkWrap: true,
//               );
//             },
//           )
//         ],
//       ),
//
//       floatingActionButton: FloatingActionButton(
//         onPressed: (){
//           showDialog(
//               context: context,
//               child: Dialog(
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         TextField(
//                           decoration: InputDecoration(hintText: "Title"),
//                           controller: titleController,
//                         ),
//                         SizedBox(
//                           height: 8,
//                         ),
//                         TextField(
//                           decoration: InputDecoration(hintText: "Detail"),
//                           controller: detailController,
//                         ),
//                         SizedBox(
//                           height: 8,
//                         ),
//                         FlatButton(
//                           child: Text("Add Todo"),
//                           onPressed: () {
//                             ///Todo : Add Todo in hive
//                             final String title = titleController.text;
//                             final String detail = detailController.text;
//
//                             TodoModel todo = TodoModel(title: title, detail: detail, isCompleted: false);
//
//                             todoBox.add(todo);
//
//                             Navigator.pop(context);
//                           },
//                         )
//                       ],
//                     ),
//                   )
//               )
//           );
//         },
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

/// favourate
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
//
// const favoritesBox = 'favorite_books';
// const List<String> books = [
//   'Harry Potter',
//   'To Kill a Mockingbird',
//   'The Hunger Games',
//   'The Giver',
//   'Brave New World',
//   'Unwind',
//   'World War Z',
//   'The Lord of the Rings',
//   'The Hobbit',
//   'Moby Dick',
//   'War and Peace',
//   'Crime and Punishment',
//   'The Adventures of Huckleberry Finn',
//   'Catch-22',
//   'The Sound and the Fury',
//   'The Grapes of Wrath',
//   'Heart of Darkness',
// ];
//
// void main() async {
//   await Hive.initFlutter();
//   await Hive.openBox<String>(favoritesBox);
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late Box<String> favoriteBooksBox;
//
//   @override
//   void initState() {
//     super.initState();
//     favoriteBooksBox = Hive.box(favoritesBox);
//   }
//
//   Widget getIcon(int index) {
//     if (favoriteBooksBox.containsKey(index)) {
//       return Icon(Icons.favorite, color: Colors.red);
//     }
//     return Icon(Icons.favorite_border);
//   }
//
//   void onFavoritePress(int index) {
//     if (favoriteBooksBox.containsKey(index)) {
//       favoriteBooksBox.delete(index);
//       return;
//     }
//     favoriteBooksBox.put(index, books[index]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Favorite Books with Hive',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Favorite Books w/ Hive"),
//         ),
//         body: ValueListenableBuilder(
//           valueListenable: favoriteBooksBox.listenable(),
//           builder: (__, Box<String> box, _) {
//             return ListView.builder(
//               itemCount: books.length,
//               itemBuilder: (context, listIndex) {
//                 return ListTile(
//                   title: Text(books[listIndex]),
//                   trailing: IconButton(
//                     icon: getIcon(listIndex),
//                     onPressed: () => onFavoritePress(listIndex),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
