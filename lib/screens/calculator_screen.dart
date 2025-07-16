// File: MultipleFiles/calculator_screen.dart

import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "";
  String _expression = "";

  // Warna Neon dan Background untuk tema Cyberpunk
  static const Color neonBlue = Color(0xFF00FFFF); // Cyan
  static const Color neonPink = Color(0xFFFF00FF); // Magenta
  static const Color darkBackground = Color(0xFF1A1A2E); // Dark Blue/Purple
  static const Color lightSurface = Color(0xFF2C2C4A); // Slightly lighter surface

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "";
        _expression = "";
      } else if (buttonText == "=") {
        try {
          // Basic evaluation, for a real app, use a proper math expression parser
          _output = evalExpression(_expression);
          _expression = _output; // Set expression to result for continuous calculation
        } catch (e) {
          _output = "Error";
          _expression = "";
        }
      } else {
        _expression += buttonText;
        _output = _expression;
      }
    });
  }

  String evalExpression(String expression) {
    // This is a very basic and unsafe evaluation.
    // For a production app, use a dedicated math expression parser library.
    try {
      // Replace common math symbols for Dart's eval (if using a package like math_expressions)
      // For this simple example, we'll just use Dart's built-in arithmetic
      // This part is highly simplified and prone to errors for complex expressions.
      // A real calculator would parse the expression into numbers and operators.

      // Example of a very basic direct evaluation (not robust for all cases)
      // This is just for demonstration and should NOT be used in production.
      // For example, it doesn't handle operator precedence correctly.
      List<String> parts = expression.split(RegExp(r'(\+|\-|\*|\/)'));
      List<String> operators = expression.replaceAll(RegExp(r'[0-9\.]'), '').split('');

      if (parts.length == 1) return parts[0]; // Single number

      double result = double.parse(parts[0]);
      for (int i = 0; i < operators.length; i++) {
        double nextNum = double.parse(parts[i + 1]);
        switch (operators[i]) {
          case '+':
            result += nextNum;
            break;
          case '-':
            result -= nextNum;
            break;
          case '*':
            result *= nextNum;
            break;
          case '/':
            if (nextNum == 0) return "Error";
            result /= nextNum;
            break;
        }
      }
      return result.toString();
    } catch (e) {
      return "Error";
    }
  }

  Widget _buildButton(String buttonText) {
    // Determine if the button is an operator or a number/clear/equals
    bool isOperator = buttonText == "+" || buttonText == "-" || buttonText == "*" || buttonText == "/";
    bool isClearOrEquals = buttonText == "C" || buttonText == "=";

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), // Rounded corners for buttons
          boxShadow: [
            // Darker shadow for depth
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              offset: const Offset(6, 6),
              blurRadius: 10,
              spreadRadius: 0.5,
            ),
            // Lighter shadow for highlight
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              offset: const Offset(-6, -6),
              blurRadius: 10,
              spreadRadius: 0.5,
            ),
            // Neon glow effect based on button type
            BoxShadow(
              color: isOperator ? neonPink.withOpacity(0.5) : neonBlue.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(color: isOperator ? neonPink.withOpacity(0.3) : neonBlue.withOpacity(0.3), width: 1.5),
        ),
        child: ElevatedButton(
          onPressed: () => _buttonPressed(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: lightSurface, // Base color for neumorphic element
            foregroundColor: isClearOrEquals ? neonPink : (isOperator ? neonBlue : Colors.white), // Text color
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Match container border radius
            ),
            textStyle: const TextStyle(
              fontSize: 24, // Larger font size for buttons
              fontWeight: FontWeight.bold,
              shadows: [ // Text shadow for neon effect
                Shadow(
                  color: Colors.white,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            elevation: 0, // Remove default elevation as we use custom shadows
          ),
          child: Text(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kalkulator Cyberpunk',
          style: TextStyle(
            color: neonBlue,
            shadows: [
              Shadow(
                color: neonBlue.withOpacity(0.8),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
        backgroundColor: darkBackground,
        foregroundColor: neonBlue,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [darkBackground, Color(0xFF0F0F1A)], // Darker gradient for cyberpunk feel
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/gambar6.jpg'), // Gambar background cyberpunk
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken), // Darken the image
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: lightSurface, // Base color for neumorphic element
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                // Darker shadow for depth
                BoxShadow(
                  color: Colors.black.withOpacity(0.7),
                  offset: const Offset(8, 8),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                // Lighter shadow for highlight
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  offset: const Offset(-8, -8),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                // Neon glow effect
                BoxShadow(
                  color: neonBlue.withOpacity(0.5),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(color: neonPink.withOpacity(0.3), width: 2), // Subtle neon border
            ),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _output,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: neonBlue, // Neon color for output
                      shadows: [
                        Shadow(
                          color: neonBlue.withOpacity(0.8),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(color: neonPink, thickness: 2), // Neon divider
                Row(
                  children: [
                    _buildButton("1"),
                    _buildButton("2"),
                    _buildButton("3"),
                    _buildButton("+"),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("4"),
                    _buildButton("5"),
                    _buildButton("6"),
                    _buildButton("-"),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("7"),
                    _buildButton("8"),
                    _buildButton("9"),
                    _buildButton("*"),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("C"),
                    _buildButton("0"),
                    _buildButton("="),
                    _buildButton("/"),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: neonPink, // Neon color for back button
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadowColor: neonPink.withOpacity(0.5), // Neon shadow for back button
                    elevation: 10,
                  ),
                  child: const Text('Kembali ke Home', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}