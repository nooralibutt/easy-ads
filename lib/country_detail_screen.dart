import 'package:flutter/material.dart';

class CountryDetail extends StatelessWidget {
  final String name;
  final String url;
  final String description;

  const CountryDetail(
      {Key? key,
      required this.name,
      required this.url,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(url),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                description,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
