

import 'package:flutter/material.dart';

import '../models/address_models.dart';

class AppData  with ChangeNotifier{
   AddressModels? pickUpAddress;

  updatePickUpAdress(AddressModels pickUp) {
    pickUpAddress = pickUp;

    notifyListeners();
  }

}
