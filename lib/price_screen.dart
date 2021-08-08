import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'coin_brain.dart';
import 'currency_card.dart';

const apiKey = "68A9005D-1DFF-479D-85E8-BA541407A554";

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'INR';
  int currency1 = 0;
  int currency2 = 0;
  int currency3 = 0;

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          setCurrency("BTC", selectedCurrency);
          setCurrency("ETH", selectedCurrency);
          setCurrency("LTC", selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (index) {
        setState(() {
          setCurrency("BTC", currenciesList[index]);
          setCurrency("ETH", currenciesList[index]);
          setCurrency("LTC", currenciesList[index]);
        });
      },
      children: pickerItems,
    );
  }

  Future<int> getCurrency(String from, String to) async {
    CoinBrain coinBrain = CoinBrain(from: from, to: to);
    var coinData = await coinBrain.getData();
    double currValue = coinData["rate"];
    return currValue.toInt();
  }

  void setCurrency(String from, String to) async {
    int value = await getCurrency(from, to);
    if (from == "BTC")
      currency1 = value;
    else if (from == "ETH")
      currency2 = value;
    else if (from == "LTC") currency3 = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CurrencyCard(
                fromCurrency: "BTC",
                selectedCurrency: selectedCurrency,
                currency: currency1,
              ),
              CurrencyCard(
                fromCurrency: "ETH",
                selectedCurrency: selectedCurrency,
                currency: currency2,
              ),
              CurrencyCard(
                fromCurrency: "LTH",
                selectedCurrency: selectedCurrency,
                currency: currency3,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? androidDropdown() : iOSPicker(),
          ),
        ],
      ),
    );
  }
}
