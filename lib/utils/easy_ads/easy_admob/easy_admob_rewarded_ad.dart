import 'package:ads/utils/easy_ads/easy_ad_base.dart';
import 'package:ads/utils/enums/ad_network.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class EasyAdmobRewardedAd extends EasyAdBase {
  final AdRequest _adRequest;
  final bool _immersiveModeEnabled;

  EasyAdmobRewardedAd(
    String adUnitId,
    this._adRequest,
    this._immersiveModeEnabled,
  ) : super(adUnitId);

  RewardedAd? _rewardedAd;
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
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }

  @override
  Future<void> load() async {
    if (_isAdLoaded) return;

    await RewardedAd.load(
        adUnitId: adUnitId,
        request: _adRequest,
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          _rewardedAd = ad;
          _isAdLoaded = true;
          onAdLoaded?.call(adNetwork, ad);
        }, onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          _rewardedAd = null;
          _isAdLoaded = false;
          onAdFailedToLoad?.call(adNetwork, error.toString());
        }));
  }

  @override
  dynamic show() {
    final ad = _rewardedAd;
    if (ad == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        print('ad onAdShowedFullScreenContent.');
        onAdShowed?.call(adNetwork, ad);
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        onAdDismissed?.call(adNetwork, ad);

        ad.dispose();
        load();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        onAdFailedToDisplay?.call(adNetwork, error.toString(), ad);

        ad.dispose();
        load();
      },
    );

    ad.setImmersiveMode(_immersiveModeEnabled);
    ad.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
      onEarnedReward?.call(adNetwork, reward.type, reward.amount);
    });
    _rewardedAd = null;
    _isAdLoaded = false;
  }
}
