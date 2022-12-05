// ignore_for_file: deprecated_member_use

import 'package:demo_project/provider/whishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WhishlistPage extends StatefulWidget {
  const WhishlistPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WhishlistPage();
  }
}

class _WhishlistPage extends State<WhishlistPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final whishlistProvider = Provider.of<WhishlistProvider>(context);

    Future<void> showDialogues(
      BuildContext context,
    ) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Confirm Delete"),
              content: const Text(
                  "All the items will be delete! Do you want to continue?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No")),
                TextButton(
                  onPressed: () {
                    whishlistProvider.clearWish();
                    Navigator.pop(context);
                  },
                  child: const Text("Yes"),
                ),
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wishlists",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () async {
                  await showDialogues(
                    context,
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 30,
                )),
          )
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        
          itemCount: whishlistProvider.whishlist.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 1,
              child: ListTile(
                onTap: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>));
                },
                tileColor: Colors.grey[100],
                leading: Image(
                  image: NetworkImage(
                      whishlistProvider.whishlist.values.toList()[index].image),
                  width: 100,
                ),
                title:
                    Text(whishlistProvider.whishlist.values.toList()[index].id),
                subtitle: Text(
                  "Birr ${whishlistProvider.whishlist.values.toList()[index].price.toString()}",
                ),
                trailing: IconButton(
                  onPressed: () {
                    whishlistProvider.removeItem(
                        whishlistProvider.whishlist.values.toList()[index].id);
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
