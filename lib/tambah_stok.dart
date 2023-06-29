import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Tambahstokbarang extends StatefulWidget {
  const Tambahstokbarang({super.key});

  @override
  State<Tambahstokbarang> createState() => _Tambahstokbarang();
}

class _Tambahstokbarang extends State<Tambahstokbarang> {
  TextEditingController controllerName = TextEditingController();

  TextEditingController controllerStock = TextEditingController();

  Future<void> addData(String item, String stok) async {
    try {
      var link =
          Uri.parse("https://keluhan1flutter.000webhostapp.com/addbarang.php");
      print(item);
      print(stok);
      print(link);
      await http.post(
        link,
        body: {
          'itemname': item,
          'stock': stok,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADD DATA"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                TextField(
                  controller: controllerName,
                  decoration: const InputDecoration(
                      hintText: "Item Name", labelText: "Item Name"),
                ),
                TextField(
                  controller: controllerStock,
                  decoration: const InputDecoration(
                      hintText: "Stock", labelText: "Stock"),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                ElevatedButton(
                  child: const Text("ADD DATA"),
                  onPressed: () {
                    addData(controllerName.text.toString(),
                        controllerStock.text.toString());
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
