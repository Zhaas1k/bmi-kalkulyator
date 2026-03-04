import 'package:flutter/material.dart';

void main() {
  runApp(const DeneSalmaGyApp());
}

class DeneSalmaGyApp extends StatelessWidget {
  const DeneSalmaGyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BMI Қосымшасы",
      theme: ThemeData(
        fontFamily: 'Arial',
      ),
      home: const BMIPage(),
    );
  }
}

class BMIPage extends StatefulWidget {
  const BMIPage({super.key});

  @override
  State<BMIPage> createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  final TextEditingController boyController = TextEditingController();
  final TextEditingController salmaqController = TextEditingController();

  String natizhe = "";
  String kategoriya = "";
  Color kategoriyaTusi = Colors.black;

  void esepteu() {
    double? boy = double.tryParse(boyController.text);
    double? salmaq = double.tryParse(salmaqController.text);

    if (boy == null || salmaq == null || boy <= 0 || salmaq <= 0) {
      setState(() {
        natizhe = "Қате мән!";
        kategoriya = "";
      });
      return;
    }

    double boyMeter = boy / 100;
    double bmi = salmaq / (boyMeter * boyMeter);

    String kat;
    Color tus;

    if (bmi < 18.5) {
      kat = "Салмақ жеткіліксіз";
      tus = Colors.blue;
    } else if (bmi < 25) {
      kat = "Қалыпты салмақ";
      tus = Colors.green;
    } else if (bmi < 30) {
      kat = "Артық салмақ";
      tus = Colors.orange;
    } else {
      kat = "Семіздік";
      tus = Colors.red;
    }

    setState(() {
      natizhe = bmi.toStringAsFixed(2);
      kategoriya = kat;
      kategoriyaTusi = tus;
    });
  }

  void tazalau() {
    setState(() {
      boyController.clear();
      salmaqController.clear();
      natizhe = "";
      kategoriya = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF43CEA2), Color(0xFF185A9D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Дене салмағы индексі",
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: boyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Бой (см)",
                        prefixIcon: const Icon(Icons.height),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: salmaqController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Салмақ (кг)",
                        prefixIcon: const Icon(Icons.monitor_weight),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: esepteu,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text(
                        "Есептеу",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: tazalau,
                      child: const Text("Тазалау"),
                    ),
                    const SizedBox(height: 30),
                    if (natizhe.isNotEmpty)
                      Column(
                        children: [
                          Text(
                            "BMI: $natizhe",
                            style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            kategoriya,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: kategoriyaTusi),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}