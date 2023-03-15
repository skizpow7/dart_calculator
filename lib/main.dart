import 'package:flutter/material.dart';
import 'package:calculator/widgets.dart';
import 'package:function_tree/function_tree.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.centerRight,
                    child: AutoSizeText(
                      input,
                      style: TextStyle(fontSize: 30),
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 90, 5, 5),
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
            Expanded(
                flex: 2,
                child: Container(
                    child: GridView.builder(
                  itemCount: stanButtons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
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
                      return NumberButton(
                          //equals button
                          color: operandColor,
                          text: String.fromCharCodes(Runes('\u{01F6C8}')),
                          onPressed: () {
                            showAboutDialog(
                                context: context,
                                applicationName:
                                    "Andrew Maag's Attempt at a\nFlutter Calculator",
                                applicationVersion: "0.1");
                          });
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
                )))
          ]));
    } else if (mode == "sci") {
      return Scaffold(
          appBar: AppBar(title: Text('Calculator'), actions: [
            MenuBar(children: menuItems),
          ]),
          body: Column(children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.centerRight,
                    child: AutoSizeText(input,
                        style: TextStyle(fontSize: 30), maxLines: 1),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 90, 5, 5),
                    alignment: Alignment.centerRight,
                    child: AutoSizeText(answer,
                        style: TextStyle(fontSize: 70), maxLines: 1),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Container(
                    child: GridView.builder(
                  itemCount: sciButtons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5),
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
                    } else if (index == 13) {
                      return ScienceButton(
                          //equals button
                          color: operandColor,
                          text: sciButtons[index],
                          onPressed: () {
                            setState(() {
                              input += "sqrt(";
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
                      return ScienceButton(
                          //equals button
                          color: operandColor,
                          text: String.fromCharCodes(Runes('\u{01F6C8}')),
                          onPressed: () {
                            showAboutDialog(
                                context: context,
                                applicationName:
                                    "Andrew Maag's Attempt at a\nFlutter Calculator",
                                applicationVersion: "0.1");
                          });
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
  }

  _dismissDialog() {
    Navigator.pop(context);
  }

  _openGitHub() async {
    const url = "https://github.com/skizpow7/dart_calculator";
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
