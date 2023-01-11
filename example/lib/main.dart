import 'dart:async';

import 'package:ads/models/country.dart';
import 'package:ads/models/test_ad_id_manager.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

const IAdIdManager adIdManager = TestAdIdManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyAds.instance.initialize(
    adIdManager,
    unityTestMode: true,
    adMobAdRequest: const AdRequest(),
    admobConfiguration: RequestConfiguration(testDeviceIds: [
      '4ACA773F6D0C76D2A8934CD1F3EDFDB4', // Mi Phone
      '00008030-00163022226A802E',
    ]),
    isAgeRestrictedUserForApplovin: true,
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
  /// Using it to cancel the subscribed callbacks
  StreamSubscription? _streamSubscription;

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
          const EasyBannerAd(adNetwork: AdNetwork.facebook),
          Expanded(
            child: ListView.builder(
                itemCount: countryList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (countryList[index].countryName ==
                          'Pakistan - Rewarded') {
                        if (EasyAds.instance.showAd(AdUnitType.rewarded)) {
                          // Canceling the last callback subscribed
                          _streamSubscription?.cancel();
                          // Listening to the callback from showRewardedAd()
                          _streamSubscription =
                              EasyAds.instance.onEvent.listen((event) {
                            if (event.adUnitType == AdUnitType.rewarded &&
                                event.type == AdEventType.earnedReward) {
                              _streamSubscription?.cancel();
                              goToNextScreen(countryList[index]);
                            }
                          });
                        }
                      } else if (countryList[index].countryName ==
                          'India - App Open') {
                        if (EasyAds.instance.showAd(AdUnitType.appOpen)) {
                          // Canceling the last callback subscribed
                          _streamSubscription?.cancel();
                          // Listening to the callback from showInterstitialAd()
                          _streamSubscription =
                              EasyAds.instance.onEvent.listen((event) {
                            if (event.adUnitType == AdUnitType.appOpen &&
                                event.type == AdEventType.adDismissed) {
                              _streamSubscription?.cancel();
                              goToNextScreen(countryList[index]);
                            }
                          });
                        }
                      } else {
                        if (EasyAds.instance.showAd(AdUnitType.interstitial,
                            adNetwork: AdNetwork.facebook)) {
                          // Canceling the last callback subscribed
                          _streamSubscription?.cancel();
                          // Listening to the callback from showInterstitialAd()
                          _streamSubscription =
                              EasyAds.instance.onEvent.listen((event) {
                            if (event.adUnitType == AdUnitType.interstitial &&
                                event.type == AdEventType.adDismissed) {
                              _streamSubscription?.cancel();
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
          const EasySmartBannerAd(),
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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  widget.country.countryDescription,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 22),
                ),
              ),
            ),
          ),
          const EasySmartBannerAd(
            priorityAdNetworks: [
              AdNetwork.facebook,
              AdNetwork.admob,
              AdNetwork.unity,
              AdNetwork.appLovin,
            ],
            adSize: AdSize.largeBanner,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
