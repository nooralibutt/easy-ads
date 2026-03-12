import 'package:easy_ads_flutter/src/utils/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class JitInterstitialAd {
  final String id;
  final VoidCallback? onFailedToLoadOrShow;
  final VoidCallback? onAdShowed;
  final VoidCallback? onAdDismissed;
  final AdRequest adRequest;

  JitInterstitialAd(
    this.id,
    this.adRequest, {
    this.onFailedToLoadOrShow,
    this.onAdShowed,
    this.onAdDismissed,
  });

  Future<void> loadAndShow(BuildContext context) async {
    LoadingOverlay.show(context, message: "Please wait...");
    await InterstitialAd.load(
      adUnitId: id,
      request: adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          LoadingOverlay.hide(context);

          _show(ad);
        },
        onAdFailedToLoad: (error) {
          LoadingOverlay.hide(context);
          onFailedToLoadOrShow?.call();
        },
      ),
    );
  }

  void _show(InterstitialAd ad) {
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

  static Future<bool?> showSuccessDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String buttonText,
  }) {
    return showAdaptiveDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Not Now',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }
}
