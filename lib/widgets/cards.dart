import 'package:flutter/material.dart';
import 'package:ibanvault/core/utils/AppColors.dart';
import 'package:ibanvault/core/utils/ImageEnum.dart';
import 'package:ibanvault/data/models/friend_ibans_model.dart';
import 'package:ibanvault/data/models/ibans_model.dart';
import 'package:ibanvault/l10n/app_localizations.dart';

class Cards {
static Widget buildIbanCard({
  required BuildContext context,
  required Iban iban,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
  required VoidCallback onQrTap,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.blue!.withOpacity(0.7), Colors.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildBankLogo(iban.bankName),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      iban.bankName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      _buildActionIcon(onEdit, Icons.edit, Colors.greenAccent,16),
                      const SizedBox(width: 8),
                      _buildActionIcon(onDelete, Icons.delete, Colors.redAccent,16),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              _buildInfoItem(
                context,
                icon: Icons.credit_card_rounded,
                label: AppLocalizations.of(context)!.ibanNumber,
                value: iban.ibanNumber,
              ),
              const SizedBox(height: 12),
              _buildInfoItem(
                context,
                icon: Icons.calendar_today_rounded,
                label: AppLocalizations.of(context)!.dateLabel,
                value: iban.createdAt,
              ),
              const SizedBox(height: 40), // reserve space for QR button
            ],
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: _buildActionIcon(onQrTap, Icons.qr_code_rounded, Colors.blueAccent,50),
        ),
      ],
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
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.blue!.withOpacity(0.7), Colors.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.background,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        _getImagePath(iban.bankName),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          iban.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          iban.bankName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildActionIcon(onEdit, Icons.edit, Colors.greenAccent,16),
                      const SizedBox(width: 8),
                      _buildActionIcon(onDelete, Icons.delete, Colors.redAccent,16),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              _buildInfoItem(
                context,
                icon: Icons.credit_card_rounded,
                label: AppLocalizations.of(context)!.ibanNumber,
                value: iban.ibanNumber,
              ),
              const SizedBox(height: 12),
              _buildInfoItem(
                context,
                icon: Icons.calendar_today_rounded,
                label: AppLocalizations.of(context)!.dateLabel,
                value: iban.createdAt.split('T').first,
              ),
              const SizedBox(height: 40), // reserve space for QR button
            ],
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: _buildActionIcon(onQrTap, Icons.qr_code_rounded, Colors.blueAccent,50),
        ),
      ],
    ),
  );
} static Widget _buildBankLogo(String bankName) {
    return  CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.background,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              _getImagePath(bankName),
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        );
  }

  static Widget _buildInfoItem(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.white70,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.white60),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

static Widget _buildQuickActions(
    VoidCallback onEdit, VoidCallback onDelete, VoidCallback onQrTap) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          _buildActionIcon(onEdit, Icons.edit_rounded, Colors.greenAccent,1),
          const SizedBox(width: 8),
          _buildActionIcon(onDelete, Icons.delete_rounded, Colors.redAccent,1),
        ],
      ),
      _buildActionIcon(onQrTap, Icons.qr_code_rounded, Colors.blueAccent,1),
    ],
  );
}


  static Widget _buildActionIcon(VoidCallback onTap, IconData icon, Color color,double size) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: size
          ,
          color: color,
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
        return ImageEnum.defult.imagePath;
    }
  }
}
