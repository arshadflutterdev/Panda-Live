import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'rewarded_ad_services.dart';

class AdController {
  static final AdController _instance = AdController._internal();
  factory AdController() => _instance;
  AdController._internal();

  bool _canShowAd = false;
  bool _cooldownActive = false;
  Timer? _initialTimer;
  Timer? _cooldownTimer;

  void initialize() {
    RewardedAdServices.adLoading();

    // Pehle 30 sec tak ads band
    _initialTimer = Timer(const Duration(seconds: 30), () {
      _canShowAd = true;
      debugPrint("✅ Ads enabled after 30 sec delay");
    });
  }

  void tryShowAd() {
    if (!_canShowAd) {
      debugPrint("⏳ Wait — ads not allowed yet (first 30 sec)");
      return;
    }

    if (_cooldownActive) {
      debugPrint("🚫 Cooldown active — wait 5 minutes");
      return;
    }

    // ✅ Show ad
    RewardedAdServices.showRewardAd(
      onUserEarnedReward: (reward) {
        debugPrint("🎁 User earned reward $reward");
      },
    );

    // 🕐 Start cooldown
    _cooldownActive = true;
    _cooldownTimer = Timer(const Duration(minutes: 1), () {
      _cooldownActive = false;
      RewardedAdServices.adLoading();
      debugPrint("🔓 Ad ready again after 5 minutes");
    });
  }

  void dispose() {
    _initialTimer?.cancel();
    _cooldownTimer?.cancel();
  }
}

class RewardedAdServices {
  static RewardedAd? _rewardedAd;
  static bool _isLoading = false;

  /// ✅ Load a rewarded ad if not already loading
  static void adLoading() {
    if (_isLoading || _rewardedAd != null) return;
    _isLoading = true;

    RewardedAd.load(
      // adUnitId: "ca-app-pub-3629224446793734/5928752829", // ✅ Test Ad Unit
      adUnitId: "ca-app-pub-3940256099942544/5224354917", // ✅ Test Ad Unit
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint("✅ Rewarded Ad loaded successfully!");
          _rewardedAd = ad;
          _isLoading = false;

          // Reload ad after closing
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint("ℹ️ Ad closed by user");
              ad.dispose();
              _rewardedAd = null;
              adLoading(); // load next one
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint("❌ Ad failed to show: $error");
              ad.dispose();
              _rewardedAd = null;
              adLoading();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint("❌ Failed to load ad: $error");
          _isLoading = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  /// ✅ Show rewarded ad anywhere
  static void showRewardAd({
    required Function(int rewardCoins) onUserEarnedReward,
    BuildContext? context,
  }) {
    if (_rewardedAd == null) {
      debugPrint("⚠️ Rewarded ad not ready yet. Loading...");
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ad not ready yet, please wait...")),
        );
      }
      adLoading(); // trigger load if missing
      return;
    }

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint("🎁 User earned ${reward.amount.toInt()} coins!");
        onUserEarnedReward(reward.amount.toInt());
      },
    );

    // Clear and preload next ad
    _rewardedAd = null;
    adLoading();
  }
}
