import 'package:flutter/material.dart';
import 'package:flutter_application_3/lihat_stok_barang.dart';

class Lembarstokbarang extends StatefulWidget {
  const Lembarstokbarang({super.key});

  @override
  State<Lembarstokbarang> createState() => _Lembarstokbarang();
}

class _Lembarstokbarang extends State<Lembarstokbarang> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Stock barang"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: 200,
                height: 100,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                  side: const BorderSide(color: Colors.white, width: 2),
                  shape: const StadiumBorder(),
                ),
                //Lembarpengaduan
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const stokview();
                  }));
                },
                child: const Text("Stock View"),
              ),
              Container(
                alignment: Alignment.center,
                width: 200,
                height: 100,
              ),
              Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      onPressed: () {},
                      child: const Text("tambah")),
                  Container(
                    alignment: Alignment.center,
                    width: 125,
                  ),
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
                      child: const Text("kurang")),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
