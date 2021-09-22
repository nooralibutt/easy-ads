import 'package:easy_ads/src/easy_ad_base.dart';
import 'package:easy_ads/src/enums/ad_network.dart';
import 'package:easy_ads/src/enums/ad_unit_type.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class EasyAdmobInterstitialAd extends EasyAdBase {
  final AdRequest _adRequest;
  final bool _immersiveModeEnabled;

  EasyAdmobInterstitialAd(
    String adUnitId,
    this._adRequest,
    this._immersiveModeEnabled,
  ) : super(adUnitId);

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
            print('$ad loaded');
            _interstitialAd = ad;
            _isAdLoaded = true;
            onAdLoaded?.call(adNetwork, adUnitType, ad);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _interstitialAd = null;
            _isAdLoaded = false;
            onAdFailedToLoad?.call(adNetwork, adUnitType, error.toString());
          },
        ));
  }

  @override
  show() {
    final ad = _interstitialAd;
    if (ad == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print('ad onAdShowedFullScreenContent.');
        onAdShowed?.call(adNetwork, adUnitType, ad);
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        onAdDismissed?.call(adNetwork, adUnitType, ad);

        ad.dispose();
        load();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        onAdFailedToShow?.call(adNetwork, adUnitType, error.toString(), ad);

        ad.dispose();
        load();
      },
    );
    ad.setImmersiveMode(_immersiveModeEnabled);
    ad.show();
    _interstitialAd = null;
    _isAdLoaded = false;
  }
}
