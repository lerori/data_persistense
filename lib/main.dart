import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Data Persistence'),
          ),
          body: Center(
              child: FutureBuilder<int>(
                  future: _counter,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(
                            'Button tapped ${snapshot.data} time${snapshot.data == 1 ? '' : 's'}.\n\n'
                            'This should persist across restarts.',
                          );
                        }
                    }
                  })),
          floatingActionButton: FloatingActionButton(
            onPressed: _changeValue,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ));
  }

  //vars to use with sharedPpreferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter;

  Future<void> _changeValue() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await _prefs;
    // get an integer value to 'counter' key.
    final int counter = (prefs.getInt('counter') ?? 0) + 1;
    //to refresh screen
    setState(() {
      // Save an integer value to 'counter' key.
      _counter = prefs.setInt('counter', counter).then((bool success) {
        return counter;
      });
    });
  }

  //to run at startup
  @override
  void initState() {
    super.initState();
    // get an integer value to 'counter' key.
    _counter = _prefs.then((SharedPreferences prefs) {
      //if what it brings is null we assign a zero
      return prefs.getInt('counter') ?? 0;
    });
  }
}
