import 'package:flutter/material.dart';

void main() {
  runApp(const HealthApp());
}

// ================= MAIN APP =================
class HealthApp extends StatelessWidget {
  const HealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Health Control Pro",
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const HomePage(),
    );
  }
}

// ================= GLOBAL HISTORY =================
List<String> historyList = [];

// ================= HOMEPAGE =================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget buildButton(BuildContext context, String title, Widget page, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20),
          backgroundColor: color,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(width: 15),
            Expanded(
              child: Text(title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white70)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Health Control Pro")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildButton(context, "1️⃣ BMI Есептеу", BMIScreen(), Icons.monitor_weight, Colors.teal),
            buildButton(context, "2️⃣ Калория Есептеу", CalorieScreen(), Icons.restaurant, Colors.orangeAccent),
            buildButton(context, "3️⃣ Су Нормасы", WaterScreen(), Icons.water, Colors.blueAccent),
            buildButton(context, "4️⃣ Жалпы Анализ", AnalysisScreen(), Icons.analytics, Colors.deepPurple),
            buildButton(context, "5️⃣ Денсаулық Функциясы", HealthFunctionScreen(), Icons.favorite, Colors.redAccent),
            buildButton(context, "6️⃣ Тарих", HistoryScreen(), Icons.history, Colors.grey),
          ],
        ),
      ),
    );
  }
}

// ================= BMI SCREEN =================
class BMIScreen extends StatefulWidget {
  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  String result = "";
  Color resultColor = Colors.black;

  void calculateBMI() {
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;
    if (height <= 0 || weight <= 0) {
      setState(() {
        result = "Қате мән енгізілді";
        resultColor = Colors.red;
      });
      return;
    }
    height /= 100;
    double bmi = weight / (height * height);
    String category;
    if (bmi < 18.5) {
      category = "Салмақ жетіспейді";
      resultColor = Colors.orange;
    } else if (bmi < 25) {
      category = "Қалыпты";
      resultColor = Colors.green;
    } else if (bmi < 30) {
      category = "Артық салмақ";
      resultColor = Colors.orangeAccent;
    } else {
      category = "Семіздік";
      resultColor = Colors.red;
    }
    setState(() {
      result = "BMI: ${bmi.toStringAsFixed(1)}\n$category";
      historyList.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BMI Есептеу")),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 12,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("BMI Есептеу", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Бой (см)",
                      prefixIcon: Icon(Icons.height),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Салмақ (кг)",
                      prefixIcon: Icon(Icons.monitor_weight),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: calculateBMI, child: const Text("Есептеу")),
                  const SizedBox(height: 20),
                  Text(result, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: resultColor)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= CALORIE SCREEN =================
class CalorieScreen extends StatefulWidget {
  @override
  State<CalorieScreen> createState() => _CalorieScreenState();
}

class _CalorieScreenState extends State<CalorieScreen> {
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  String gender = "Ер";
  String activity = "Орташа";
  String result = "";

  void calculateCalories() {
    double age = double.tryParse(ageController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;
    if (age <= 0 || height <= 0 || weight <= 0) {
      setState(() {
        result = "Қате мән";
      });
      return;
    }
    double bmr;
    if (gender == "Ер") {
      bmr = 88.36 + (13.4 * weight) + (4.8 * height) - (5.7 * age);
    } else {
      bmr = 447.6 + (9.2 * weight) + (3.1 * height) - (4.3 * age);
    }
    double factor = 1.2;
    if (activity == "Жеңіл") factor = 1.375;
    if (activity == "Орташа") factor = 1.55;
    if (activity == "Күшті") factor = 1.725;
    double calories = bmr * factor;
    setState(() {
      result = "Күндік калория: ${calories.toStringAsFixed(0)} ккал";
      historyList.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Калория Есептеу")),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFFFB75E), Color(0xFFED8F03)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 12,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("Калория Есептеу", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(controller: ageController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Жас", border: OutlineInputBorder())),
                  const SizedBox(height: 10),
                  TextField(controller: heightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Бой (см)", border: OutlineInputBorder())),
                  const SizedBox(height: 10),
                  TextField(controller: weightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Салмақ (кг)", border: OutlineInputBorder())),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: gender,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Жыныс"),
                    items: const [
                      DropdownMenuItem(value: "Ер", child: Text("Ер")),
                      DropdownMenuItem(value: "Әйел", child: Text("Әйел")),
                    ],
                    onChanged: (val) => setState(() { gender = val!; }),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: activity,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Қозғалыс деңгейі"),
                    items: const [
                      DropdownMenuItem(value: "Жеңіл", child: Text("Жеңіл")),
                      DropdownMenuItem(value: "Орташа", child: Text("Орташа")),
                      DropdownMenuItem(value: "Күшті", child: Text("Күшті")),
                    ],
                    onChanged: (val) => setState(() { activity = val!; }),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: calculateCalories, child: const Text("Есептеу")),
                  const SizedBox(height: 20),
                  Text(result, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= WATER SCREEN =================
class WaterScreen extends StatefulWidget {
  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  final weightController = TextEditingController();
  String result = "";

  void calculateWater() {
    double weight = double.tryParse(weightController.text) ?? 0;
    if (weight <= 0) {
      setState(() { result = "Қате мән"; });
      return;
    }
    double water = weight * 0.03;
    setState(() {
      result = "Күніне су: ${water.toStringAsFixed(2)} литр";
      historyList.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Су Нормасы")),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 12,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const Text("Су Нормасы", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(controller: weightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Салмақ (кг)", border: OutlineInputBorder())),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: calculateWater, child: const Text("Есептеу")),
                const SizedBox(height: 20),
                Text(result, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= ANALYSIS SCREEN =================
class AnalysisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Жалпы Анализ")),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: historyList.isEmpty
            ? const Center(child: Text("Нәтиже жоқ", style: TextStyle(fontSize: 18)))
            : ListView.builder(
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(historyList[historyList.length - index - 1], style: const TextStyle(fontSize: 18)),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// ================= HEALTH FUNCTION SCREEN =================
class HealthFunctionScreen extends StatefulWidget {
  @override
  State<HealthFunctionScreen> createState() => _HealthFunctionScreenState();
}

class _HealthFunctionScreenState extends State<HealthFunctionScreen> {
  final bmiController = TextEditingController();
  final weightController = TextEditingController();
  String result = "";

  void calculate() {
    double bmi = double.tryParse(bmiController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;
    if (bmi <= 0 || weight <= 0) {
      setState(() { result = "Қате мән"; });
      return;
    }
    double bodyFat = (1.2 * bmi) + (0.23 * 25) - 5.4;
    String nutrition = bmi < 18.5 ? "Қосымша калория қажет 🍎" : bmi < 25 ? "Қалыпты тамақтану 🥗" : "Калорияны азайту және спорт 🏃‍♂️";
    result = "Дене майы: ${bodyFat.toStringAsFixed(1)}%\n$nutrition";
    historyList.add(result);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Денсаулық Функциясы")),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 12,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Денсаулық Функциясы", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(controller: bmiController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "BMI", border: OutlineInputBorder())),
                  const SizedBox(height: 15),
                  TextField(controller: weightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Салмақ (кг)", border: OutlineInputBorder())),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: calculate, child: const Text("Есептеу")),
                  const SizedBox(height: 20),
                  Text(result, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= HISTORY SCREEN =================
class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Тарих")),
      body: historyList.isEmpty
          ? const Center(child: Text("Тарих бос", style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  child: ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(historyList[index]),
                  ),
                );
              },
            ),
    );
  }
}