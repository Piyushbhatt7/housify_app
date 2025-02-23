import 'package:flutter/material.dart';
import 'HostScreens/booking_screen.dart';
import 'HostScreens/my_posting_screen.dart';
import 'guestScreens/account_screen.dart';
import 'guestScreens/inbox_screen.dart';

class HostHomeScreen extends StatefulWidget {

  int? index;

  HostHomeScreen({super.key, this.index});

  @override
  State<HostHomeScreen> createState() => _HostHomeScreenState();
}

class _HostHomeScreenState extends State<HostHomeScreen> {

  int selectedIndex = 0;

  final List<String> screenTitles = [

    'Bookings',
    'My Postings',
    'Inbox',
    'Profile',
  ];

  final List<Widget> screens = [

    BookingScreen(),
    MyPostingScreen(),
    InboxScreen(),
    AccountScreen(),
  ];

  BottomNavigationBarItem customNavigationBarItem(int index, IconData, String title)
  {
    return BottomNavigationBarItem(icon: Icon(
      IconData,
      color: Colors.black,

    ),

      activeIcon: Icon(
        IconData,
        color: Colors.pink,
      ),
      label: title,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedIndex = widget.index ?? 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pinkAccent,
                  Colors.amberAccent,
                ],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(1, 0),
                stops: [0, 1],
                tileMode: TileMode.clamp,
              )),
        ),
        title: Text(screenTitles[selectedIndex],
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,


      ),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(

        onTap: (i) {

          setState(() {
            selectedIndex = i;
          });
        },

        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>
        [

          customNavigationBarItem(0, Icons.calendar_today, screenTitles[0]),
          customNavigationBarItem(1, Icons.home, screenTitles[1]),
          customNavigationBarItem(2, Icons.message, screenTitles[2]),
          customNavigationBarItem(3, Icons.person_3_rounded, screenTitles[3]),

        ],

      ),
    );
  }
}
