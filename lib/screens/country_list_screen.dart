import 'package:ads/screens/country_detail_screen.dart';
import 'package:ads/models/country.dart';
import 'package:flutter/material.dart';

class CountryListScreen extends StatelessWidget {
  const CountryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Country List"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: Country.countryList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CountryDetailScreen(
                      countryName: Country.countryList[index].countryName,
                      flagUrl: Country.countryList[index].imageUrl,
                      countryDescription:
                          Country.countryList[index].countryDescription),
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
    );
  }
}
