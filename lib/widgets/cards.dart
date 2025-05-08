import 'package:flutter/material.dart';
import 'package:ibanvault/core/utils/AppColors.dart';
import 'package:ibanvault/core/utils/ImageEnum.dart';
import 'package:ibanvault/data/models/friend_ibans_model.dart';
import 'package:ibanvault/data/models/ibans_model.dart';

class Cards {
  static Widget buildIbanCard({
    required BuildContext context,
    required Iban iban,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required VoidCallback onQrTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      color: AppColors.blue?.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onQrTap,
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
      'Bank: ${iban.bankName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("IBAN: ${iban.ibanNumber}"),
            Text("Date: ${iban.createdAt.split('T').first}"),
          ],
        ),
      trailing: Wrap(
  spacing: 4,
  children: [
    // Edit FAB
    FloatingActionButton.small(
      heroTag: 'edit_${iban.id}',
      onPressed: onEdit,
      backgroundColor: AppColors.success.withOpacity(0.2),
      elevation: 0,
      child: Icon(
        Icons.edit_rounded,
        size: 18,
        color: AppColors.success,
      ),
    ),
    
    // Delete FAB
    FloatingActionButton.small(
      heroTag: 'delete_${iban.id}',
      onPressed: onDelete,
      backgroundColor: AppColors.danger.withOpacity(0.2),
      elevation: 0,
      child: Icon(
        Icons.delete_forever_rounded,
        size: 18,
        color: AppColors.danger,
      ),
    ),
  ],
),
      ),
    );
  }
static Widget buildFriendIbanCard({
    required BuildContext context,
    required FriendIban iban,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required VoidCallback onQrTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      color: AppColors.blue?.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onQrTap,
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
        title: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
      "Friend's Name: ${iban.name}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5,),
            Text(
      'Bank: ${iban.bankName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("IBAN: ${iban.ibanNumber}"),
            Text("Date: ${iban.createdAt.split('T').first}"),
          ],
        ),
        trailing: Wrap(
  spacing: 4,
  children: [
    // Edit FAB
    FloatingActionButton.small(
      heroTag: 'edit_${iban.id}',
      onPressed: onEdit,
      backgroundColor: AppColors.success.withOpacity(0.2),
      elevation: 0,
      child: Icon(
        Icons.edit_rounded,
        size: 18,
        color: AppColors.success,
      ),
    ),
    
    // Delete FAB
    FloatingActionButton.small(
      heroTag: 'delete_${iban.id}',
      onPressed: onDelete,
      backgroundColor: AppColors.danger.withOpacity(0.2),
      elevation: 0,
      child: Icon(
        Icons.delete_forever_rounded,
        size: 18,
        color: AppColors.danger,
      ),
    ),
  ],
),
      ),
    );
  }
  static String _getImagePath(String bankName) {
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
      case 'Albaraka':
        return ImageEnum.AlbarakaTurk.imagePath;
      case 'Türkiye Finans':
        return ImageEnum.turkiyefinans.imagePath;
      default:
        return ImageEnum.logoZiraatBankasi.imagePath;
    }
  }

}
