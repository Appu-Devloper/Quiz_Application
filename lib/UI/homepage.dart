import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/UI/Quizpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Home/bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final HomeBloc _homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 39, 67),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 39, 67),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocConsumer(
              bloc: _homeBloc,
              listenWhen: (previous, current) => current is HomeAction,
              buildWhen: (previous, current) => current is! HomeAction,
              listener: (context, state) {
                if (state is HomeLoadedState) {
                  final data = state.tasks;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Quizpage(quizQuestions: data)));
                } else if (state is HomeErrorState) {}
              },
              builder: (context, state) {
                return 
              
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset('assets/logo.jpg'),
                    const Text(
                      'Welcome to the Flutter Quiz!',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Enter your name',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Validated, save name to shared preferences
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('user', _nameController.text);
                          _nameController.clear();
                          // Navigate to the next page or perform required action
                          _homeBloc.add(HomeInitialEvent());
                        }
                      },
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ),
            );
            },
            ),
          ],
        ),
      ),
    );
  }
}
