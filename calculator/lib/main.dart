import 'dart:developer';
import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:math_expressions/math_expressions.dart";

import 'exprnumber.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.green,
        textTheme: TextTheme(bodyText2: TextStyle(color: Colors.black)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: "Calculator"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var userInput = '';
  var userAnswer = '';
  var lastAnswer = '';
  var nf = new NumberFormat();
  List<ExprNumber> userExpression = [];
  bool lastOperator = false;

  //lolz
  String easterEgg = 'BOLOSS';
  int easterCount = 0;

  final List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '9',
    '8',
    '7',
    'x',
    '6',
    '5',
    '4',
    '-',
    '3',
    '2',
    '1',
    '+',
    '0',
    '.',
    'ANS',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(userInput,
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(userAnswer,
                        style: TextStyle(color: Colors.white, fontSize: 36)),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                  color: Colors.grey,
                ))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      itemCount: buttons.length,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      itemBuilder: (BuildContext context, int index) {
                        //Clear button
                        if (index == 0) {
                          return MyButton(
                              buttonTapped: () {
                                setState(() {
                                  userInput = "";
                                  userAnswer = "";
                                  lastOperator = false;
                                  userExpression = [];
                                });
                              },
                              text: buttons[index],
                              color: Colors.black,
                              textColor: Colors.green);
                          // Delete button
                        } else if (index == 1) {
                          return MyButton(
                              buttonTapped: () {
                                setState(() {
                                  updateCalculation(index);
                                });
                              },
                              text: buttons[index],
                              color: Colors.black,
                              textColor: Colors.deepOrange);

                          // Equals button
                        } else if (index == buttons.length - 1) {
                          return Container(
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                shape: BoxShape.circle),
                            child: MyButton(
                                buttonTapped: () {
                                  setState(() {
                                    calculate();
                                    lastAnswer = userAnswer;
                                    easterCount += 1;
                                    if (easterCount == 5) {
                                      easterCount = 0;
                                      userAnswer = easterEgg;
                                    }
                                  });
                                },
                                text: buttons[index],
                                color: Colors.transparent,
                                textColor: Colors.white),
                          );

                          // ANS button
                        } else if (index == buttons.length - 2) {
                          return MyButton(
                              buttonTapped: () {
                                setState(() {
                                  userAnswer = lastAnswer;
                                });
                              },
                              text: buttons[index],
                              color: Colors.black,
                              textColor: Colors.deepOrange);
                        } else {
                          return MyButton(
                            buttonTapped: () {
                              setState(() {
                                easterCount = 0;
                                updateCalculation(index);
                              });
                            },
                            text: buttons[index],
                            color: isOperator(buttons[index])
                                ? Colors.black
                                : Colors.black,
                            textColor: isOperator(buttons[index])
                                ? Colors.deepOrange
                                : Colors.white,
                          );
                        }
                      }),
                )),
          ),
        ]));
  }

  bool isOperator(String x) {
    return (x == '%' ||
        x == '/' ||
        x == '-' ||
        x == 'x' ||
        x == '+' ||
        x == '=');
  }

  void calculate() {
    String input = userInput;

    if (input.length == 0) {
      input = '0';
    }

    input = input.replaceAll('x', '*');
    input = input.replaceAll(',', '');

    try {
      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      userAnswer = "= " + nf.format(eval);
    } catch (e) {
      userAnswer = '= Error';
      log(e.toString());
    }
  }

  void updateCalculation(int index) {
    ExprNumber expr;
    ExprNumber currentExpr;

    //number increment logic
    if (buttons[index] != 'DEL') {
      if (userExpression.length == 0 &&
          !ExprNumber.operators.contains(buttons[index])) {
        expr = new ExprNumber(buttons[index]);
        userExpression.add(expr);
      } else if (userExpression.length > 0) {
        currentExpr = userExpression[userExpression.length - 1];
        expr = currentExpr.append(buttons[index]);

        if (currentExpr != expr) {
          userExpression.add(expr);
        }
      }
    } else if (userExpression.length > 0) {
      currentExpr = userExpression[userExpression.length - 1];
      currentExpr.trim(1);

      if (currentExpr.value.length == 0) {
        userExpression.removeLast();
      }
    }

    log(userExpression.toString() +
        " tot :" +
        userExpression.length.toString());

    // Display current expression
    userInput = "";
    userExpression.forEach((i) {
      userInput += i.toString();
    });

    // Update the results
    if (userExpression.length > 0) {
      if (userExpression[userExpression.length - 1].isOperator == false &&
          !ExprNumber.operators.contains(buttons[index])) {
        calculate();
      }
    }
  }
}
