import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// import 'package:flutter_localizations/flutter_localizations.dart';

import '../../theme.dart';
import 'app_localization.dart';

SharedPreferences? preferences;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // late SharedPreferences _prefs;

  // Default values for language and theme options
  String _selectedLanguage = 'en';
  String _selectedTheme = 'default';

  Future getColor() async {
    preferences = await SharedPreferences.getInstance();
    // int idx = Color(preferences!.getInt('color') ?? 0xFF000000);
    int? idx = preferences!.getInt('color');
    primaryColor = getColorIndex(idx!);
    print('Color taken from saved instance.');
    return primaryColor;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // _loadPreferences();
    getColor();
  }

  // void _changeLanguage(String languageCode) {
  //   // Locale _locale = Locale(languageCode);
  //   // AppLocalization.load(_locale).then((value) {
  //   //   setState(() {});
  //   // });
  //   Locale newLocale = Locale(languageCode);
  //   AppLocalization.of(context)!.changeLocale(newLocale);

  //   setState(() {
  //     _selectedLanguage = languageCode;
  //   });
  // }

  void _changeLanguage(String languageCode) {
    AppLocalization appLocalization = context.read<AppLocalization>();
    appLocalization.changeLocale(Locale(languageCode));

    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  // Future setColor(int idx) async {
  //   await preferences!.setInt('color', idx);
  // }

  Future setColor(int idx) async {
    await preferences!.setInt('color', idx);
    setState(() {
      primaryColor = getColorIndex(idx);
    });
  }

  // Load user preferences from shared preferences
  // Future<void> _loadPreferences() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _selectedLanguage = _prefs.getString('language') ?? 'en';
  //     _selectedTheme = _prefs.getString('theme') ?? 'default';
  //   });
  // }

  // Update user preferences and save to shared preferences
  // Future<void> _updatePreferences(String language, String theme) async {
  //   await _prefs.setString('language', language);
  //   await _prefs.setString('theme', theme);
  //   setState(() {
  //     _selectedLanguage = language;
  //     _selectedTheme = theme;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (newValue) {
                if (newValue == 'ur') {
                  _changeLanguage(newValue!);
                  preferences!.setString('language', newValue!);
                } else {
                  // Handle other languages if needed
                }
                // _updatePreferences(newValue!, _selectedTheme);
                // _changeLanguage(newValue!);
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
              items: [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ur', child: Text('Urdu')),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedTheme,
              onChanged: (newValue) {
                // _updatePreferences(_selectedLanguage, newValue!);
                if (newValue == 'green') {
                  setColor(1); // Set theme color to green
                } else {
                  setColor(0); // Set theme color to default
                }
                setState(() {
                  _selectedTheme = newValue!;
                });
              },
              items: [
                DropdownMenuItem(value: 'default', child: Text('Default')),
                DropdownMenuItem(value: 'green', child: Text('Green')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
