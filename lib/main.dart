import 'package:auto_size_text/auto_size_text.dart';
import 'package:calculator/widgets.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

const double defaultPadding = 5.0;
const Color numberColor = Colors.grey;
const Color operandColor = Colors.blueGrey;
const Color nothingColor = Colors.white10;
List<String> accumulator = [];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String mode = "stan";
  String input = "";
  String answer = "";

  final List<String> stanButtons = [
    'C',
    '+/-',
    '<-',
    "/",
    '1',
    '2',
    '3',
    '*',
    '4',
    '5',
    '6',
    '-',
    '7',
    '8',
    '9',
    '+',
    '.',
    '0',
    '',
    '=',
  ];
  final List<String> sciButtons = [
    'C',
    '+/-',
    '(',
    ')',
    '<-',
    '1',
    '2',
    '3',
    '^',
    '/',
    '4',
    '5',
    '6',
    '√',
    '*',
    '7',
    '8',
    '9',
    '!',
    '+',
    '.',
    '0',
    '',
    'π',
    '-',
    '',
    '',
    '',
    '',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    final List<MenuBar> menuItems = <MenuBar>[];
    var aspect = 0.0;
    var orient = MediaQuery.of(context).orientation;
    if (orient == Orientation.portrait && mode == 'stan') {
      aspect = .99;
    } else if (orient == Orientation.landscape && mode == 'stan') {
      aspect = 4.5;
    } else if (orient == Orientation.portrait && mode == 'sci') {
      aspect = .95;
    } else if (orient == Orientation.landscape && mode == 'sci') {
      aspect = 4.4;
    }

    menuItems.add(MenuBar(children: [
      MenuItemButton(
          child: Text('Standard'),
          onPressed: () => setState(() {
                mode = "stan";
              })),
      MenuItemButton(
          child: Text('Scientific'),
          onPressed: () => setState(() {
                mode = "sci";
              }))
    ]));

    if (mode == "stan") {
      return Scaffold(
          appBar: AppBar(title: Text('Calculator'), actions: [
            MenuBar(children: menuItems),
          ]),
          body: Column(children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: AutoSizeText(
                      input,
                      style: TextStyle(fontSize: 30),
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: AutoSizeText(
                      answer,
                      style: TextStyle(fontSize: 70),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                flex: 2,
                fit: FlexFit.loose,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: stanButtons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: aspect, crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return NumberButton(
                          //clear Button
                          color: operandColor,
                          text: stanButtons[index],
                          onPressed: () {
                            setState(() {
                              input = '';
                              answer = '';
                            });
                          });
                    } else if (index == 1) {
                      return NumberButton(
                          //negative switcher
                          color: operandColor,
                          text: stanButtons[index],
                          onPressed: () {
                            setState(() {
                              flipPolarity();
                            });
                          });
                    } else if (index == 2) {
                      return NumberButton(
                        //back button
                        color: operandColor,
                        text: stanButtons[index],
                        onPressed: () {
                          setState(() {
                            input = input.substring(0, input.length - 1);
                          });
                        },
                      );
                    } else if (index == 18) {
                      return TextButton(
                          onPressed: () {
                            showAboutDialog(
                                context: context,
                                applicationName:
                                    "Andrew Maag's Attempt at a\nFlutter Calculator",
                                applicationVersion: "version: 0.1");
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: operandColor),
                          child: Icon(
                            Icons.info,
                            color: Colors.white,
                          ));
                    } else if (index == 19) {
                      return NumberButton(
                          //equals button
                          color: operandColor,
                          text: stanButtons[index],
                          onPressed: () {
                            setState(() {
                              calculate();
                            });
                          });
                    } else {
                      if (isOperand(stanButtons[index]) == true) {
                        return NumberButton(
                            //operand accumulator
                            color: operandColor,
                            text: stanButtons[index],
                            onPressed: () {
                              setState(() {
                                input += stanButtons[index];
                              });
                            });
                      } else {
                        return NumberButton(
                            color: numberColor,
                            text: stanButtons[index],
                            onPressed: () {
                              setState(() {
                                input += stanButtons[index];
                              });
                            });
                      }
                    }
                  },
                ))
          ]));
    } else if (mode == "sci") {
      return Scaffold(
          appBar: AppBar(title: Text('Calculator'), actions: [
            MenuBar(children: menuItems),
          ]),
          body: Column(children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: AutoSizeText(input,
                        style: TextStyle(fontSize: 30), maxLines: 1),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: AutoSizeText(answer,
                        style: TextStyle(fontSize: 70), maxLines: 1),
                  ),
                ],
              ),
            ),
            Flexible(
                flex: 2,
                child: Container(
                    child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: sciButtons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: aspect, crossAxisCount: 5),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return ScienceButton(
                          //clear Button
                          color: operandColor,
                          text: sciButtons[index],
                          onPressed: () {
                            setState(() {
                              input = '';
                              answer = '';
                            });
                          });
                    } else if (index == 1) {
                      return ScienceButton(
                          //negative switcher
                          color: operandColor,
                          text: sciButtons[index],
                          onPressed: () {
                            setState(() {
                              flipPolarity();
                            });
                          });
                    } else if (index == 2) {
                      return ScienceButton(
                        //LParen
                        color: operandColor,
                        text: sciButtons[index],
                        onPressed: () {
                          setState(() {
                            input += sciButtons[index];
                          });
                        },
                      );
                    } else if (index == 3) {
                      return ScienceButton(
                        //RParen
                        color: operandColor,
                        text: sciButtons[index],
                        onPressed: () {
                          setState(() {
                            input += sciButtons[index];
                          });
                        },
                      );
                    } else if (index == 4) {
                      return ScienceButton(
                        //back button
                        color: operandColor,
                        text: sciButtons[index],
                        onPressed: () {
                          setState(() {
                            input = input.substring(0, input.length - 1);
                          });
                        },
                      );
                    } else if (index == 18) {
                      return ScienceButton(
                          //equals button
                          color: operandColor,
                          text: sciButtons[index],
                          onPressed: () {
                            setState(() {
                              calcFactorial();
                            });
                          });
                    } else if (index == 13) {
                      return ScienceButton(
                          //equals button
                          color: operandColor,
                          text: sciButtons[index],
                          onPressed: () {
                            setState(() {
                              if (answer != '') {
                                input = "sqrt(" + answer + ")";
                              } else {
                                input += "sqrt(";
                              }
                            });
                          });
                    } else if (index == 22 ||
                        index == 25 ||
                        index == 26 ||
                        index == 27) {
                      return ScienceButton(
                        //back button
                        color: nothingColor,
                        text: sciButtons[index],
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text("Don't Touch That!"),
                                    content:
                                        Text("It doesn't do anything yet."),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            _openGitHub();
                                          },
                                          child: Text(
                                              'But I want it to do something')),
                                      TextButton(
                                          onPressed: () {
                                            _dismissDialog();
                                          },
                                          child: Text('Close')),
                                    ]);
                              });
                        },
                      );
                    } else if (index == 23) {
                      return ScienceButton(
                        //back button
                        color: operandColor,
                        text: sciButtons[index],
                        onPressed: () {
                          setState(() {
                            input += "3.14159265";
                          });
                        },
                      );
                    } else if (index == 28) {
                      return TextButton(
                          onPressed: () {
                            showAboutDialog(
                                context: context,
                                applicationName:
                                    "Andrew Maag's Attempt at a\nFlutter Calculator",
                                applicationVersion: "version: 0.1");
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: operandColor),
                          child: Icon(
                            Icons.info,
                            color: Colors.white,
                          ));
                    } else if (index == 29) {
                      return ScienceButton(
                          //equals button
                          color: operandColor,
                          text: sciButtons[index],
                          onPressed: () {
                            setState(() {
                              calculate();
                            });
                          });
                    } else {
                      if (isOperand(sciButtons[index]) == true) {
                        return ScienceButton(
                            //operand accumulator
                            color: operandColor,
                            text: sciButtons[index],
                            onPressed: () {
                              setState(() {
                                input += sciButtons[index];
                              });
                            });
                      } else {
                        return ScienceButton(
                            color: numberColor,
                            text: sciButtons[index],
                            onPressed: () {
                              setState(() {
                                input += sciButtons[index];
                              });
                            });
                      }
                    }
                  },
                )))
          ]));
    }
    return Text("Fail");
  }

  bool isOperand(o) {
    if (o == '+' ||
        o == '-' ||
        o == '*' ||
        o == '/' ||
        o == '=' ||
        o == '^' ||
        o == '√' ||
        o == '!' ||
        o == 'π') {
      return true;
    } else {
      return false;
    }
  }

  void flipPolarity() {
    double temp = double.parse(answer);
    answer = (temp * -1).toString();
    input = answer;
  }

  void calculate() {
    answer = input.interpret().toString();
    input = answer;
  }

  void calcFactorial() {
    int fact = 1;
    if (input == '0' || input == '' || input == '1' || input == '1.0') {
      answer = fact.toString();
    } else if (int.parse(input) > 1) {
      for (int i = int.parse(input); i >= 1; i--) {
        fact = fact * i;
      }
      answer = fact.toString();
    } else {
      answer = "Invalid Input";
    }
  }

  _dismissDialog() {
    Navigator.pop(context);
  }

  _openGitHub() async {
    const url = "https://github.com/skizpow7/dart_calculator";
    final uri = Uri.parse(url);
    await launchUrl(uri);
  }
}
