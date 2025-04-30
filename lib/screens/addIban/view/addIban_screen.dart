import 'package:flutter/material.dart';
import 'package:ibanvault/providers/Iban_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/utils/AppColors.dart';
import '../../../data/models/ibans_model.dart';
import '../../../widgets.dart';
import 'package:provider/provider.dart'; 

class AddIbanScreen extends StatelessWidget {
  AddIbanScreen({super.key});
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.transparent,

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleText(),
            SizedBox(height: 10),
            _buildSubTitleText(),
            SizedBox(height: 10),
            Divider(),
      
            _buildAddIbanForm(context),
          ],
        ),
      ),
    );
  }

  Text _buildSubTitleText() {
    return Text(
      "Add your IBAN details securely and easilu. ",
      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
    );
  }

  Text _buildTitleText() {
    return Text(
      'Add IBAN Page',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.blue,
      ),
    );
  }

  String? _bankName;
  String? _ibanNumber;
  _buildAddIbanForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New IBAN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomTextFormField(
              labelText: 'Bank Name',
              hintText: 'e.g. Ziraat Bnak',
              icon: const Icon(Icons.person),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              onSaved: (value) => _bankName = value,
            ),
            const SizedBox(height: 16),

            CustomTextFormField(
              labelText: 'IBAN Number',
              hintText: 'e.g. SA0380000000608010167519',
              icon: const Icon(Icons.person),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your IBAN number';
                }
                return null;
              },
              onSaved: (value) => _ibanNumber = value,
            ),

            const SizedBox(height: 24),
            _buildIbanSaveButton(context),
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildIbanSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          final ibanModel = Iban(
            bankName: _bankName!,

            ibanNumber: _ibanNumber!,
            createdAt: DateTime.now().toString(),
          );
          context.read<IbansProvider>().addIban( ibanModel);
showTopSnackBar(
  Overlay.of(context),
  const CustomSnackBar.success(
    message: 'IBAN saved successfully!',
  ),
);

          _formKey.currentState!.reset();
        } else {
          showTopSnackBar(
  Overlay.of(context),
  const CustomSnackBar.success(
    message: 'Failed to save IBAN please try again',
  ),
);

        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
      ),
      child: const Text(
        'Save IBAN',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
