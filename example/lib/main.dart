import 'dart:async';

import 'package:ads/models/country.dart';
import 'package:ads/models/test_ad_id_manager.dart';
import 'package:flutter/material.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';

const IAdIdManager adIdManager = TestAdIdManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyAds.instance.initialize(
    adIdManager,
    unityTestMode: true,
    adMobAdRequest: const AdRequest(),
    admobConfiguration:
        RequestConfiguration(testDeviceIds: ['adakjhdjkahdahkjdahkdhk']),
    fbTestingId: '73f92d66-f8f6-4978-999f-b5e0dd62275a',
    fbiOSAdvertiserTrackingEnabled: true,
  );

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
  final EasyAdBase? _bannerAd =
      EasyAds.instance.createBanner(adNetwork: AdNetwork.admob);

  /// Using it to cancel the subscribed callbacks
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    _bannerAd?.load();
  }

  @override
  void dispose() {
    super.dispose();

    EasyAds.instance.disposeAds();

    _bannerAd?.dispose();
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
          _bannerAd?.show() ?? const SizedBox(),
          Expanded(
            child: ListView.builder(
                itemCount: countryList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (countryList[index].countryName ==
                          'Pakistan - Rewarded') {
                        if (EasyAds.instance.showRewardedAd()) {
                          // Canceling the last callback subscribed
                          _streamSubscription?.cancel();
                          // Listening to the callback from showRewardedAd()
                          _streamSubscription =
                              EasyAds.instance.onEvent.listen((event) {
                            _streamSubscription?.cancel();

                            if (event.adUnitType == AdUnitType.rewarded &&
                                event.type == AdEventType.adDismissed) {
                              goToNextScreen(countryList[index]);
                            }
                          });
                        }
                      } else {
                        if (EasyAds.instance.showInterstitialAd(
                            adNetwork: AdNetwork.facebook)) {
                          // Canceling the last callback subscribed
                          _streamSubscription?.cancel();
                          // Listening to the callback from showInterstitialAd()
                          _streamSubscription =
                              EasyAds.instance.onEvent.listen((event) {
                            _streamSubscription?.cancel();

                            if (event.adUnitType == AdUnitType.interstitial &&
                                event.type == AdEventType.adDismissed) {
                              goToNextScreen(countryList[index]);
                            }
                          });
                        }
                      }
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

  void goToNextScreen(Country country) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetailScreen(country: country),
      ),
    );
  }
}

class CountryDetailScreen extends StatefulWidget {
  final Country country;

  const CountryDetailScreen({Key? key, required this.country})
      : super(key: key);

  @override
  State<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryDetailScreen> {
  final EasyAdBase? _bannerAd =
      EasyAds.instance.createBanner(adNetwork: AdNetwork.unity);

  @override
  void initState() {
    super.initState();

    EasyAds.instance.loadInterstitialAd();

    _bannerAd?.load();
  }

  @override
  void dispose() {
    super.dispose();

    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.countryName),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.country.imageUrl),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                widget.country.countryDescription,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              ),
            ),
          ),
          const Spacer(),
          _bannerAd?.show() ?? const SizedBox(),
        ],
      ),
    );
  }
}
