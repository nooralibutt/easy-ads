import 'package:flutter/material.dart';

class CountryDetailScreen extends StatelessWidget {
  final String imagesName;
  final String imageUrl;
  final String imageDescription;

  const CountryDetailScreen(
      {Key? key,
      required this.imagesName,
      required this.imageUrl,
      required this.imageDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imagesName),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                imageDescription,
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
