import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Central AdMob manager.
///
/// ⚠️ IMPORTANT (Play Store policy + AdMob policy):
/// - These are Google's TEST ad unit IDs. Replace with your real IDs
///   from admob.google.com BEFORE publishing, or your account can be
///   suspended for invalid traffic.
/// - Never place a banner/interstitial in a way that overlaps or is
///   confused with the Connect button — accidental clicks violate
///   AdMob policy.
/// - Rewarded ads are the best fit for a VPN app: "Watch an ad to
///   unlock a premium server for 30 minutes" — this is how most large
///   free VPN apps (e.g. those you're benchmarking against) monetize.
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  // TEST IDs — replace before release. See README "Step 5: AdMob".
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  Future<void> init() async {
    await MobileAds.instance.initialize();
    _loadInterstitial();
    _loadRewarded();
  }

  BannerAd createBannerAd({required void Function() onLoaded}) {
    final banner = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded(),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
    banner.load();
    return banner;
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (_) => _interstitialAd = null,
      ),
    );
  }

  /// Show an interstitial AFTER a disconnect (never during connect flow —
  /// interrupting a security action feels deceptive and hurts retention).
  void showInterstitialAfterDisconnect() {
    _interstitialAd?.show();
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadInterstitial();
      },
    );
  }

  void _loadRewarded() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (_) => _rewardedAd = null,
      ),
    );
  }

  /// "Watch ad to unlock a premium (faster/foreign) server for 30 min."
  /// This is the main revenue driver — clearly label it so it stays
  /// AdMob & Play policy compliant (user must explicitly opt in).
  void showRewardedForServerUnlock({required void Function() onReward}) {
    if (_rewardedAd == null) return;
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewarded();
      },
    );
    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) => onReward(),
    );
  }
}
