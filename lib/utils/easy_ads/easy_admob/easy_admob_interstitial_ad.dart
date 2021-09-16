import 'package:ads/utils/easy_ads/easy_ad_base.dart';
import 'package:ads/utils/enums/ad_network.dart';
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
  AdNetwork get adNetwork => AdNetwork.Admob;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  Future<void> init() async {}

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
            onAdLoaded?.call(adNetwork, ad);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _interstitialAd = null;
            _isAdLoaded = false;
            onAdFailedToLoad?.call(adNetwork, error.toString());
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
        onAdShowed?.call(adNetwork, ad);
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        onAdDismissed?.call(adNetwork, ad);

        ad.dispose();
        load();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        onAdFailedToShow?.call(adNetwork, error.toString(), ad);

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
