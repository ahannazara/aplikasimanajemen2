// ignore_for_file: prefer_const_constructors_in_immutables, unnecessary_new, must_be_immutable, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/detail.dart';
import 'package:flutter_application_3/tambah_stok.dart';

import 'package:http/http.dart' as http;

import 'dart:async';

// ignore: camel_case_types
class stokview extends StatefulWidget {
  const stokview({super.key});

  @override
  State<stokview> createState() => _stokview();
}

// ignore: camel_case_types
class _stokview extends State<stokview> {
  Future<List> getData() async {
    var hasilget = await http
        .get(Uri.parse("https://keluhan1flutter.000webhostapp.com/get.php"));

    return json.decode(hasilget.body);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("STOK BARANG"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const Tambahstokbarang(),
          )),
        ),
        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? ItemList(
                      list: snapshot.data!,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;

  ItemList({super.key, required this.list});

  List<Map<String, dynamic>> items = [];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (list) {},
              decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list == null ? 0 : list.length,
              itemBuilder: (context, i) {
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Detail(
                              list: list,
                              index: i,
                            ))),
                    child: Card(
                      child: ListTile(
                        title: Text(list[i]['nama_barang']),
                        leading: const Icon(Icons.widgets),
                        subtitle: Text("Stock : ${list[i]['jumlah_barang']}"),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
