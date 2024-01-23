import 'dart:math';
import 'package:brasil_fields/brasil_fields.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = 'Informe Seus Dados';

  void _resetFields() {
    weightController.text = '';
    heightController.text = '';
    setState(() {
      _infoText = 'Informe Seus Dados';
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text.replaceAll(',', '.'));
      double height = double.parse(heightController.text.replaceAll(',', '.'));
      double imc = weight / pow(height, 2);
      String resultado = 'IMC = ${imc.toStringAsPrecision(4)} \n';
      if (imc < 17) {
        _infoText = '$resultado Muito abaixo do peso!';
      } else if (imc >= 17 && imc < 18.5) {
        _infoText = '$resultado Abaixo do peso.';
      } else if (imc >= 18.5 && imc < 25) {
        _infoText = '$resultado Peso normal.';
      } else if (imc >= 25 && imc < 30) {
        _infoText = '$resultado Acima do peso.';
      } else if (imc >= 30 && imc < 35) {
        _infoText = '$resultado Obesidade gral I';
      } else if (imc >= 35 && imc < 40) {
        _infoText = '$resultado Obesidade gral II';
      } else if (imc >= 40) {
        _infoText = '$resultado Obesidade gral III';
      }
    });
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Calculadora de IMC',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              onPressed: _resetFields,
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 120,
                  color: Colors.green,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Peso (Kg)',
                    labelStyle: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    PesoInputFormatter(),
                  ],
                  controller: weightController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira seu Peso.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Altura (cm)',
                    labelStyle: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    AlturaInputFormatter(),
                  ],
                  controller: heightController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Insira sua Altura.';
                      }
                      return null;
                    }
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _calculate();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Calcular',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        )),
                  ),
                ),
                Text(
                  _infoText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }