import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:easy_ads_flutter/src/utils/alert_dialogs.dart';
import 'package:easy_ads_flutter/src/utils/loading_overlay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RewardedAdViewModel {
  final String id;
  final AdRequest adRequest;
  final String title;
  final String successDialogTitle;
  final String description;
  final String buttonTitle;
  final String successDialogDescription;
  final String successDialogButtonTitle;

  final void Function(BuildContext context) onEarnedReward;
  final BuildContext context;

  const RewardedAdViewModel(
    this.id,
    this.adRequest, {
    this.title = 'Watch an Ad',
    this.description = 'Watch a short video ad to continue for free.',
    this.buttonTitle = 'Watch Ad',
    this.successDialogTitle = 'Success',
    this.successDialogDescription =
        'Thanks for watching. Your reward is now available.',
    this.successDialogButtonTitle = 'Continue',
    required this.onEarnedReward,
    required this.context,
  });
}

/// Manages the lifecycle of a "just-in-time" rewarded ad.
/// This includes loading the ad upon request and showing it.
class JitRewardedAd {
  EasyAdBase? ad;
  RewardedAdViewModel? viewModel;

  Future<bool?> _promptForAd() {
    final vm = viewModel;
    if (vm == null || !vm.context.mounted) return Future.value(false);

    return showAdaptiveDialog<bool>(
      context: vm.context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(vm.title),
          content: Text(vm.description),
          actions: [
            TextButton(
              child: Text(
                'Not Now',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text(vm.buttonTitle),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showSuccessDialog() {
    final vm = viewModel;
    if (vm == null || !vm.context.mounted) return Future.value(false);

    return showAdaptiveDialog<bool>(
      context: vm.context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(vm.successDialogTitle),
          content: Text(vm.successDialogDescription),
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
              child: Text(vm.successDialogButtonTitle),
            ),
          ],
        );
      },
    );
  }

  void loadAndShowAd(
    BuildContext context,
    RewardedAdViewModel viewModel,
  ) async {
    this.viewModel = viewModel;

    final didAgree = await _promptForAd() ?? false;
    if (!didAgree) return;
    LoadingOverlay.show(context, message: "Loading Ad...");

    ad = _EasyAdmobRewardedAd(viewModel.id, viewModel.adRequest);
    ad?.onAdLoaded = (_, adUnitType, _) {
      LoadingOverlay.hide(context);
      ad?.show();
    };
    ad?.onAdFailedToLoad = (_, _, _, message) {
      LoadingOverlay.hide(context);
      _adFailedToLoadOrDisplay(viewModel.context, message);
    };

    ad?.onEarnedReward = (_, _, message, _) =>
        viewModel.onEarnedReward(viewModel.context);
    ad?.onAdFailedToShow = (_, _, _, message) {
      LoadingOverlay.hide(context);
      _adFailedToLoadOrDisplay(viewModel.context, message);
    };
    ad?.load();
  }

  void _adFailedToLoadOrDisplay(BuildContext context, String error) {
    if (kDebugMode) print(error);
    showSingleButton(
      context,
      description:
          'We are unable to show the ad right now. Please check your internet connection or try again later.',
    );
  }
}

class _EasyAdmobRewardedAd extends EasyAdBase {
  final AdRequest _adRequest;

  _EasyAdmobRewardedAd(super.adUnitId, this._adRequest);

  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;

  @override
  AdUnitType get adUnitType => AdUnitType.rewarded;

  @override
  bool get isAdLoaded => _isAdLoaded;

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
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isAdLoaded = true;
          onAdLoaded?.call(AdNetwork.admob, adUnitType, ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
          _isAdLoaded = false;
          onAdFailedToLoad?.call(
            AdNetwork.admob,
            adUnitType,
            error,
            error.toString(),
          );
        },
      ),
    );
  }

  @override
  dynamic show() {
    final ad = _rewardedAd;
    if (ad == null) return;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        onAdShowed?.call(AdNetwork.admob, adUnitType, ad);
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        onAdDismissed?.call(AdNetwork.admob, adUnitType, ad);

        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        onAdFailedToShow?.call(
          AdNetwork.admob,
          adUnitType,
          ad,
          error.toString(),
        );

        ad.dispose();
      },
    );

    ad.show(
      onUserEarnedReward: (ad, reward) {
        onEarnedReward?.call(
          AdNetwork.admob,
          adUnitType,
          reward.type,
          reward.amount,
        );
      },
    );
    _rewardedAd = null;
    _isAdLoaded = false;
  }

  @override
  AdNetwork get adNetwork => AdNetwork.admob;
}
