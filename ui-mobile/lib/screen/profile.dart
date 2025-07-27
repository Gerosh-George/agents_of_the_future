import 'package:crowd_management_agentic_ai/screen/customAppBar.dart';
import 'package:crowd_management_agentic_ai/screen/dashboard.dart';
import 'package:crowd_management_agentic_ai/screen/graphs.dart';
import 'package:crowd_management_agentic_ai/screen/sideNavigator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'login.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> stringInfo = ['Alerts', 'Notifications', ' Post'];
    List<String> numberInfo = ['3', '4', ' 3'];

    var currentIndex = 1;
    return Scaffold(
      drawer: const NavigationDrawerWidget(),
      appBar: customAppBar(2, context),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: const AssetImage('assets/bg.webp'),
              fit: BoxFit.cover),
        ),
        child: ListView(
          // shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFd81e29),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/vk.jpg'),
                      radius: 48,
                    ),
                  ),
                ),
                // const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Container(
                    width: 265,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: Colors.amber,
                    ),
                    child: GridView.count(
                      primary: false,
                      crossAxisCount: 3,
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 3.0,
                      childAspectRatio: 1.5,
                      shrinkWrap: true,
                      children: List.generate(
                        3,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              width: 60,
                              height: 20,
                              // color: Colors.amberAccent,
                              child: Column(
                                children: [
                                  Text(
                                    numberInfo[index],
                                    style: GoogleFonts.albertSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                  // const Spacer(),
                                  Text(
                                    stringInfo[index],
                                    style: GoogleFonts.albertSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: 400,
                height: 40,
                // color: Colors.amber,
                child: Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 120,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white70,
                            foregroundColor: Colors.amberAccent,
                            shadowColor: Colors.black),
                        child: Text(
                          'Edit Profile',
                          style: GoogleFonts.albertSans(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 120,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFd81e29),
                            // foregroundColor: Colors.amberAccent,
                            shadowColor: Colors.black),
                        child: Text(
                          'Settings',
                          style: GoogleFonts.albertSans(
                              fontSize: 16,
                              color: Color.fromARGB(225, 255, 255, 255),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedLabelStyle:
            const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18),
        unselectedItemColor: Color.fromARGB(255, 255, 255, 255),
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home_rounded,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            backgroundColor: Color.fromRGBO(205, 19, 0, 1),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(
              Icons.account_circle_sharp,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            backgroundColor: Color.fromRGBO(205, 19, 0, 1),
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const Dashboard(),
                ),
              );
              break;

          }
        },
      ),
    );
  }
}
