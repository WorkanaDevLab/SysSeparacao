import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? errorText;
  final bool isSecret;
  final bool? isPhone;
  final bool? enabled;
  final TextInputType? keyboardType;
  final void Function(String value)? onChanged;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final List<TextInputFormatter>? maskFormatter;
  final Function()? onTap;
  final String? Function(String?)? validator;
  final List<String>? autofillHints;
  final Function(String)? onFieldSubmitted;


  CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.errorText,
    this.isSecret = false,
    this.isPhone = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.maskFormatter,
    this.onTap,
    this.validator,
    this.autofillHints,
    this.onFieldSubmitted
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isSecret;
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: TextFormField(
        autofillHints: widget.autofillHints,
        onTap: widget.onTap,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        enabled: widget.enabled,
        obscureText: isObscure,
        inputFormatters: widget.maskFormatter,
        onFieldSubmitted: widget.onFieldSubmitted,
        onChanged: widget.onChanged,
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          contentPadding: const EdgeInsets.all(8.0),
          prefixIcon:
          widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
          suffixIcon: widget.isSecret
              ? IconButton(
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
            icon:
            Icon(isObscure ? Icons.visibility : Icons.visibility_off),
          )
              : null,
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}