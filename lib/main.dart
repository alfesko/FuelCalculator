import 'package:flutter/material.dart';

void main() {
  runApp(FuelCalculatorApp());
}

class FuelCalculatorApp extends StatefulWidget {
  @override
  _FuelCalculatorAppState createState() => _FuelCalculatorAppState();
}

class _FuelCalculatorAppState extends State<FuelCalculatorApp> {
  ThemeMode _themeMode = ThemeMode.dark; // По умолчанию тёмная тема

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Топливомет',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.blueGrey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
          ),
        ),
      ),
      themeMode: _themeMode, // Управление переключением темы
      home: FuelCalculatorScreen(onToggleTheme: _toggleTheme),
    );
  }
}

class FuelCalculatorScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  FuelCalculatorScreen({required this.onToggleTheme});

  @override
  _FuelCalculatorScreenState createState() => _FuelCalculatorScreenState();
}

class _FuelCalculatorScreenState extends State<FuelCalculatorScreen> {
  final TextEditingController _fuelConsumptionController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _fuelCostController = TextEditingController();

  String _result = '';
  String _selectedFuelUnit = 'Литр';
  String _selectedDistanceUnit = 'Километры';
  String _selectedConsumptionUnit = 'Литры на 100 км';

  final Map<String, double> fuelUnitConversion = {
    'Литр': 1.0,
    'Галлон США': 3.785,
    'Имперский галлон': 4.546,
  };

  final Map<String, double> distanceUnitConversion = {
    'Километры': 1.0,
    'Мили': 1.609,
  };

  final Map<String, double> consumptionUnitConversion = {
    'Литры на 100 км': 1.0,
    'Литры на 10 км': 10.0,
    'Литры на 1 км': 100.0,
    'Литры на милю': 1.60934 * 100.0,
    'Мили на галлон США': 235.215,
    'Мили на имперский галлон': 282.481,
    'Километры на литр': 100.0,
    'Километры на галлон США': 3.78541 * 100,
    'Километры на имперский галлон': 4.54609 * 100,
    'Галлоны США на 100 миль': 2.35215,
    'Имперские галлоны на 100 миль': 2.82481,
  };

  void _calculateFuelCost() {
    double consumption = double.tryParse(_fuelConsumptionController.text) ?? 0;
    double distance = double.tryParse(_distanceController.text) ?? 0;
    double costPerUnit = double.tryParse(_fuelCostController.text) ?? 0;

    if (consumption < 0 || distance < 0 || costPerUnit < 0) {
      setState(() {
        _result = 'Пожалуйста, введите положительные значения.';
      });
      return;
    }

    double consumptionPer100Km = consumptionUnitConversion[_selectedConsumptionUnit]! * consumption;
    double costPerLiter = costPerUnit / fuelUnitConversion[_selectedFuelUnit]!;
    double distanceInKm = distance * distanceUnitConversion[_selectedDistanceUnit]!;

    double fuelUsed = (consumptionPer100Km / 100) * distanceInKm;
    double totalCost = fuelUsed * costPerLiter;

    setState(() {
      _result = 'Общая стоимость: ${totalCost.toStringAsFixed(2)} BYN';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Топливомет'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fuelConsumptionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Средний расход топлива ($_selectedConsumptionUnit)',
              ),
            ),
            DropdownButton<String>(
              value: _selectedConsumptionUnit,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedConsumptionUnit = newValue!;
                });
              },
              items: <String>[
                'Литры на 100 км',
                'Литры на 10 км',
                'Литры на 1 км',
                'Литры на милю',
                'Мили на галлон США',
                'Мили на имперский галлон',
                'Километры на литр',
                'Километры на галлон США',
                'Километры на имперский галлон',
                'Галлоны США на 100 миль',
                'Имперские галлоны на 100 миль',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _distanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Пройденное расстояние ($_selectedDistanceUnit)',
              ),
            ),
            DropdownButton<String>(
              value: _selectedDistanceUnit,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDistanceUnit = newValue!;
                });
              },
              items: <String>['Километры', 'Мили']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _fuelCostController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Стоимость топлива ($_selectedFuelUnit)',
              ),
            ),
            DropdownButton<String>(
              value: _selectedFuelUnit,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFuelUnit = newValue!;
                });
              },
              items: <String>['Литр', 'Галлон США', 'Имперский галлон']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateFuelCost,
              child: Text('Рассчитать'),
            ),
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
