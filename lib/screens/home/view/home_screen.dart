import 'package:flutter/material.dart';
import 'package:ibanvault/core/utils/AppColors.dart';
import 'package:ibanvault/data/banks.dart';
import 'package:ibanvault/data/models/friend_ibans_model.dart';
import 'package:ibanvault/l10n/app_localizations_en.dart';
import 'package:ibanvault/providers/friend_Ibans_provider.dart';
import 'package:ibanvault/widgets/QrDialog.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../data/models/ibans_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/Iban_provider.dart';
import '../../../widgets/cards.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  List<Iban> _filteredIbans = [];
  List<FriendIban> _filteredFriendIbans = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    Future.microtask(() async {
      final Ibansprovider = await context.read<IbansProvider>();
      final friendIbansProvider = await context.read<FriendIbansProvider>();
      print(friendIbansProvider.friendIbans);
      await friendIbansProvider.fetchFriendIbans();
      Ibansprovider.fetchMyIbans().then((_) {
        setState(() {
          _filteredIbans = Ibansprovider.ibans;
          _filteredFriendIbans = friendIbansProvider.friendIbans;
        });
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          TabBar(
            controller: _tabController,
            labelColor: AppColors.blue,
            indicatorColor: AppColors.blue,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.myIbans),
              Tab(text: AppLocalizations.of(context)!.friendsIbans),
            ],
          ),
          SizedBox(height: 10),
          TextField(
            onChanged: (value) {
              final allIbans = context.read<IbansProvider>().ibans;
              final allFriendIbans =
                  context.read<FriendIbansProvider>().friendIbans;
              final search = value.toLowerCase();

              setState(() {
                _filteredIbans =
                    allIbans.where((iban) {
                      return iban.bankName.toLowerCase().contains(search) ||
                          iban.ibanNumber.toLowerCase().contains(search);
                    }).toList();

                _filteredFriendIbans =
                    allFriendIbans.where((iban) {
                      print(iban.name);
                      print(iban.bankName);
                      print(iban.ibanNumber);

                      return iban.name.toLowerCase().contains(search) ||
                          iban.bankName.toLowerCase().contains(search) ||
                          iban.ibanNumber.toLowerCase().contains(search);
                    }).toList();
              });
            },

            controller: _searchController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.search,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildMyIbansTab(), _buildFriendIbansTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyIbansTab() {
    final allIbans = context.watch<IbansProvider>().ibans;
    final filtered = _filteredIbans.isEmpty ? allIbans : _filteredIbans;

    return allIbans.isEmpty || _filteredIbans.isEmpty
        ? Center(child: Text(AppLocalizations.of(context)!.noIbansFound))
        : ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            return _buildIbanCard(filtered[index]);
          },
        );
  }

  Text _buildSubTitleText() {
    return Text(
      AppLocalizations.of(context)!.welcomeMessage,
      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
    );
  }

  Text _buildTitleText() {
    return Text(
      AppLocalizations.of(context)!.homePage,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.blue,
      ),
    );
  }

  Widget _buildFriendIbansTab() {
    final allFriendIbans = context.watch<FriendIbansProvider>().friendIbans;
    final filtered =
        _filteredFriendIbans.isEmpty ? allFriendIbans : _filteredFriendIbans;

    return filtered.isEmpty || _filteredFriendIbans.isEmpty
        ? Center(child: Text(AppLocalizations.of(context)!.noIbansFound))
        : ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            return _buildFrindIbanCard(filtered[index]);
          },
        );
  }

  Widget _buildFrindIbanCard(FriendIban iban) {
    return Cards.buildFriendIbanCard(
      context: context,
      iban: iban,
      onQrTap: () => QR.showQrDialog(context, iban.ibanNumber),
      onEdit: () => buildFrindeShowBottomSheet(context, iban),
      onDelete: () async {
        final provider = Provider.of<FriendIbansProvider>(
          context,
          listen: false,
        );
        await provider.deleteFriendIban(iban.id!);

        setState(() {
          _filteredFriendIbans = provider.friendIbans;
        });
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: AppLocalizations.of(context)!.ibanDeleted,
          ),
        );
      },
    );
  }

  Widget _buildIbanCard(Iban iban) {
    return Cards.buildIbanCard(
      context: context,
      iban: iban,
      onQrTap: () => QR.showQrDialog(context, iban.ibanNumber),
      onEdit: () => buildShowBottomSheet(context, iban),
      onDelete: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder:
              (ctx) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                backgroundColor: AppColors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        size: 48,
                        color: AppColors.danger,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.confirmDeleteTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.background,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.confirmDeleteMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.background,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(color: AppColors.background),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                                style: TextStyle(
                                  color: AppColors.background,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                backgroundColor: AppColors.danger,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text(
                                AppLocalizations.of(context)!.delete,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        );

        if (confirmed == true) {
          await Provider.of<IbansProvider>(
            context,
            listen: false,
          ).deleteMyIban(iban.id!);

          final updatedIbans = context.read<IbansProvider>().ibans;
          setState(() {
            _filteredIbans = updatedIbans;
          });

          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: AppLocalizations.of(context)!.ibanDeleted,
            ),
          );
        }
      },
    );
  }

  void buildFrindeShowBottomSheet(BuildContext context, FriendIban iban) {
    final _formKey = GlobalKey<FormState>();
    String? bankName = iban.bankName;
    String? ibanNumber = iban.ibanNumber;
    String? friendName = iban.name;

    bool _isCustomBank =
        bankName != null && !Banks.turkishBanks.contains(bankName);
    final TextEditingController _customBankController = TextEditingController(
      text: _isCustomBank ? bankName : '',
    );

    showModalBottomSheet(
      backgroundColor: Color(0xFF2F3542),
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                  children: [
                    Text(
                      AppLocalizations.of(context)!.editFriendIban,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: friendName,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.friendNameLabel,
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (val) =>
                              val == null || val.isEmpty
                                  ? AppLocalizations.of(
                                    context,
                                  )!.pleaseEnterFriendName
                                  : null,
                      onSaved: (val) => friendName = val,
                    ),
                    const SizedBox(height: 16),
                    _buildDynamicBankDropdown(
                      context: context,
                      value: bankName,
                      isCustomBank: _isCustomBank,
                      customBankController: _customBankController,
                      onChanged: (val) {
                        setModalState(() {
                          if (val == 'other') {
                            _isCustomBank = true;
                            bankName = null;
                          } else {
                            _isCustomBank = false;
                            bankName = val;
                            _customBankController.clear();
                          }
                        });
                      },
                      onSaved: (val) {
                        bankName =
                            _isCustomBank
                                ? _customBankController.text.trim()
                                : val;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: ibanNumber,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.ibanNumber,
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.credit_card_rounded,
                          color: Colors.white,
                        ),

                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (val) =>
                              val == null || val.isEmpty
                                  ? AppLocalizations.of(
                                    context,
                                  )!.pleaseEnterIban
                                  : null,
                      onSaved: (val) => ibanNumber = val,
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
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
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

                                final updatedIban = FriendIban.withId(
                                  id: iban.id!,
                                  bankName: bankName!,
                                  name: friendName!,
                                  ibanNumber: ibanNumber!,
                                  createdAt: iban.createdAt,
                                );

                                final provider =
                                    Provider.of<FriendIbansProvider>(
                                      context,
                                      listen: false,
                                    );

                                await provider.updateFriendIban(updatedIban);
                                setState(() {
                                  _filteredFriendIbans = provider.friendIbans;
                                });
                                Navigator.pop(context);
                                showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.success(
                                    message:
                                        AppLocalizations.of(
                                          context,
                                        )!.ibanUpdated,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.save,
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
      },
    );
  }

  void buildShowBottomSheet(BuildContext context, Iban iban) {
    final _formKey = GlobalKey<FormState>();
    String? _bankName = iban.bankName;
    String? ibanNumber = iban.ibanNumber;
    bool _isCustomBank =
        _bankName != null && !Banks.turkishBanks.contains(_bankName);
    final TextEditingController _customBankController = TextEditingController(
      text: _isCustomBank ? _bankName : '',
    );

    showModalBottomSheet(
      backgroundColor: Color(0xFF2F3542),
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                  children: [
                    _buildDynamicBankDropdown(
                      context: context,
                      value: _bankName,
                      isCustomBank: _isCustomBank,
                      customBankController: _customBankController,
                      onChanged: (val) {
                        setModalState(() {
                          if (val == 'other') {
                            _isCustomBank = true;
                            _bankName = null;
                          } else {
                            _isCustomBank = false;
                            _bankName = val;
                            _customBankController.clear();
                          }
                        });
                      },
                      onSaved: (val) {
                        _bankName =
                            _isCustomBank
                                ? _customBankController.text.trim()
                                : val;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: ibanNumber,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                            prefixIcon: Icon(Icons.credit_card_rounded, color: Colors.white), 

                        labelText: AppLocalizations.of(context)!.ibanNumber,
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (val) =>
                              val == null || val.isEmpty
                                  ? AppLocalizations.of(
                                    context,
                                  )!.pleaseEnterIban
                                  : null,
                      onSaved: (val) => ibanNumber = val,
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
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
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
                                  bankName: _bankName!,
                                  ibanNumber: ibanNumber!,
                                  createdAt: iban.createdAt,
                                );
                                final provider = Provider.of<IbansProvider>(
                                  context,
                                  listen: false,
                                );
                                await provider.updateIban(updatedIban);
                                setState(() {
                                  _filteredIbans = provider.ibans;
                                });
                                Navigator.pop(context);
                                showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.success(
                                    message:
                                        AppLocalizations.of(context)!.ibanUpdated,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.save,
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
      },
    );
  }

  Widget _buildDynamicBankDropdown({
    required BuildContext context,
    required String? value,
    required bool isCustomBank,
    required TextEditingController customBankController,
    required Function(String?) onChanged,
    required Function(String?) onSaved,
  }) {
    List<String> banks = List<String>.from(Banks.turkishBanks);
    if (value != null && !banks.contains(value)) banks.insert(0, value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          value: isCustomBank ? 'other' : value,
          dropdownColor: Color(0xFF1C1F26),
          iconEnabledColor: AppColors.background,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.bankName,
            labelStyle: const TextStyle(color: Colors.white),
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.account_balance, color: Colors.white),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
          ),
          items: [
            DropdownMenuItem(
              value: 'other',
              child: Text(
                AppLocalizations.of(context)!.anotherbank,
                style: TextStyle(color: AppColors.blue),
              ),
            ),
            ...banks.map(
              (bank) => DropdownMenuItem<String>(
                value: bank,
                child: Text(bank, style: const TextStyle(color: Colors.white)),
              ),
            ),
          ],
          onChanged: onChanged,
          onSaved: onSaved,
          validator: (val) {
            if (!isCustomBank && (val == null || val.isEmpty)) {
              return AppLocalizations.of(context)!.pleaseSelectBank;
            }
            if (isCustomBank && customBankController.text.trim().isEmpty) {
              return AppLocalizations.of(context)!.pleaseEnterBankName;
            }
            return null;
          },
        ),
        if (isCustomBank)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextFormField(
              controller: customBankController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.bankName,
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.edit, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
