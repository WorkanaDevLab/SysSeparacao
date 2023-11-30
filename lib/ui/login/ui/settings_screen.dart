import 'package:flutter/material.dart';
import 'package:flutterbase/components/custombutton.dart';
import 'package:flutterbase/components/customtextfield.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CONFIGURAÇÕES"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: TextEditingController(), labelText: "IP"),
            const SizedBox(height: 8,),
            CustomTextField(controller: TextEditingController(), labelText: "IP"),
            const SizedBox(height: 8,),
            CustomButton(onTap: () {}, buttonText: "Atualizar", color: Colors.blue)
          ],
        ),
      ),
    );
  }
}
