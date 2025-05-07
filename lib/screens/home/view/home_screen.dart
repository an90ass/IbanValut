import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibanvault/core/utils/AppColors.dart';
import 'package:ibanvault/core/utils/ImageEnum.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
  final TextEditingController _searchController = TextEditingController();

  List<Iban> _filteredIbans = [];
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final Ibansprovider = context.read<IbansProvider>();
      Ibansprovider.fetchIbans().then((_) {
        setState(() {
          _filteredIbans = Ibansprovider.ibans;
        });
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allIbans = context.read<IbansProvider>().ibans;
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
          TextField(
            onChanged: (value) {
              setState(() {
                _filteredIbans =
                    allIbans.where((iban) {
                      final search = value.toLowerCase();
                      return iban.bankName.toLowerCase().contains(search) ||
                          iban.ibanNumber.toLowerCase().contains(search);
                    }).toList();
              });
            },

            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search..',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),

          Expanded(
            child:
                allIbans.isEmpty || _filteredIbans.isEmpty
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
                      itemCount: _filteredIbans.length,
                      itemBuilder: (context, index) {
                        final iban = _filteredIbans[index];
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
        onTap: () => _showQrDialog(context, iban.ibanNumber),

        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
  radius: 30, 
  backgroundColor: AppColors.background,
  child: Padding(
    padding: const EdgeInsets.all(4.0), 
    child: Image.asset(
      _getImagePath(iban.bankName),
      width: 40,
      height: 40,
      fit: BoxFit.contain,
    ),
  ),
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

  void _showQrDialog(BuildContext context, String ibanText) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white, // Use your background color
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'IBAN QR Code',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 203, 201, 201),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            ibanText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () async {
                            await Clipboard.setData(
                              (ClipboardData(text: ibanText)),
                            );
                            showTopSnackBar(
                              Overlay.of(context),
                              const CustomSnackBar.success(
                                message: 'IBAN copied Successfuly',
                              ),
                            );
                          },
                          child: Icon(Icons.copy, color: AppColors.background),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFB0C4DE),
                        width: 2,
                      ),
                    ),
                    child: QrImageView(
                      backgroundColor: Colors.white,
                      data: ibanText,
                      version: QrVersions.auto,
                      size: 180.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
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
  
String _getImagePath(String bankName) {
  switch (bankName) {
    case 'Ziraat Bankası':
      return ImageEnum.logoZiraatBankasi.imagePath;
    case 'Halkbank':
      return ImageEnum.halkbank.imagePath;
    case 'VakıfBank':
      return ImageEnum.vakifbank.imagePath;
    case 'İş Bankası':
      return ImageEnum.turkiyeIsBankasi.imagePath;
    case 'Garanti BBVA':
      return ImageEnum.GarantiBBVA.imagePath;
    case 'Yapı Kredi':
      return ImageEnum.yapikredibankasi.imagePath;
    case 'Akbank':
      return ImageEnum.Akbank.imagePath;
    case 'QNB Finansbank':
      return ImageEnum.qnbFinansbank.imagePath;
    case 'DenizBank':
      return ImageEnum.denizBank.imagePath;
    case 'TEB':
      return ImageEnum.tebLogo.imagePath;
    case 'Şekerbank':
      return ImageEnum.sekerbank.imagePath;
    case 'Kuveyt Türk':
      return ImageEnum.KuveytTurk.imagePath;
    case 'Albaraka Türk':
      return ImageEnum.AlbarakaTurk.imagePath;
    case 'Türkiye Finans':
      return ImageEnum.turkiyefinans.imagePath;
    default:
      return ImageEnum.logoZiraatBankasi.imagePath; 
  }
}


}
