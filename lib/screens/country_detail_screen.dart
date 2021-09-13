import 'package:ads/models/country.dart';
import 'package:flutter/material.dart';

class CountryDetailScreen extends StatelessWidget {
  final Country country;

  const CountryDetailScreen({Key? key, required this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.countryName),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(country.imageUrl),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                country.countryDescription,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
