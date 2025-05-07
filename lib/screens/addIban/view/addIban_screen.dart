import 'package:flutter/material.dart';
import 'package:ibanvault/data/banks.dart';
import 'package:ibanvault/data/models/friend_ibans_model.dart';
import 'package:ibanvault/providers/Iban_provider.dart';
import 'package:ibanvault/providers/friend_Ibans_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/utils/AppColors.dart';
import '../../../data/models/ibans_model.dart';
import '../../../widgets.dart';
import 'package:provider/provider.dart';

class AddIbanScreen extends StatefulWidget {
  AddIbanScreen({super.key});

  @override
  State<AddIbanScreen> createState() => _AddIbanScreenState();
}

class _AddIbanScreenState extends State<AddIbanScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _myIbanFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _friendIbanFormKey = GlobalKey<FormState>();

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.blue,
              labelColor: AppColors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: const [Tab(text: 'My IBAN'), Tab(text: 'Friend\'s IBAN')],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMyIbanForm(context),
                  _buildFriendIbanForm(context),
                ],
              ),
            ),
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

  _buildMyIbanForm(BuildContext context) {
    return Form(
      key: _myIbanFormKey,
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

            DropdownButtonFormField<String>(
              value: _bankName,
              dropdownColor: AppColors.primary,
              decoration: const InputDecoration(
                fillColor: Colors.red,
                labelText: 'Bank Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_balance),
              ),
              items:
                  Banks.turkishBanks.map((bank) {
                    return DropdownMenuItem<String>(
                      value: bank,
                      child: Text(bank),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _bankName = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a bank';
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
            _buildMyIbanSaveButton(context),
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildMyIbanSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_myIbanFormKey.currentState!.validate()) {
          _myIbanFormKey.currentState!.save();

          final ibanModel = Iban(
            bankName: _bankName!,

            ibanNumber: _ibanNumber!,
            createdAt: DateTime.now().toString(),
          );
          context.read<IbansProvider>().addMyIban(ibanModel);
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(message: 'IBAN saved successfully!'),
          );
          setState(() {
            _bankName = null;
          });
          _myIbanFormKey.currentState!.reset();
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

  String? _friendName;
  String? _friendBankName;
  String? _friendIbanNumber;

  Widget _buildFriendIbanForm(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _friendIbanFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add Friend\'s IBAN',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              CustomTextFormField(
                labelText: 'Friend\'s Name',
                hintText: 'e.g. Ahmed Yılmaz',
                icon: const Icon(Icons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your friend\'s name';
                  }
                  return null;
                },
                onSaved: (value) => _friendName = value,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _friendBankName,
                dropdownColor: AppColors.primary,
                decoration: const InputDecoration(
                  labelText: 'Bank Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance),
                ),
                items:
                    Banks.turkishBanks.map((bank) {
                      return DropdownMenuItem<String>(
                        value: bank,
                        child: Text(bank),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _friendBankName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a bank';
                  }
                  return null;
                },
                onSaved: (value) => _friendBankName = value,
              ),

              const SizedBox(height: 16),

              CustomTextFormField(
                labelText: 'IBAN Number',
                hintText: 'e.g. TR0000000000000000000000',
                icon: const Icon(Icons.numbers),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the IBAN number';
                  }
                  return null;
                },
                onSaved: (value) => _friendIbanNumber = value,
              ),

              const SizedBox(height: 24),
              _buildFriendIbanSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildFriendIbanSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_friendIbanFormKey.currentState!.validate()) {
          _friendIbanFormKey.currentState!.save();

          final ibanModel = FriendIban(
            bankName: _friendBankName!,
            ibanNumber: _friendIbanNumber!,
            createdAt: DateTime.now().toString(),
            name: _friendName!,
          );
          print(ibanModel.name);
          print(ibanModel.ibanNumber);
          context.read<FriendIbansProvider>().addFriendIban(ibanModel);
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(message: 'IBAN saved successfully!'),
          );
          setState(() {
            _bankName = null;
          });
          _friendIbanFormKey.currentState!.reset();
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
