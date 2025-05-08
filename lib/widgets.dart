import 'package:flutter/material.dart';

import 'core/utils/AppColors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
        colors: [
          Color(0xFF1C1F26), 
          Color(0xFF2F3542), 
        ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
    backgroundColor: Colors.transparent, 
    
      title: const Text('IBAN VAULT'),
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize:30,
        fontWeight: FontWeight.bold
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40))
      ),
    );
  }
}
class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Icon icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final FormFieldSetter<String>? onSaved;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.icon,
    this.controller,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
            style: const TextStyle(color:Colors.white), 

      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
      onSaved: onSaved,
    );
  }
}