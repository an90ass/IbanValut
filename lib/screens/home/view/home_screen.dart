import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibanvault/core/utils/AppColors.dart';
import 'package:ibanvault/data/banks.dart';
import 'package:ibanvault/data/models/friend_ibans_model.dart';
import 'package:ibanvault/providers/friend_Ibans_provider.dart';
import 'package:ibanvault/widgets/QrDialog.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../data/models/ibans_model.dart';
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
            tabs: const [Tab(text: "My IBANs"), Tab(text: "Friends IBANs")],
          ),
          SizedBox(height: 10),
          TextField(
           onChanged: (value) {
  final allIbans = context.read<IbansProvider>().ibans;
  final allFriendIbans = context.read<FriendIbansProvider>().friendIbans;
  final search = value.toLowerCase();
  
  setState(() {
    _filteredIbans = allIbans.where((iban) {
      return iban.bankName.toLowerCase().contains(search) ||
             iban.ibanNumber.toLowerCase().contains(search);
    }).toList();

    _filteredFriendIbans = allFriendIbans.where((iban) {
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
            decoration: const InputDecoration(
              labelText: 'Search...',
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
        ? Center(child: Text("No IBANs found."))
        : ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            return _buildIbanCard(filtered[index]);
          },
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

  Widget _buildFriendIbansTab() {
  final allFriendIbans = context.watch<FriendIbansProvider>().friendIbans;
  final filtered = _filteredFriendIbans.isEmpty ? allFriendIbans : _filteredFriendIbans;

  return filtered.isEmpty || _filteredFriendIbans.isEmpty
      ? Center(child: Text("No IBANs found."))
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
      const CustomSnackBar.success(
        message: 'IBAN deleted successfully!',
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
      const CustomSnackBar.success(
        message: 'IBAN deleted successfully!',
      ),
    );
  },
)
;
  }

  
  void buildFrindeShowBottomSheet(BuildContext context, FriendIban iban) {
    print(iban.ibanNumber);
    final _formKey = GlobalKey<FormState>();
    String? bankName = iban.bankName;
    String? ibanNumber = iban.ibanNumber;
    String? friendName = iban.name;
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
                  'Edit Friends IBAN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 20),
 TextFormField(
                  initialValue: friendName,
                  style: const TextStyle(color: Colors.black),

                  decoration: InputDecoration(
labelText: 'Friend\'s Name:',
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
                  onSaved: (value) => friendName  = value,
                ),

                const SizedBox(height: 16),
                _buildDropDownBanks(
                value: bankName,
                onChanged: (val) {
                  bankName = val;
                },
                onSaved: (val) {
                  bankName = val;
                },
              ) ,

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

                            final updatedIban = FriendIban.withId(
                              id: iban.id!,
                              bankName: bankName!,
                              name: friendName!,
                              ibanNumber: ibanNumber!,
                              createdAt: iban.createdAt,
                            );
                           final provider=  await Provider.of<FriendIbansProvider>(
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

  void buildShowBottomSheet(BuildContext context, Iban iban) {
    final _formKey = GlobalKey<FormState>();
    String? _bankName = iban.bankName;
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

_buildDropDownBanks(
                value: _bankName,
                onChanged: (val) {
                  _bankName = val;
                },
                onSaved: (val) {
                  _bankName = val;
                },
              )     ,           const SizedBox(height: 16),

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
                              bankName: _bankName!,
                              ibanNumber: ibanNumber!,
                              createdAt: iban.createdAt,
                            );
                           final provider=  await Provider.of<IbansProvider>(
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
  
 Widget _buildDropDownBanks({
  required String? value,
  required Function(String?) onChanged,
  required Function(String?) onSaved,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    decoration: const InputDecoration(
      labelText: 'Bank Name',
      border: OutlineInputBorder(),
      prefixIcon: Icon(Icons.account_balance),
    ),
    items: Banks.turkishBanks.map((bank) {
      return DropdownMenuItem<String>(
        value: bank,
        child: Text(bank),
      );
    }).toList(),
    onChanged: onChanged,
    validator: (val) => val == null || val.isEmpty ? 'Please select a bank' : null,
    onSaved: onSaved,
  );
}



    }
