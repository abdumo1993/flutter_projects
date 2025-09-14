import 'package:flutter/material.dart';
import '../models/list_items.dart';
import '../models/shopping_list.dart';
import '../util/dbhelper.dart';
import 'list_item_dialog.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  const ItemsScreen(this.shoppingList, {super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState(this.shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  late DbHelper helper;
  late List<ListItem> items;

  final ShoppingList shoppingList;

  _ItemsScreenState(this.shoppingList);

  Future showData(int idList) async {
    await helper.openDb();
    items = await helper.getItems(idList);
    setState(() {
      items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    showData(this.shoppingList.id!);
    ListItemDialog dialog = ListItemDialog();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => dialog.buildAlert(
                context, ListItem(0, shoppingList.id, '', '', ''), true),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
      appBar: AppBar(
        title: Text(shoppingList.name!),
      ),
      body: ListView.builder(
        itemCount: (items != null) ? items.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(items[index].name!),
 onDismissed: (direction) {
 String strName = items[index].name!;
 helper.deleteItem(items[index]);
 setState(() {
 items.removeAt(index);
 });
 ScaffoldMessenger.of(context)
 .showSnackBar(SnackBar(content: Text("$strName deleted")));
 },

            child: ListTile(
              title: Text(items[index].name!),
              subtitle: Text(
                  'Quantity: ${items[index].quantity} - Note:${items[index].note}'),
              onTap: () {},
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          dialog.buildAlert(context, items[index], false));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
