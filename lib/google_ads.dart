import 'dart:async';
import 'package:flutter/foundation.dart';
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
    _cooldownTimer = Timer(const Duration(minutes: 5), () {
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
