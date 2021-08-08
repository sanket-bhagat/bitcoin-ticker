import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = "68A9005D-1DFF-479D-85E8-BA541407A554";

class CoinBrain {
  CoinBrain({required this.from, required this.to});
  final String from;
  final String to;
  Future getData() async {
    String url =
        "https://rest.coinapi.io/v1/exchangerate/$from/$to?apikey=$apiKey";
    http.Response response = await http.get(Uri.parse(url));
    String data = response.body;
    return jsonDecode(data);
  }
}
