import 'package:flutter/material.dart';
import 'package:flutterbase/data/models/unidade_empresarial.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/data/models/usuario.dart';

class CustomDropdownUsuario extends StatefulWidget {
  final List<Usuario> options;
  final Usuario? selectedOption;
  final ValueChanged<Usuario?>? onChanged;

  CustomDropdownUsuario({
    required this.options,
    required this.selectedOption,
    this.onChanged,
  });

  @override
  _CustomDropdownUsuarioState createState() =>
      _CustomDropdownUsuarioState();
}

class _CustomDropdownUsuarioState extends State<CustomDropdownUsuario> {
  Usuario? _selectedUnidade;

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
        child: DropdownButton<Usuario>(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blue,),
          hint: const Text("Selecione o usuário",
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
          items: widget.options.map((Usuario user) {
            return DropdownMenuItem<Usuario>(
              value: user,
              child: Text(user.USRS_LOGIN!),
            );
          }).toList(),
        ),
      ),
    );
  }
}