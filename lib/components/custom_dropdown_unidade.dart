import 'package:flutter/material.dart';
import 'package:flutterbase/data/models/unidade_empresarial.dart';

class CustomDropdownUnidade extends StatefulWidget {
  final List<UnidadeEmpresarial> options;
  final UnidadeEmpresarial? selectedOption;
  final ValueChanged<UnidadeEmpresarial?>? onChanged;

  CustomDropdownUnidade({
    required this.options,
    required this.selectedOption,
    this.onChanged,
  });

  @override
  _CustomDropdownUnidadeState createState() =>
      _CustomDropdownUnidadeState();
}

class _CustomDropdownUnidadeState extends State<CustomDropdownUnidade> {
  UnidadeEmpresarial? _selectedUnidade;

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
        child: DropdownButton<UnidadeEmpresarial>(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blue,),
          hint: const Text("Selecione uma unidade empresarial",
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
          items: widget.options.map((UnidadeEmpresarial unidade) {
            return DropdownMenuItem<UnidadeEmpresarial>(
              value: unidade,
              child: Text(unidade.unem_Fantasia!),
            );
          }).toList(),
        ),
      ),
    );
  }
}