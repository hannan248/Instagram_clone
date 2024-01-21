import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController=PageController();
  }
  @override
  void dispose() {
   super.dispose();
   pageController.dispose();
  }
 void navigationTab(int page){
    pageController.jumpToPage(page);
 }
 void onPageChange(int page){
    setState(() {
      _page=page;
    });
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChange,
        physics: const NeverScrollableScrollPhysics(),
        children:homeScreenItems,
      ),
      bottomNavigationBar: BottomNavigationBar(

        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
              icon:
              Padding(
                padding: const EdgeInsets.only(top:10),
                child: Icon(
                  Icons.home,
                  color: _page == 0 ? primaryColor : secondaryColor,
                ),
              ),
              label: '',
              backgroundColor: mobileBackgroundColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: mobileBackgroundColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _page == 2 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: mobileBackgroundColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 3 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: mobileBackgroundColor),
        ],
        onTap: navigationTab,
      ),
    );
  }
}
