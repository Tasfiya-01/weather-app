import 'package:myapp/widgets/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/weather_model.dart';
import 'package:myapp/services/weather_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherServices _weatherServices = WeatherServices();

  final TextEditingController _controller = TextEditingController();

  bool _isLoading = false;

  Weather? _weather;

  void _getWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await _weatherServices.featchWeather(_controller.text);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching weather data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient:
              _weather != null &&
                      _weather!.description.toLowerCase().contains('rain')
                  ? const LinearGradient(
                    colors: [Colors.grey, Color.fromARGB(255, 91, 139, 163)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                  : _weather != null &&
                      _weather!.description.toLowerCase().contains('clear')
                  ? const LinearGradient(
                    colors: [Colors.orangeAccent, Color.fromARGB(255, 74, 100, 145)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                  : const LinearGradient(
                    colors: [Color.fromARGB(255, 160, 156, 156), Color.fromARGB(255, 22, 19, 196)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 25),

                const Text(
                  'Weather App',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 55, 59, 59),
                  ),
                ),

                const SizedBox(height: 25),

                TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter your City Name",
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color.fromARGB(108, 88, 84, 84),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _getWeather,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(209, 250, 253, 255),
                    foregroundColor: const Color.fromARGB(255, 69, 149, 214),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('Get Weather', style: TextStyle(fontSize: 18)),
                ),
                if (_isLoading)
                  Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: const Color.fromARGB(255, 255, 255, 255)),
                  ),

                if (_weather != null) WeatherCard(weather: _weather!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
