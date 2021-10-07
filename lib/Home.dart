import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';

class Home extends StatelessWidget {
  StreamController<int> roulleteController = StreamController<int>();
  Sink<int> get getRoulleteSink => roulleteController.sink;
  Stream<int> get getRoulleteStream => roulleteController.stream;

  StreamController<String> currentLanguageController =
      StreamController<String>();
  Sink<String> get getcurrentLanguageSink => currentLanguageController.sink;
  Stream<String> get getcurrentLanguageStream =>
      currentLanguageController.stream;

  String currentLanguage = "";
  int currentIndex = 0;
  bool isAnimating = false;

  List<Language> languages = [
    new Language(0, 'Java'),
    new Language(1, 'Dart'),
    new Language(2, 'Javascript'),
    new Language(3, 'Python'),
    new Language(4, 'C#'),
    new Language(5, 'Php'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Fortune Wheel'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isAnimating) {
                  isAnimating = true;
                  final random = Random();
                  var randomNumber = random.nextInt(6);
                  currentIndex = randomNumber;
                  getRoulleteSink.add(randomNumber);
                  currentLanguage = languages[randomNumber].name;
                }
              },
              child: Container(
                child: FortuneWheel(
                  animateFirst: false,
                  duration: Duration(seconds: 5),
                  onAnimationEnd: () {
                    isAnimating = false;
                    getcurrentLanguageSink.add(currentLanguage);
                  },
                  selected: getRoulleteStream,
                  items: List.generate(
                      languages.length,
                      (index) =>
                          FortuneItem(child: Text(languages[index].name))),
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream: getcurrentLanguageStream,
            initialData: 0,
            builder: (context, snapshot) {
              return Text(
                languages[currentIndex].name,
                style: TextStyle(fontSize: 30),
              );
            },
          )
        ],
      ),
    );
  }
}

class Language {
  final int id;
  final String name;

  const Language(this.id, this.name);
}
