import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:unishop/views/recommended.dart';
import 'dart:convert';

import 'package:unishop/views/user_posts.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0; // To keep track of the selected item in the footer.
    Future<dynamic> fetchData() async {
    final url = Uri.parse('https://creative-mole-46.hasura.app/api/rest/post/all');
    // Define the headers
    final headers = {
      'x-hasura-admin-secret': 'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

  @override
  void initstate(){
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          margin: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0), // Add top margin here
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              //Use SvgPicture.asset to display the SVG icon
              Padding(
                padding: EdgeInsets.only(left: 25.0), // Add left padding here
                child: SvgPicture.asset(
                  'assets/Favorite.svg', // Replace with your SVG file path
                  width: 12, // Set the width of the SVG icon
                  height: 12, // Set the height of the SVG icon
                  colorFilter: ColorFilter.mode(Colors.black,
                      BlendMode.srcIn), // Set the color of the SVG icon
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Products',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(), // Empty container to remove the body content
   //   Define the bottom navigation bar here.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType
            .fixed, // To display all items, even if there are more than 3.
        selectedItemColor: Colors.orange, // Color for the selected item.
        unselectedItemColor: Colors.grey,
        selectedLabelStyle:
            TextStyle(color: Colors.orange), // Color for unselected items.

        onTap: (index) {
          //Handle item tap here.
          setState(() {
            _currentIndex = index;
          });

          //Perform navigation based on the tapped item.
          switch (index) {
            case 0:
              //Navigate to the Home page.
              // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              break;
            case 1:
              //Navigate to the Favorites page.
              Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendedView()));
              break;
            case 2:
              //Navigate to the Map page.
              // Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
              break;
            case 3:
              //Navigate to the History page.
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserPostsView()));
              break;
            case 4:
              //Navigate to the Chat page.
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
              break;
          }
        },
        items: [
          //Define the items in the footer.
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/Home.svg', width: 30, height: 30),
            label: 'Home',
            activeIcon: SvgPicture.asset('assets/Home.svg',
                colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                width: 30,
                height: 30),
          ),
          BottomNavigationBarItem(
            icon:
                SvgPicture.asset('assets/Favorite.svg', width: 30, height: 30),
            label: 'Favorite',
            activeIcon: SvgPicture.asset('assets/Favorite.svg',
                colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                width: 30,
                height: 30),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/Map.svg', width: 30, height: 30),
            label: 'Map',
            activeIcon: SvgPicture.asset('assets/Map.svg',
                colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                width: 30,
                height: 30),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/History.svg', width: 30, height: 30),
            label: 'History',
            activeIcon: SvgPicture.asset('assets/History.svg',
                colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                width: 30,
                height: 30),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/Chat.svg', width: 30, height: 30),
            label: 'Chat',
            activeIcon: SvgPicture.asset('assets/Chat.svg',
                colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                width: 30,
                height: 30),
          ),
        ],
      ),
    );
  }
}