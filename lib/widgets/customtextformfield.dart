import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final bool readOnly;
  // final filled;
  final TextEditingController controller;
  final TextStyle? hintstyle;

  final String hintText;
  final bool obscureText;
  // final Color?fillColor;
  // final Color?cursorcolor;
  final String? Function(String?)? validator;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final TextStyle?errorStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final type;
  final String? value;
  final TextStyle? style;
  final maxlines;
  final Text?label;
  
  // final TextInputType?keyboardType;
  const CustomTextFormField({
    Key? key,
    this.hintstyle,
    this.errorStyle,
    this.readOnly=false,
    this.style,
    required this.controller,
    this.maxlines=1,
    this.type=TextInputType.text,

    required this.hintText,
    this.obscureText = false,
    // this.cursorcolor,


    this.validator,
    this.enabledBorder,
    this.focusedBorder,
    this.prefixIcon,
    this.suffixIcon,
    this.value,
    this.label,
    // this.keyboardType ,
    // this.filled, this.fillColor,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.value,
      readOnly: widget.readOnly,
      style:Theme.of(context).textTheme.bodySmall ,
      maxLines: widget.maxlines,
      cursorColor: Color(0xffD77272),
      keyboardType: widget.type,


      controller: widget.controller,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Color(0xFFB3261E)),
        hintStyle: TextStyle(color: Colors.black26,fontSize: 12,fontWeight: FontWeight.w600),
        hintText: widget.hintText,
        filled: true,
        fillColor: Color(0xffFFF5E9),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black45)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xffD77272))
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText ? IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ) : widget.suffixIcon,
      ),
      obscureText: widget.obscureText && _obscureText,
      validator: widget.validator,
    );
  }
}
