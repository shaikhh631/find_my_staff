import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_staff/screens/common/my_gigs.dart';
import 'package:find_my_staff/screens/common/settings.dart';
import 'package:find_my_staff/screens/contractor/contractor_hire.dart';
import 'package:find_my_staff/screens/contractor/contractor_home.dart';
import 'package:find_my_staff/screens/common/all_chats.dart';
import 'package:find_my_staff/screens/customer/home.dart';
import 'package:find_my_staff/theme.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContractorTabManager extends StatefulWidget {
  const ContractorTabManager({super.key});

  @override
  State<ContractorTabManager> createState() => _ContractorTabManagerState();
}

class _ContractorTabManagerState extends State<ContractorTabManager> {
  int selectedIndex = 0;

  List<FloatingNavbarItem> tabs = [
    FloatingNavbarItem(
      icon: Icons.home,
      title: "Home",
    ),
    FloatingNavbarItem(
      icon: Icons.add_task,
      title: "My Gigs",
    ),
    FloatingNavbarItem(
      icon: Icons.hiking_rounded,
      title: "Hire",
    ),
    FloatingNavbarItem(
      icon: CupertinoIcons.chat_bubble,
      title: "Contacts",
    ),
    FloatingNavbarItem(
      icon: CupertinoIcons.settings,
      title: "Settings",
    ),
  ];

  List<Widget> screens = [
    ContractorHome(),
    MyGigsScreen(),
    ContractorHire(),
    AllChats(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: FloatingNavbar(
        selectedBackgroundColor: primaryColor,
        backgroundColor: primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: tabs,
      ),
    );
  }
}
