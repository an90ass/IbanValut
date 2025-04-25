import 'package:flutter/material.dart';

mixin IbanFormMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController ibanController = TextEditingController();

  void disposeFormControllers() {
    bankNameController.dispose();
    ibanController.dispose();
  }
}
