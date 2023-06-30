import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uber_app/helpers/request_helper.dart';

import '../cont/global_varaible.dart';
import '../models/address_models.dart';
import '../provider/app_data.dart';

class HelperMethods {
  static Future<String> findCordinateAddress(Position position, context) async {
    String placeAddress = '';

    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${mapKey}';

    var response = await requestHelper.getRequest(url);
    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      AddressModels pickUpAddress = AddressModels();
      pickUpAddress.latitude = position.latitude;
      pickUpAddress.longitude = position.longitude;
      pickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpAdress(pickUpAddress);
    }

    return placeAddress;
  }
}
