import 'package:flutter/material.dart';
import 'package:ibanvault/core/utils/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../data/models/ibans_model.dart';
import '../../../providers/Iban_provider.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<IbansProvider>().fetchIbans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ibans = context.watch<IbansProvider>().ibans;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleText(),
          SizedBox(height: 10),
          _buildSubTitleText(),
          Divider(),
          SizedBox(height: 10),

          Expanded(
            child:
                ibans.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning, size: 50, color: AppColors.blue),
                          SizedBox(height: 20),
                          Text(
                            "No IBANs found.",
                            style: TextStyle(
                              fontSize: 30,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: ibans.length,
                      itemBuilder: (context, index) {
                        final iban = ibans[index];
                        return _buildIbanCard(iban);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Text _buildSubTitleText() {
    return Text(
      "Welcome to IABN Vault, your secure and reliable solution for managing your IBANs. ",
      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
    );
  }

  Text _buildTitleText() {
    return Text(
      'Home Page',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.blue,
      ),
    );
  }

  Widget _buildIbanCard(Iban iban) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      color: AppColors.blue?.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppColors.background,
          child: Image.asset('assets/images/logo-ziraat-bankasi.png'),
        ),
        title: Text(
          iban.bankName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("IBAN: ${iban.ibanNumber}"),
            Text("Date: ${iban.createdAt.split('T').first}"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                buildShowBottomSheet(context, iban);
              },
              child: const Icon(Icons.edit, size: 16, color: AppColors.success),
            ),
            SizedBox(width: 10),
            GestureDetector(
              child: const Icon(
                Icons.delete,
                size: 16,
                color: AppColors.danger,
              ),
              onTap: () async {
                await Provider.of<IbansProvider>(
                  context,
                  listen: false,
                ).deleteIban(iban.id!);
                showTopSnackBar(
                  Overlay.of(context),
                  const CustomSnackBar.success(
                    message: 'IBAN deleted successfully!',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void buildShowBottomSheet(BuildContext context, Iban iban) {
    final _formKey = GlobalKey<FormState>();
    String? bankName = iban.bankName;
    String? ibanNumber = iban.ibanNumber;

    showModalBottomSheet(
      backgroundColor: AppColors.grey,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 16,
            right: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit IBAN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  initialValue: bankName,
                  style: const TextStyle(color: Colors.black),

                  decoration: InputDecoration(
                    labelText: 'Bank Name',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: AppColors.black),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter bank name';
                    }
                    return null;
                  },
                  onSaved: (value) => bankName = value,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  initialValue: ibanNumber,
                  style: const TextStyle(color: Colors.black),

                  decoration: const InputDecoration(
                    labelText: 'IBAN Number',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: AppColors.black),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter IBAN';
                    }
                    return null;
                  },
                  onSaved: (value) => ibanNumber = value,
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            final updatedIban = Iban.withId(
                              id: iban.id!,
                              bankName: bankName!,
                              ibanNumber: ibanNumber!,
                              createdAt: iban.createdAt,
                            );
                            await Provider.of<IbansProvider>(
                              context,
                              listen: false,
                            ).updateIban(updatedIban);

                            Navigator.pop(context);
                            showTopSnackBar(
                              Overlay.of(context),
                              const CustomSnackBar.success(
                                message: 'IBAN updated successfully!',
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('IBAN updated successfully!'),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
