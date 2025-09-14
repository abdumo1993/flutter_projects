import 'package:flutter/material.dart';
import './util/dbhelper.dart';
import './models/list_items.dart';
import './models/shopping_list.dart';
import './ui/items_screen.dart';
import './ui/shopping_list_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Shoppping List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ShList());
  }
}

class ShList extends StatefulWidget {
  const ShList({super.key});

  @override
  State<ShList> createState() => _ShListState();
}

// class _ShListState extends State<ShList> {
//   DbHelper helper = DbHelper();
//      final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


//   late List<ShoppingList> shoppingList;

//   ShoppingListDialog dialog = ShoppingListDialog();
//   @override
//   void initState() {
//     dialog = ShoppingListDialog();
//     super.initState();
//   }

//   Future showData() async {
//     await helper.openDb();
//     shoppingList = await helper.getLists();
//     setState(() {
//       shoppingList = shoppingList;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     showData();
//     return Scaffold(
//        key: _scaffoldKey,
//       appBar: AppBar(
//         title: Text("Shopping List"),
//       ),
//       body: ListView.builder(
//           itemCount: (shoppingList == null) ? 0 : shoppingList.length,
//           itemBuilder: (BuildContext context, int index) {
//             return Dismissible(
//               key: Key(shoppingList[index].name!),
//  onDismissed: (direction) {
//  String strName = shoppingList[index].name!;
//  helper.deleteList(shoppingList[index]);
// setState(() {
//  shoppingList.removeAt(index);
//  });
//  Scaffold.of(context).showSnackBar(SnackBar(content: Text("$strName deleted")));
//  },
//               child: ListTile(
//                 title: Text(shoppingList[index].name!),
//                 leading: CircleAvatar(
//                   child: Text(
//                     shoppingList[index].priority!.toString(),
//                   ),
//                 ),
//                 trailing: IconButton(
//                   icon: Icon(Icons.edit),
//                   onPressed: () {
//                     showDialog(
//                         context: context,
//                         builder: (BuildContext context) => dialog.buildDialog(
//                             context, shoppingList[index], false));
//                   },
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => ItemsScreen(shoppingList[index])),
//                   );
//                 },
//               ),
//             );
//           }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) =>
//                 dialog.buildDialog(context, ShoppingList(0, '', 0), true),
//           );
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.pink,
//       ),
//     );
//   }
// }
class _ShListState extends State<ShList> {
  DbHelper helper = DbHelper();
  List<ShoppingList> shoppingList = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ShoppingListDialog dialog = ShoppingListDialog();

  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }

  Future<void> showData() async {
    await helper.openDb();
    shoppingList = await helper.getLists();
    setState(() {
      shoppingList = shoppingList;
    });
  }

  void _deleteList(int index) async {
    String strName = shoppingList[index].name!;
    await helper.deleteList(shoppingList[index]);
    setState(() {
      shoppingList.removeAt(index);
    });
      ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text("$strName deleted"),
     ),
   );

    
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Shopping List"),
      ),
      body: ListView.builder(
          itemCount: shoppingList.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(shoppingList[index].name!),
              onDismissed: (direction) {
                _deleteList(index);
              },
              child: ListTile(
                title: Text(shoppingList[index].name!),
                leading: CircleAvatar(
                  child: Text(
                    shoppingList[index].priority!.toString(),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => dialog.buildDialog(
                            context, shoppingList[index], false));
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ItemsScreen(shoppingList[index])),
                  );
                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                dialog.buildDialog(context, ShoppingList(0, '', 0), true),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
