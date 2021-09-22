import 'package:ads/screens/country_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: const CountryListScreen(),
    );
  }
}
