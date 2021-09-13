import 'package:ads/screens/country_detail_screen.dart';
import 'package:ads/models/country.dart';
import 'package:flutter/material.dart';

class CountryListScreen extends StatelessWidget {
  const CountryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countryList = Country.countryList;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Country List"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: countryList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CountryDetailScreen(
                        countryName: countryList[index].countryName,
                        flagUrl: countryList[index].imageUrl,
                        countryDescription:
                            countryList[index].countryDescription);
                  },
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
