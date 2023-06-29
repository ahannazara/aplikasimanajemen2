import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Lembarpengaduan extends StatefulWidget {
  const Lembarpengaduan({super.key});

  @override
  State<Lembarpengaduan> createState() => _LembarpengaduanState();
}

class _LembarpengaduanState extends State<Lembarpengaduan> {
  TextEditingController txtwaktu = TextEditingController();

  TextEditingController txtlokasi = TextEditingController();

  TextEditingController txtkeluhan = TextEditingController();

  TextEditingController txtperbaikan = TextEditingController();

  DateTime selectDate = DateTime.now();

  Future<void> kirimdata(
      String waktu, String lokasi, String keluhan, String perbaikan) async {
    try {
      var link =
          Uri.parse("https://keluhan1flutter.000webhostapp.com/laporan.php");
      print(waktu);
      print(lokasi);
      print(keluhan);
      print(perbaikan);
      await http.post(
        link,
        body: {
          'tanggal': waktu,
          'lokasi': lokasi,
          'keluhan': keluhan,
          'perbaikan': perbaikan,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  File? image;

  Future getImage() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final ImagePicker picker = ImagePicker();

    final XFile? imagePicked =
        await picker.pickImage(source: ImageSource.camera);

    image = File(imagePicked!.path);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Halaman Pengaduan"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text("Isi Data Pengaduan"), //coloumn 1 "JUDUL"
            //tombol input tanggal

            Padding(
              //coloumn 2 "input nama anda"
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: txtwaktu,
                decoration: InputDecoration(
                    label: const Text("input waktu"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),
            Column(
              children: [
                OutlinedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: selectDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      ).then((value) {
                        setState(() {
                          selectDate = value!;
                        });
                        //return print(value);
                      });
                      txtwaktu.text = selectDate.toString();
                    },
                    child: const Text("pilih tanggal")),
              ],
            ),

            Padding(
              //coloumn 3 "input nama lokasi"
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: txtlokasi,
                decoration: InputDecoration(
                    hintText: 'Nama lokasi',
                    label: const Text("input lokasi"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),

            Padding(
              //coloumn 3 "input kondisi fasilitas"
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: txtkeluhan,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 10),
                    hintText: 'Temuan',
                    label: const Text("Input Temuan"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),

            Padding(
              //coloumn 4 "input kondisi perbaikan"
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: txtperbaikan,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 10),
                    hintText: 'Perbaikan',
                    label: const Text("Input Perbaikan"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),

            //button gambar

            image != null
                ? SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(
                      image!,
                      fit: BoxFit.cover,
                    ))
                : Container(),

            ElevatedButton(
                onPressed: () async {
                  await getImage();
                },
                child: const Text("tambah gambar")),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //button 1
                ElevatedButton(
                    onPressed: () {
                      kirimdata(
                          txtwaktu.text.toString(),
                          txtlokasi.text.toString(),
                          txtkeluhan.text.toString(),
                          txtperbaikan.text.toString());
                      Navigator.pop(context);
                    },
                    child: const Text("adukan")),

                //button 2
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Lembarpengaduan()));
                  },
                  child: const Text("kembali"),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
