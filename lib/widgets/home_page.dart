import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
_buildTitleText()   ,
       SizedBox(height: 10),
          _buildSubTitleText(),
        ],
      ),
    );
  }
  Text _buildSubTitleText() {
    return  Text(
      "Welcome to Iban Vault, your secure and reliable solution for managing your IBANs. ",
      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
    );
  }
  Text _buildTitleText() {
    return const Text(
      'Home Page',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}