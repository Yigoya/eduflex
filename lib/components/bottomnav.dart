import 'package:eduflex/pages/chatHome.dart';
import 'package:eduflex/pages/chat.dart';
import 'package:eduflex/pages/home.dart';
import 'package:eduflex/pages/matrix.dart';
import 'package:eduflex/pages/saved.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with WidgetsBindingObserver {
  final List<Widget> _pages = [Home(), Chat(), Saved(), Matrix()];
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus();
  }

  void setStatus() async {
    await MyProvider.setActiveStatus(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await MyProvider.setActiveStatus(true);
      print("am online");
    } else {
      await MyProvider.setActiveStatus(false);
      print("am not online");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 20),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            padding: const EdgeInsets.all(16),
            onTabChange: (value) {
              setState(() {
                _index = value;
              });
            },
            gap: 8,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'today',
              ),
              GButton(
                icon: Icons.chat_bubble_outlined,
                text: 'chat',
              ),
              GButton(
                icon: Icons.favorite_rounded,
                text: 'saved',
              ),
              GButton(
                icon: Icons.question_mark_sharp,
                text: 'Matrix',
              ),
            ]),
      ),
    );
  }
}
