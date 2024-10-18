import 'dart:async';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';

/// The Google Mobile Ads SDK provides the User Messaging Platform (Google's IAB
/// Certified consent management platform) as one solution to capture consent for
/// users in GDPR impacted countries. This is an example and you can choose
/// another consent management platform to capture consent.
abstract class ConsentManager {
  /// Helper variable to determine if the app can request ads.
  static Future<bool> canRequestAds() =>
      ConsentInformation.instance.canRequestAds();

  /// Helper variable to determine if the privacy options form is required.
  static Future<bool> isPrivacyOptionsRequired() async {
    return await ConsentInformation.instance
            .getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
  }

  static Future<bool> gatherPrivacyConsent() async {
    final consentStatus =
        await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
    if (consentStatus == PrivacyOptionsRequirementStatus.notRequired) {
      return true;
    }

    await _showPrivacyOptionsForm();
    return await isPrivacyOptionsRequired();
  }

  static Future<bool> gatherGdprConsent(
      {DebugGeography? debugGeography}) async {
    if (await canRequestAds()) return true;
    final consentStatus = await ConsentInformation.instance.getConsentStatus();
    if (consentStatus == ConsentStatus.notRequired ||
        consentStatus == ConsentStatus.obtained) return true;

    await _gatherGdprConsent(debugGeography: debugGeography);

    return await ConsentInformation.instance.getConsentStatus() ==
        ConsentStatus.obtained;
  }

  /// Helper method to call the Mobile Ads SDK to request consent information
  /// and load/show a consent form if necessary.
  static Future<FormError?> _gatherGdprConsent(
      {DebugGeography? debugGeography}) {
    final completer = Completer<FormError?>();

    // For testing purposes, you can force a DebugGeography of Eea or NotEea.
    ConsentDebugSettings debugSettings = ConsentDebugSettings(
      debugGeography: debugGeography,
    );
    ConsentRequestParameters params =
        ConsentRequestParameters(consentDebugSettings: debugSettings);

    // Requesting an update to consent information should be called on every app launch.
    ConsentInformation.instance.requestConsentInfoUpdate(params, () async {
      ConsentForm.loadAndShowConsentFormIfRequired((loadAndShowError) {
        completer.complete(loadAndShowError);
      });
    }, (FormError formError) {
      completer.complete(formError);
    });

    return completer.future;
  }

  /// Helper method to call the Mobile Ads SDK method to show the privacy options form.
  static Future<FormError?> _showPrivacyOptionsForm() {
    final completer = Completer<FormError?>();

    ConsentForm.showPrivacyOptionsForm((formError) {
      completer.complete(formError);
    });

    return completer.future;
  }
}
