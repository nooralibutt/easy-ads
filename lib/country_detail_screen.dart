import 'package:flutter/material.dart';

class CountryDetailScreen extends StatelessWidget {
  final String countryName;
  final String flagUrl;
  final String countryDescription;

  const CountryDetailScreen(
      {Key? key,
      required this.countryName,
      required this.flagUrl,
      required this.countryDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(countryName),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(flagUrl),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                countryDescription,
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
