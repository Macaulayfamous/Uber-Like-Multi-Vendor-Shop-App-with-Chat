import 'dart:convert';

import 'package:http/http.dart' as http;

class requestHelper {
  static Future<dynamic> getRequest(String url) async {
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);

    try {
      if (response.statusCode == 200) {
        final data = response.body;

        var decodedData = jsonDecode(data);

        return decodedData;
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }
}
