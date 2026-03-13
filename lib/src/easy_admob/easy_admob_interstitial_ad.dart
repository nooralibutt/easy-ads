import 'package:easy_ads_flutter/easy_ads_flutter.dart';

class EasyAdmobInterstitialAd extends EasyAdBase {
  final AdRequest _adRequest;
  final bool _immersiveModeEnabled;

  EasyAdmobInterstitialAd(
    super.adUnitId,
    this._adRequest,
    this._immersiveModeEnabled,
  );

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  @override
  AdNetwork get adNetwork => AdNetwork.admob;

  @override
  AdUnitType get adUnitType => AdUnitType.interstitial;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  void dispose() {
    _isAdLoaded = false;
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

  @override
  Future<void> load() async {
    if (_isAdLoaded) return;

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: _adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          onAdLoaded?.call(adNetwork, adUnitType, ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          _isAdLoaded = false;
          onAdFailedToLoad?.call(
            adNetwork,
            adUnitType,
            error,
            error.toString(),
          );
        },
      ),
    );
  }

  @override
  show() {
    final ad = _interstitialAd;
    if (ad == null) return;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        onAdShowed?.call(adNetwork, adUnitType, ad);
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        onAdDismissed?.call(adNetwork, adUnitType, ad);

        ad.dispose();
        if (EasyAds.instance.autoLoadAds) load();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        onAdFailedToShow?.call(adNetwork, adUnitType, ad, error.toString());

        ad.dispose();
        if (EasyAds.instance.autoLoadAds) load();
      },
    );
    ad.setImmersiveMode(_immersiveModeEnabled);
    ad.show();
    _interstitialAd = null;
    _isAdLoaded = false;
  }
}
