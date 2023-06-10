// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:chatgpt_course/constants/ads_info_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static RewardedInterstitialAd? _rewardedAd;
  static Function? _rewardedAdCallback;

  static void initialize() async {
    MobileAds.instance.initialize();
  }

  static Future<void> loadRewardedAd() async {
    // RewardedInterstitialAd
    await RewardedInterstitialAd.load(
      adUnitId: AdmobadUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Ad Loaded Correctly Finaly!')));
          _rewardedAd = ad;
          _rewardedAdCallback?.call();
        },
        onAdFailedToLoad: (error) {
          log('Rewarded ad failed to load: $error');
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //     content: Text('Ad Not Loaded, Faild To load ad!')));
        },
      ),
    );
  }

  static void showRewardedAd(Function onUserEarnedReward) {
    if (_rewardedAd == null) {
      log('_rewardedAd == null => Rewarded ad is not loaded yet.');
      return;
    }
    _rewardedAdCallback = onUserEarnedReward;
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _rewardedAd = null;
        _rewardedAdCallback = null;
        loadRewardedAd(); // Load the next rewarded ad
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log('Failed to show rewarded ad: $error');
        _rewardedAd = null;
        _rewardedAdCallback = null;
      },
      onAdShowedFullScreenContent: (ad) {
        // Ad was shown, no action needed
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (ad, rewardItem) {
      // Callback when the user has earned the reward
      onUserEarnedReward();
    });
    // _rewardedAd!.show();
  }
}
