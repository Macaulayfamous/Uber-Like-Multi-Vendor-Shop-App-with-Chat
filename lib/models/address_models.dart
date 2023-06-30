import 'package:flutter/foundation.dart';

class AddressModels extends ChangeNotifier {
  String? placeName;
  double? latitude;

  double? longitude;

  String? placeId;
  String? placeFormattedAdress;

  AddressModels(
      {this.placeName,
      this.latitude,
      this.longitude,
      this.placeId,
      this.placeFormattedAdress});
}
