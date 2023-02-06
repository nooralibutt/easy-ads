import 'dart:async';

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
    fbTestMode: true,
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
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  /// Using it to cancel the subscribed callbacks
  StreamSubscription? _streamSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ad Network List"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'AppOpen',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              AdButton(
                networkName: 'Admob AppOpen',
                onTap: () => _showAd(AdNetwork.admob, AdUnitType.appOpen),
              ),
              const Divider(thickness: 2),
              Text(
                'Interstitial',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              AdButton(
                networkName: 'Admob Interstitial',
                onTap: () => _showAd(AdNetwork.admob, AdUnitType.interstitial),
              ),
              AdButton(
                networkName: 'Facebook Interstitial',
                onTap: () =>
                    _showAd(AdNetwork.facebook, AdUnitType.interstitial),
              ),
              AdButton(
                networkName: 'Unity Interstitial',
                onTap: () => _showAd(AdNetwork.unity, AdUnitType.interstitial),
              ),
              AdButton(
                networkName: 'Applovin Interstitial',
                onTap: () =>
                    _showAd(AdNetwork.appLovin, AdUnitType.interstitial),
              ),
              AdButton(
                networkName: 'Available Interstitial',
                onTap: () => _showAvailableAd(AdUnitType.interstitial),
              ),
              const Divider(thickness: 2),
              Text(
                'Rewarded',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              AdButton(
                networkName: 'Admob Rewarded',
                onTap: () => _showAd(AdNetwork.admob, AdUnitType.rewarded),
              ),
              AdButton(
                networkName: 'Facebook Rewarded',
                onTap: () => _showAd(AdNetwork.facebook, AdUnitType.rewarded),
              ),
              AdButton(
                networkName: 'Unity Rewarded',
                onTap: () => _showAd(AdNetwork.unity, AdUnitType.rewarded),
              ),
              AdButton(
                networkName: 'Applovin Rewarded',
                onTap: () => _showAd(AdNetwork.appLovin, AdUnitType.rewarded),
              ),
              AdButton(
                networkName: 'Available Rewarded',
                onTap: () => _showAvailableAd(AdUnitType.rewarded),
              ),
              const EasySmartBannerAd(
                priorityAdNetworks: [
                  AdNetwork.facebook,
                  AdNetwork.admob,
                  AdNetwork.unity,
                  AdNetwork.appLovin,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAd(AdNetwork adNetwork, AdUnitType adUnitType) {
    if (EasyAds.instance.showAd(adUnitType, adNetwork: adNetwork)) {
      // Canceling the last callback subscribed
      _streamSubscription?.cancel();
      // Listening to the callback from showRewardedAd()
      _streamSubscription = EasyAds.instance.onEvent.listen((event) {
        if (event.adUnitType == adUnitType) {
          _streamSubscription?.cancel();
          goToNextScreen(adNetwork: adNetwork);
        }
      });
    } else {
      goToNextScreen(adNetwork: adNetwork);
    }
  }

  void _showAvailableAd(AdUnitType adUnitType) {
    if (EasyAds.instance.showAd(adUnitType)) {
      // Canceling the last callback subscribed
      _streamSubscription?.cancel();
      // Listening to the callback from showRewardedAd()
      _streamSubscription = EasyAds.instance.onEvent.listen((event) {
        if (event.adUnitType == adUnitType) {
          _streamSubscription?.cancel();
          goToNextScreen();
        }
      });
    } else {
      goToNextScreen();
    }
  }

  void goToNextScreen({AdNetwork? adNetwork}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetailScreen(adNetwork: adNetwork),
      ),
    );
  }
}

class CountryDetailScreen extends StatefulWidget {
  final AdNetwork? adNetwork;
  const CountryDetailScreen({Key? key, this.adNetwork}) : super(key: key);

  @override
  State<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('United States'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://cdn.britannica.com/33/4833-050-F6E415FE/Flag-United-States-of-America.jpg'),
              ),
            ),
          ),
          const Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'The U.S. is a country of 50 states covering a vast swath of North America, with Alaska in the northwest and Hawaii extending the nation’s presence into the Pacific Ocean. Major Atlantic Coast cities are New York, a global finance and culture center, and capital Washington, DC. Midwestern metropolis Chicago is known for influential architecture and on the west coast, Los Angeles\' Hollywood is famed for filmmaking',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                ),
              ),
            ),
          ),
          (widget.adNetwork == null)
              ? const EasySmartBannerAd()
              : EasyBannerAd(
                  adNetwork: widget.adNetwork!,
                  adSize: AdSize.banner,
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class AdButton extends StatelessWidget {
  final String networkName;
  final VoidCallback onTap;
  const AdButton({Key? key, required this.onTap, required this.networkName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            networkName,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
          ),
        ),
      ),
    );
  }
}
