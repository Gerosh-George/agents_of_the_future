import 'package:crowd_management_agentic_ai/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
      color: const Color.fromRGBO(205, 19, 0, 1),
      child: ListView(
        padding: padding,
        children: <Widget>[
          const SizedBox(height: 40),
          buildMenuItem(
            text: 'Home',
            icon: Icons.home,
            ctx: context,
          ),
          const SizedBox(
            height: 16,
          ),
          buildMenuItem(
            text: 'Profile',
            icon: Icons.account_circle_outlined,
            ctx: context,
          ),
          const SizedBox(
            height: 16,
          ),
          buildMenuItem(
            text: 'Console',
            icon: Icons.all_inbox,
            ctx: context,
          ),
          const SizedBox(
            height: 16,
          ),
          buildMenuItem(
            text: 'Logout',
            icon: Icons.logout_rounded,
            ctx: context,
          ),
        ],
      ),
    ));
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    required BuildContext ctx,
  }) {
    const color = Colors.white;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: const TextStyle(color: color, fontSize: 18),
      ),
      onTap: () async {
        if (text == 'Logout') {
          await FirebaseAuth.instance.signOut();
          Navigator.push(
              ctx,
              MaterialPageRoute(
                  builder: (context) => LoginPage(title: 'Welcome Back')));
        }
      },
    );
  }
}
