import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0; // To keep track of the selected item in the footer.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Home Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, // To display all items, even if there are more than 3.
        selectedItemColor: Colors.orange, // Color for the selected item.
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(color: Colors.orange), // Color for unselected items.
        
        onTap: (index) {
          // Handle item tap here.
          setState(() {
            _currentIndex = index;
          });

          // Perform navigation based on the tapped item.
          switch (index) {
            case 0:
              // Navigate to the Home page.
              // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              break;
            case 1:
              // Navigate to the Favorites page.
              // Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen()));
              break;
            case 2:
              // Navigate to the Map page.
              // Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
              break;
            case 3:
              // Navigate to the History page.
              // Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen()));
              break;
            case 4:
              // Navigate to the Chat page.
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
              break;
          }
        },
        items: [
          // Define the items in the footer.
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/Home.svg', width: 30, height: 30),
            label: 'Home',
            activeIcon: SvgPicture.asset(
                  'assets/Home.svg',
                  colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                  width: 30, height: 30
              ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/Favorite.svg', width: 30, height: 30),
            label: 'Favorite',
            activeIcon: SvgPicture.asset(
                  'assets/Favorite.svg',
                  colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                  width: 30, height: 30
              ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/Map.svg', width: 30, height: 30),
            label: 'Map',
            activeIcon: SvgPicture.asset(
                  'assets/Map.svg',
                  colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                  width: 30, height: 30
              ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/History.svg', width: 30, height: 30),
            label: 'History',
            activeIcon: SvgPicture.asset(
                  'assets/History.svg',
                  colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                  width: 30, height: 30
              ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/Chat.svg', width: 30, height: 30),
            label: 'Chat',
            activeIcon: SvgPicture.asset(
                  'assets/Chat.svg',
                  colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                  width: 30, height: 30
              ),
          ),
        ],
      ),
    );
  }
}