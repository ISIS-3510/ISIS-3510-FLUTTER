import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unishop/View/home.dart';
import 'package:unishop/View/recommended.dart';
import 'package:unishop/View/profile.dart';


class Footer extends StatefulWidget {
  const Footer({super.key, required this.currentIndex});
  final int currentIndex;

  @override
  State<Footer> createState() {
    return _FooterState();
  }
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
            currentIndex: widget.currentIndex,
            type: BottomNavigationBarType
                .fixed, // To display all items, even if there are more than 3.
            selectedItemColor: Colors.orange, // Color for the selected item.
            unselectedItemColor: Colors.grey,
            selectedLabelStyle:
                TextStyle(color: Colors.orange), // Color for unselected items.

            onTap: (index) {
              //Perform navigation based on the tapped item.
              switch (index) {
                case 0:
                  //Navigate to the Home page.
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeView()));
                  break;
                case 1:
                  //Navigate to the Favorites page.
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => RecommendedView()));
                  break;
                case 2:
                  //Navigate to the Map page.
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
                  break;
                case 3:
                //Navigate to the History page.
                //Navigator.push(context,
                //MaterialPageRoute(builder: (context) => UserPostsView()));
                //break;
                case 4:
                  //Navigate to the profile page.
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile()));
                  // break;
              }
            },
            items: [
              //Define the items in the footer.
              BottomNavigationBarItem(
                icon:
                    SvgPicture.asset('assets/Home.svg', width: 30, height: 30),
                label: 'Home',
                activeIcon: SvgPicture.asset('assets/Home.svg',
                    colorFilter:
                        ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                    width: 30,
                    height: 30),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/Posts.svg',
                    width: 30, height: 30),
                label: 'Posts',
                activeIcon: SvgPicture.asset('assets/Posts.svg',
                    colorFilter:
                        ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                    width: 30,
                    height: 30),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.map_outlined,
                  color: Color.fromRGBO(0, 0, 0, 0),
                ),
                label: 'Create',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/Favorite.svg',
                    width: 30, height: 30),
                label: 'Favorites',
                activeIcon: SvgPicture.asset('assets/Favorite.svg',
                    colorFilter:
                        ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                    width: 30,
                    height: 30),
              ),
              BottomNavigationBarItem(
                icon:
                    SvgPicture.asset('assets/Profile.svg', width: 30, height: 30),
                label: 'Profile',
                activeIcon: SvgPicture.asset('assets/Profile.svg',
                    colorFilter:
                        ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                    width: 30,
                    height: 30),
              ),
            ],
          );
  }
}