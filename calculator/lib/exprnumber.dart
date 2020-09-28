import 'package:intl/intl.dart';

class ExprNumber {
  String value = "";
  bool isDecimal = false;
  bool isOperator = false;
  static List<String> operators = ['*', '/', '+', '-', '=', '%', 'x'];
  var nf = new NumberFormat();

  ExprNumber(this.value, {this.isDecimal = false, this.isOperator = false}) {
    if (value.length == 1 && operators.contains(value)) {
      isOperator = true;
    }
    if (value.length == 1 && value == '.') {
      isDecimal = true;
      this.value = '0.';
    }

    this.value = value;
  }

  trim(int index) {
    if (value.length - index >= 0) {
      value = value.substring(0, value.length - index);
    }

    return value;
  }

  ExprNumber append(String number) {
    if (operators.contains(number)) {
      if (isOperator) {
        value = number;
        return this;
      } else {
        return new ExprNumber(number, isOperator: true);
      }
    }

    if (isDecimal && number == '.') {
      return this;
    } else if (isOperator) {
      return new ExprNumber(number);
    } else {
      value += number;
    }

    return this;
  }

  @override
  // return formatted number
  String toString() {
    if (isOperator || isDecimal || value.length == 0) {
      return value;
    } else {
      return nf.format(nf.parse(value));
    }
  }
}
