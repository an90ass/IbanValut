import 'package:flutter/material.dart';
import 'package:ibanvault/l10n/app_localizations.dart';
import 'package:ibanvault/providers/language_provider.dart';
import 'package:ibanvault/widgets.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/AppColors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         _buildTitleText(context),
         const SizedBox(height: 10,),
         Center(
          child: Column(

            children: [
              _buildChangeLanguageButton(context),
            ],
          ),
         )
        ],
      ),
    );
  }
  
  Text _buildTitleText(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.settingsScreen,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.blue,
      ),
    );
  }
  
Widget _buildChangeLanguageButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      icon: Icon(Icons.language_outlined,size: 25,color: Colors.white,),
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
        ),
        label:  Text(
          AppLocalizations.of(context)!.changeLanguage,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      onPressed: () {
        _showLanguageBottomSheet(context);
      },
    ),
  );
}
void _showLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      final currentLanguage = languageProvider.locale?.languageCode;

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
  gradient: AppColors.gradientBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                AppLocalizations.of(context)!.selectLanguage,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
             Divider(height:3, color: AppColors.grey),
            _buildLanguageTile(
              context: context,
              languageCode: 'en',
              languageName: AppLocalizations.of(context)!.english,
              flag: '🇬🇧',
              isSelected: currentLanguage == 'en',
              onTap: () {
                languageProvider.changeLanguage( 'en');
                Navigator.pop(context);
              },
            ),
            _buildLanguageTile(
              context: context,
              languageCode: 'tr',
              languageName: AppLocalizations.of(context)!.turkish,
              flag: '🇹🇷',
              isSelected: currentLanguage == 'tr',
              onTap: () {
                languageProvider.changeLanguage('tr');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

Widget _buildLanguageTile({
  required BuildContext context,
  required String languageCode,
  required String languageName,
  required String flag,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
      borderRadius: BorderRadius.circular(12),
      border: isSelected 
          ? Border.all(color: AppColors.primary, width: 1) 
          : null,
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.background,
          shape: BoxShape.circle,
        ),
        child: Text(
          flag,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      title: Text(
        languageName,
        style: TextStyle(
          fontSize: 16,
          color: isSelected ? AppColors.primary : AppColors.background,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

}
