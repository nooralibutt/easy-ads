import 'dart:io';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:easy_ads_flutter/src/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget(this.id, this.adRequest, {super.key});
  final AdRequest adRequest;
  final String id;
  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _loadAd());
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  /// Loads a native ad using the modern template approach.
  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: widget.id,
      request: widget.adRequest,
      nativeTemplateStyle: nativeAdTemplate,
      listener: NativeAdListener(
        onAdLoaded: (_) {
          setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    )..load();
  }

  NativeTemplateStyle get nativeAdTemplate {
    final theme = Theme.of(context);
    return NativeTemplateStyle(
      templateType: TemplateType.small,
      cornerRadius: 0,
      mainBackgroundColor: Platform.isAndroid
          ? null
          : theme.colorScheme.surfaceContainerHigh,
      callToActionTextStyle: NativeTemplateTextStyle(
        textColor: theme.colorScheme.onSecondary,
        backgroundColor: theme.colorScheme.secondary,
      ),
      primaryTextStyle: NativeTemplateTextStyle(
        textColor: theme.colorScheme.onSurface,
      ),
      secondaryTextStyle: NativeTemplateTextStyle(
        textColor: theme.colorScheme.onSurface,
      ),
      tertiaryTextStyle: NativeTemplateTextStyle(
        textColor: theme.colorScheme.onSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const constraints = BoxConstraints(
      maxWidth: double.infinity,
      minHeight: 90,
      maxHeight: 110,
    );
    if (_isAdLoaded && _nativeAd != null) {
      return ConstrainedBox(
        constraints: constraints,
        child: AdWidget(ad: _nativeAd!),
      );
    }

    // Return a themed placeholder that matches the small template's approximate height.
    return ConstrainedBox(
      constraints: constraints,
      child: const AdCard(child: AdSkeleton()),
    );
  }
}

/// A reusable card that provides the background and border for the ad placeholder.
class AdCard extends StatelessWidget {
  final Widget child;

  const AdCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(kPadding / 2),
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: child,
    );
  }
}

/// The skeleton UI shown while the ad is loading, styled for the small template.
class AdSkeleton extends StatelessWidget {
  const AdSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final skeletonColor = Theme.of(context).colorScheme.surfaceContainerLow;
    return Row(
      spacing: kPadding / 2,
      children: [
        Expanded(flex: 4, child: Container(color: skeletonColor)),
        Expanded(
          flex: 13,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 16,
                width: double.infinity,
                color: skeletonColor,
              ),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: Container(height: 14, color: skeletonColor),
              ),
              FractionallySizedBox(
                widthFactor: 0.4,
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(kPadding / 3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
