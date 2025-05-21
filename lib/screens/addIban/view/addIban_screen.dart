import 'package:flutter/material.dart';
import 'package:ibanvault/data/banks.dart';
import 'package:ibanvault/data/models/friend_ibans_model.dart';
import 'package:ibanvault/l10n/app_localizations.dart';
import 'package:ibanvault/providers/Iban_provider.dart';
import 'package:ibanvault/providers/friend_Ibans_provider.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/utils/AppColors.dart';
import '../../../data/models/ibans_model.dart';
import '../../../widgets.dart';
import 'package:provider/provider.dart';

import '../../../widgets/QR_Scanner.dart';

class AddIbanScreen extends StatefulWidget {
  AddIbanScreen({super.key});

  @override
  State<AddIbanScreen> createState() => _AddIbanScreenState();
}

class _AddIbanScreenState extends State<AddIbanScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _myIbanFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _friendIbanFormKey = GlobalKey<FormState>();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _friendibanController = TextEditingController();

  late TabController _tabController;
  bool _isCustomBank = false;
final TextEditingController _customBankController = TextEditingController();
  bool _isCustomFriendBank = false;
final TextEditingController _customFriendBankController = TextEditingController();
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
          tabs:  [
  Tab(text: AppLocalizations.of(context)!.myIbans),
  Tab(text: AppLocalizations.of(context)!.friendsIbans),
],            ),
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
      AppLocalizations.of(context)!.addIbanSubtitle,
      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
    );
  }

  Text _buildTitleText() {
    return Text(
      AppLocalizations.of(context)!.addIbanPage,
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
                   AppLocalizations.of(context)!.addNewIban,

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            DropdownButtonFormField<String>(
value: _isCustomBank ? 'other' : _bankName,
  dropdownColor: AppColors.primary,
  decoration: InputDecoration(
    labelText: AppLocalizations.of(context)!.bankName,
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.account_balance),
  ),
  items: [
     DropdownMenuItem<String>(
      value: 'other',
      child: Text(AppLocalizations.of(context)!.anotherbank,style: TextStyle(color: AppColors.secondary)),
    ),
    ...Banks.turkishBanks.map((bank) {
      return DropdownMenuItem<String>(
        value: bank,
        child: Text(bank),
      );
    }).toList(),
  ],
  onChanged: (value) {
    setState(() {
      if (value == 'other') {
        _isCustomBank = true;
        _bankName = null;
      } else {
        _isCustomBank = false;
        _bankName = value;
      }
    });
  },
  validator: (value) {
    if (!_isCustomBank && (value == null || value.isEmpty)) {
      return AppLocalizations.of(context)!.pleaseSelectBank;
    }
    return null;
  },
  onSaved: (value) {
    if (!_isCustomBank) _bankName = value;
  },
),
if (_isCustomBank)
  Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: CustomTextFormField(
      controller: _customBankController,
      labelText: AppLocalizations.of(context)!.bankName,
      hintText: AppLocalizations.of(context)!.bankName,
      icon: const Icon(Icons.edit),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.pleaseEnterBankName;
        }
        return null;
      },
      onSaved: (value) => _bankName = value,
    ),
  ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: _ibanController,
                    labelText: AppLocalizations.of(context)!.ibanNumber,
                    hintText: AppLocalizations.of(context)!.ibanHint,
                    icon: const Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.pleaseEnterIban;
                      }
                      return null;
                    },
                    onSaved: (value) => _ibanNumber = value,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                    onPressed: () async {
                      final result = await showQrScannerDialog(context);
                      if (result != null) {
                        _ibanController.text = result;
                      }
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            _buildMyIbanSaveButton(context),
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildMyIbanSaveButton(BuildContext context) {
    final iban_provider = Provider.of<IbansProvider>(context,listen: false);
    return ElevatedButton(
      onPressed: ()async {
        if (_myIbanFormKey.currentState!.validate()) {
          _myIbanFormKey.currentState!.save();

          final ibanModel = Iban(
            bankName: _bankName!,

            ibanNumber: _ibanNumber!,
createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          );
         await iban_provider.addMyIban(ibanModel);
          if(iban_provider.successMessage !=null){
 showTopSnackBar(
            Overlay.of(context),
             CustomSnackBar.success(message: AppLocalizations.of(context)!.ibanSaveSuccess),
          );
          setState(() {
            _bankName = null;
          });
          _myIbanFormKey.currentState!.reset();
          }
         
         else {
          showTopSnackBar(
            Overlay.of(context),
             CustomSnackBar.error(
              message: AppLocalizations.of(context)!.ibanSaveFailed,
            ),
          );
        }
    }  },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
      ),
      child:  Text(
         iban_provider.isLoading ? AppLocalizations.of(context)!.pleaseWait: AppLocalizations.of(context)!.saveIban,
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
                AppLocalizations.of(context)!.addFriendIban,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              CustomTextFormField(
                labelText: AppLocalizations.of(context)!.friendNameLabel,
                hintText:  AppLocalizations.of(context)!.friendNameHint,
                icon: const Icon(Icons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.pleaseEnterFriendName;
                  }
                  return null;
                },
                onSaved: (value) => _friendName = value,
              ),

              const SizedBox(height: 16),

                 DropdownButtonFormField<String>(
value: _isCustomFriendBank ? 'other' : _friendBankName,
  dropdownColor: AppColors.primary,
  decoration: InputDecoration(
    labelText: AppLocalizations.of(context)!.bankName,
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.account_balance),
  ),
  items: [
     DropdownMenuItem<String>(
      value: 'other',
      child: Text(AppLocalizations.of(context)!.anotherbank,style: TextStyle(color: AppColors.secondary),),
    ),
    ...Banks.turkishBanks.map((bank) {
      return DropdownMenuItem<String>(
        value: bank,
        child: Text(bank),
      );
    }).toList(),
  ],
  onChanged: (value) {
    setState(() {
      if (value == 'other') {
        _isCustomFriendBank = true;
        _friendBankName  = null;
      } else {
        _isCustomFriendBank = false;
        _friendBankName  = value;
      }
    });
  },
  validator: (value) {
    if (!_isCustomFriendBank && (value == null || value.isEmpty)) {
      return AppLocalizations.of(context)!.pleaseSelectBank;
    }
    return null;
  },
  onSaved: (value) {
    if (!_isCustomFriendBank) _friendBankName  = value;
  },
),
if (_isCustomFriendBank)
  Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: CustomTextFormField(
      controller: _customFriendBankController,
      labelText: AppLocalizations.of(context)!.bankName,
      hintText:AppLocalizations.of(context)!.bankName,
      icon: const Icon(Icons.edit),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.pleaseEnterBankName;
        }
        return null;
      },
      onSaved: (value) => _friendBankName  = value,
    ),
  ),

            const SizedBox(height: 16),
  const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: _friendibanController,
                      labelText: AppLocalizations.of(context)!.ibanNumber,
                      hintText: AppLocalizations.of(context)!.ibanHint,
                      icon: const Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.pleaseEnterIban;
                        }
                        return null;
                      },
