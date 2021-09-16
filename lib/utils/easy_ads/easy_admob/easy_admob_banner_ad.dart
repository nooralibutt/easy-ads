import 'package:google_mobile_ads/google_mobile_ads.dart';

class EasyAdmobBannerAd {
  static BannerAd bannerCreate() => BannerAd(
        size: AdSize.banner,
        adUnitId: BannerAd.testAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) => print('Ad loaded has been Successfully bro.'),
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            print('Ad failed to load: $error');
          },
          onAdOpened: (Ad ad) => print('Ad opened.'),
          onAdClosed: (Ad ad) => print('Ad closed.'),
          onAdImpression: (Ad ad) => print('Ad impression.'),
        ),
        request: AdRequest(),
      );
}
