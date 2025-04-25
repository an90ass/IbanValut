import 'package:flutter/material.dart';
import 'package:ibanvault/core/utils/AppColors.dart';
import 'package:ibanvault/providers/fetchIbans_provider.dart';
import 'package:provider/provider.dart';

import '../../../data/models/ibans_model.dart';

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
    context.read<FetchibansProvider>().fetchIbans();
  });
}

  @override
  Widget build(BuildContext context) {
        final ibans = context.watch<FetchibansProvider>().ibans;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
_buildTitleText()   ,
       SizedBox(height: 10),
          _buildSubTitleText(),
          Divider(),
                 SizedBox(height: 10),

          Expanded(
            child: ibans.isEmpty
                ?  Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning,size: 50,color: AppColors.blue,),
                    SizedBox(height: 20,),
                    Text("No IBANs found.",
                    style: TextStyle(fontSize: 30,fontStyle: FontStyle.italic),),
                  ],
                ))
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
    return  Text(
      "Welcome to IABN Vault, your secure and reliable solution for managing your IBANs. ",
      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
    );
  }

  Text _buildTitleText() {
    return  Text(
      'Home Page',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: AppColors.blue),
    );
  }

  Widget _buildIbanCard(Iban iban) {
    return Card(
      
      margin:  EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      color: AppColors.blue?.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppColors.blue
          
            ,
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
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}