onSaved: (value) => _friendIbanNumber = value,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                      onPressed: () async {
                        final result = await showQrScannerDialog(context);
                        if (result != null) {
                          _friendibanController.text = result;
                        }
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _buildFriendIbanSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendIbanSaveButton(BuildContext context) {
    return Consumer<FriendIbansProvider>(
      builder: (context, friendIbansProvider, child){

     
     return ElevatedButton(
        onPressed: () async{
          if (_friendIbanFormKey.currentState!.validate()) {
            _friendIbanFormKey.currentState!.save();
      
            final ibanModel = FriendIban(
 bankName: _isCustomFriendBank
      ? _customFriendBankController.text.trim()
      : _friendBankName!,              ibanNumber: _friendIbanNumber!,
createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
              name: _friendName!,
            );
            print(ibanModel.name);
            print(ibanModel.ibanNumber);
           await friendIbansProvider.addFriendIban(ibanModel);
           if(friendIbansProvider.successMessage!=null){
              showTopSnackBar(
              Overlay.of(context),
               CustomSnackBar.success(message: AppLocalizations.of(context)!.ibanSaveSuccess),
            );
            setState(() {
              _bankName = null;
            });
            _friendIbanFormKey.currentState!.reset();
           }
          
           else {
            showTopSnackBar(
              Overlay.of(context),
               CustomSnackBar.error(
                message: AppLocalizations.of(context)!.ibanSaveFailed,
              ),
            );
          }
       } },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
        ),
        child:  Text(
         friendIbansProvider.isLoading ? AppLocalizations.of(context)!.pleaseWait: AppLocalizations.of(context)!.saveIban,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
     });
  }

  Future<String?> showQrScannerDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: 300,
            height: 400,
            child: QrScannerDialogContent(),
          ),
        );
      },
    );
  }
}
