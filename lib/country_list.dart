import 'package:ads/country_detail_screen.dart';
import 'package:ads/model/country_data.dart';
import 'package:flutter/material.dart';

class CountryName extends StatelessWidget {
  const CountryName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CountryData> countryList = [
      CountryData(
        "https://cdn.britannica.com/40/5340-004-B25ED5CF/Flag-Afghanistan.jpg",
        "Afghanistan is a landlocked country at the crossroads of Central and South Asia. It is bordered by Pakistan to the east and south, Iran to the west, Turkmenistan and Uzbekistan to the north, and Tajikistan and China to the northeas",
        "Afghanistan",
      ),
      CountryData(
        "https://cdn.britannica.com/33/4833-050-F6E415FE/Flag-United-States-of-America.jpg",
        "The U.S. is a country of 50 states covering a vast swath of North America, with Alaska in the northwest and Hawaii extending the nation’s presence into the Pacific Ocean. Major Atlantic Coast cities are New York, a global finance and culture center, and capital Washington, DC. Midwestern metropolis Chicago is known for influential architecture and on the west coast, Los Angeles' Hollywood is famed for filmmaking",
        "United states",
      ),
      CountryData(
        "https://cdn.britannica.com/13/4413-004-3277D2EF/Flag-Sri-Lanka.jpg",
        "The United States recognized Ceylon (Sri Lanka) as an independent state with the status of Dominion within the British Commonwealth of Nation on February 4, 1948, in accordance with the date set in an agreement between the governments of the United Kingdom and Ceylon. President Harry S. Truman extended American recognition in a letter to Sir Henry Moore, Governor General of Ceylon, dated February 3, 1948.",
        "Sri Lanka",
      ),
      CountryData(
        "https://tolerance-homes.com/storage/images/pages/qP0fv1mqZpQwoJDnLJSeaxis4WhOye64LrbNaPet.jpeg",
        "Turkey, officially the Republic of Turkey, is a country bridging Europe and Asia. It shares borders with Greece and Bulgaria to the northwest; the Black Sea to the north; Georgia to the northeast",
        "Turkey",
      ),
      CountryData(
        "https://i.dlpng.com/static/png/6979793_preview.png",
        "India, officially the Republic of India, is a country in South Asia. It is the seventh-largest country by area, the second-most populous country, and the most populous democracy in the world",
        "India",
      ),
      CountryData(
        "https://cdn.pixabay.com/photo/2015/01/14/22/42/pakistan-599684_960_720.png",
        "Pakistan, officially the Islamic Republic of Pakistan, is a country in South Asia. It is the world's fifth-most populous country, with a population exceeding 225.2 million, and has the world's second-largest Muslim population. Pakistan is the 33rd-largest country by area, spanning 881,913 square kilometres",
        "pakistan",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Country List"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: countryList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CountryDetail(
                            name: countryList[index].name,
                            url: countryList[index].url,
                            description: countryList[index].description)));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    countryList[index].name,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
