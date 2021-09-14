import 'package:ads/helper/helper.dart';
import 'package:ads/screens/country_detail_screen.dart';
import 'package:ads/models/country.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({Key? key}) : super(key: key);

  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  late BannerAd bannerAds;

  @override
  void initState() {
    super.initState();
    bannerAds = Helper.create();
    bannerAds.load();
  }

  @override
  void dispose() {
    bannerAds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countryList = Country.countryList;
    final AdWidget adWidget = AdWidget(ad: bannerAds);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Country List"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            child: adWidget,
            height: 50,
            width: double.infinity,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: countryList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CountryDetailScreen(country: countryList[index]),
                      ),
                    ),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Country.countryList[index].countryName,
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
