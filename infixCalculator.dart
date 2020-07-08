main(List<String> args) {
  print(evaluate(args[0]));
}

// Apply an operator on operands 'num1' and 'num2'
// ignore: missing_return
applyOperator(var operator, num2, num1) {
  switch (operator) {
    case '+':
      return (num1 + num2);
    case '-':
      return (num1 - num2);
    case '*':
      return (num1 * num2);
    case '/':
      if (num2 == 0) throw IntegerDivisionByZeroException;
      return num1 / num2;
  }
}

// Returns true if 'operator2' has higher or same precedence as 'operator1'
bool hasPrecedence(var operator1, var operator2) {
  if (operator2 == '(' || operator2 == ')') return false;

  if ((operator1 == '*' || operator1 == '/') &&
      (operator2 == '+' || operator2 == '-'))
    return false;
  else
    return true;
}

evaluate(String expression) {
  List tokens = expression.split('');
  // Stack for numbers
  List values = [];
  // Stack for operators
  List<String> operators = [];

  for (var i = 0; i < tokens.length; i++) {
    // Skip whitespace
    if (tokens[i] == ' ') continue;

    // Push number to values stack
    if (tokens[i].runes.first >= '0'.runes.first &&
        tokens[i].runes.first <= '9'.runes.first) {
      // Check for more than one digit
      StringBuffer buffer = new StringBuffer();
      while (i < tokens.length &&
          tokens[i].runes.first >= '0'.runes.first &&
          tokens[i].runes.first <= '9'.runes.first) {
        buffer.write(tokens[i++]);
      }
      values.add(int.parse(buffer.toString()));
    }
    // Push opening brace to operators stack
    else if (tokens[i] == '(') {
      operators.add(tokens[i]);
    }
    // Solve entire brace when closing brace encountered
    else if (tokens[i] == ')') {
      while (operators.last != '(') {
        values.add(applyOperator(
            operators.removeLast(), values.removeLast(), values.removeLast()));
      }
      operators.removeLast();
    }
    // Current token is an operator.
    else if (tokens[i] == '+' ||
        tokens[i] == '-' ||
        tokens[i] == '*' ||
        tokens[i] == '/') {
      // While top of operators stack has same or greater precedence to current
      // operator token apply operator to top two nodes in values stack.
      while (!operators.isEmpty && hasPrecedence(tokens[i], operators.last)) {
        values.add(applyOperator(
            operators.removeLast(), values.removeLast(), values.removeLast()));
      }
      // Push current token to operators stack
      operators.add(tokens[i]);
    }
  }

  // Expression has been parsed. Apply remaining operators to remaining values
  while (!operators.isEmpty) {
    values.add(applyOperator(
        operators.removeLast(), values.removeLast(), values.removeLast()));
  }

  return values.removeLast();
}
