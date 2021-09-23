import 'package:ads/models/country.dart';
import 'package:flutter/material.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Easy Ads Example',
      home: CountryListScreen(),
    );
  }
}

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({Key? key}) : super(key: key);

  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  late final EasyAdmobBannerAd _bannerAd;
  @override
  void initState() {
    super.initState();

    _bannerAd = EasyAdmobBannerAd(
        BannerAd.testAdUnitId, const AdRequest(), AdSize.banner);
    _bannerAd.load();

    EasyAds.instance.initAdmob(
        interstitialAdUnitId: InterstitialAd.testAdUnitId,
        rewardedAdUnitId: RewardedAd.testAdUnitId);
  }

  @override
  void dispose() {
    super.dispose();

    EasyAds.instance.disposeInterstitialAd();
    EasyAds.instance.disposeRewardedAd();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const countryList = Country.countryList;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Country List"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _bannerAd.show(),
          Expanded(
            child: ListView.builder(
                itemCount: countryList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (countryList[index].countryName ==
                          'Pakistan - Rewarded') {
                        EasyAds.instance.showRewardedAd();
                      } else {
                        EasyAds.instance.showInterstitialAd();
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CountryDetailScreen(country: countryList[index]),
                        ),
                      );
                    },
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
