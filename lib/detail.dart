import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  Detail({super.key, required this.index, required this.list});
  List list;
  int index;
  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list[widget.index]['nama_barang']),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
              child: Column(
            children: <Widget>[
              Text(
                "Barang : ${widget.list[widget.index]['nama_barang']}",
                style: const TextStyle(fontSize: 18.0),
              ),
              Text(
                "stock : ${widget.list[widget.index]['jumlah_barang']}",
                style: const TextStyle(fontSize: 18.0),
              ),
              Row(
                children: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      onPressed: () {},
                      child: const Text("edit")),
                  const Padding(padding: EdgeInsets.all(90)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      onPressed: () {},
                      child: const Text("delete")),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
