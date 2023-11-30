import 'package:flutter/material.dart';
import 'package:flutterbase/data/models/setor.dart';
import 'package:flutterbase/data/models/setor.dart';
import 'package:flutterbase/data/models/setor.dart';
import 'package:flutterbase/data/models/setor.dart';
import 'package:flutterbase/data/models/setor.dart';
import 'package:flutterbase/data/models/setor.dart';
import 'package:flutterbase/data/models/setor.dart';
import 'package:flutterbase/data/models/unidade_empresarial.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/data/models/usuario.dart';

class CustomDropdownSetor extends StatefulWidget {
  final List<Setor> options;
  final Setor? selectedOption;
  final ValueChanged<Setor?>? onChanged;

  CustomDropdownSetor({
    required this.options,
    required this.selectedOption,
    this.onChanged,
  });

  @override
  _CustomDropdownSetorState createState() =>
      _CustomDropdownSetorState();
}

class _CustomDropdownSetorState extends State<CustomDropdownSetor> {
  Setor? _selectedUnidade;

  @override
  void initState() {
    super.initState();
    _selectedUnidade = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.blue),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Setor>(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blue,),
          hint: const Text("Selecione o setor",
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                height: 0,
              )),
          isExpanded: true,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            height: 0,
          ),
          value: widget.selectedOption,
          onChanged: (newValue) {
            setState(() {
              _selectedUnidade = newValue;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(newValue);
            }
          },
          items: widget.options.map((Setor setor) {
            return DropdownMenuItem<Setor>(
              value: setor,
              child: Text(setor.SETR_NOME!),
            );
          }).toList(),
        ),
      ),
    );
  }
}