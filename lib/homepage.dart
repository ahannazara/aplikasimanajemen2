import 'package:flutter/material.dart';
import 'package:flutter_application_3/lembar_pengaduan.dart';
import 'package:flutter_application_3/lembar_stok_barang.dart';

class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Page1(),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: 200,
            height: 200,
          ),
          Column(
            children: [
              //button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 50),
                    side: const BorderSide(color: Colors.white, width: 2),
                    shape: const StadiumBorder(),
                  ),
                  //Lembarpengaduan
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return const Lembarpengaduan();
                  })),
                  child: const Text("Lapor kerusakan",
                      textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
          ),
          Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      side: const BorderSide(color: Colors.blue, width: 2),
                      shape: const StadiumBorder(),
                    ),
                    //Stock barang
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const Lembarstokbarang();
                      }));
                    },
                    child: const Text("   Stok \n Barang",
                        style: TextStyle(color: Colors.blue)),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 53,
                    height: 50,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      side: const BorderSide(color: Colors.white, width: 2),
                      shape: const StadiumBorder(),
                    ),
                    //Lembarpengaduan
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const Lembarpengaduan();
                      }));
                    },
                    child: const Text("Laporan \n kerja",
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                width: 50,
                height: 50,
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
