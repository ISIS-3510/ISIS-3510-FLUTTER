import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() {
    return _HeaderState();
  }
}

class _HeaderState extends State<Header> {
  Color? color1 = Colors.grey[300];
  Color? color2 = Colors.grey[300];
  Color? color3 = Colors.grey[300];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          margin: EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: SvgPicture.asset(
                  'assets/Search.svg',
                  width: 12,
                  height: 12,
                  colorFilter: ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
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
        SizedBox(height: 10),
      ],
    );
  }
}