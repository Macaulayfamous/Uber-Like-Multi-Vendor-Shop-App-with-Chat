import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:uber_app/provider/app_data.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final TextEditingController _currentLocationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AppData>(context).pickUpAddress != null) {
      String _address =
          Provider.of<AppData>(context).pickUpAddress!.placeName.toString();

      _currentLocationController.text = _address;
    }
    ;

    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/store-1.png',
            width: 30,
          ),
          SizedBox(
            width: 14,
          ),
          Image.asset(
            'assets/icons/pickicon.png',
            width: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: SizedBox(
              width: 300,
              child: TextField(
                controller: _currentLocationController,
                decoration: InputDecoration(
                  hintText: 'Current Location',
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
