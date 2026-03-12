import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class JitAppOpenAd {
  final String id;
  final AdRequest adRequest;

  final VoidCallback? onFailedToLoadOrShow;
  final VoidCallback? onAdShowed;
  final VoidCallback? onAdDismissed;

  JitAppOpenAd(
    this.id,
    this.adRequest, {
    this.onFailedToLoadOrShow,
    this.onAdShowed,
    this.onAdDismissed,
  });

  Future<void> loadAndShow() async {
    await AppOpenAd.load(
      adUnitId: id,
      request: adRequest,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) => _show(ad),
        onAdFailedToLoad: (error) => onFailedToLoadOrShow?.call(),
      ),
    );
  }

  void _show(AppOpenAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => onAdShowed?.call(),
      onAdDismissedFullScreenContent: (ad) {
        onAdDismissed?.call();

        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        onFailedToLoadOrShow?.call();

        ad.dispose();
      },
    );
    ad.setImmersiveMode(true);
    ad.show();
  }
}
