import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_to_pdf_converter/constants/constant_ad_ids.dart';

class AdsController extends GetxController {
  final Rx<BannerAd?> _bannerAd = Rx<BannerAd?>(null);
  final Rx<BannerAd?> _bannerAd2 = Rx<BannerAd?>(null);

  final Rx<InterstitialAd?> _interstitialAd = Rx<InterstitialAd?>(null);
   final Rx<AppOpenAd?> _appOpenAd = Rx<AppOpenAd?>(null);

  final _isInterstitialAdReady = false.obs;
  final _isBannerAdReady = false.obs;
  final _isBannerAd2Ready = false.obs;
  final _isAppOpenAdReady = false.obs;
  final _isLoadingOpenAd = false.obs;

  bool get isInterstitialAdReady => _isInterstitialAdReady.value;
  bool get isAppOpenAdReady => _isAppOpenAdReady.value;
  bool get isBannerAdReady => _isBannerAdReady.value;
  bool get isBannerAd2Ready => _isBannerAd2Ready.value;
  bool get isLoadingOpenAd => _isLoadingOpenAd.value;

  InterstitialAd? get interstitialAd => _interstitialAd.value;

  BannerAd? get bannerAd => _bannerAd.value;
  BannerAd? get bannerAd2 => _bannerAd2.value;

  @override
  void onInit() {
    super.onInit();
       loadAppOpenAd();
    

    _bannerAd.value = loadBannerAd(isHomeBanner: true);
    _bannerAd.value?.load();
    loadInterstitialAd();
  }

  BannerAd loadBannerAd({bool? isHomeBanner}) {
    return BannerAd(
        size: AdSize.banner,
        adUnitId: BANNER_AD ,
        listener: BannerAdListener(onAdLoaded: ((ad) {
          if (isHomeBanner == true) {
            _isBannerAdReady.value = true;
          } else {
            _isBannerAd2Ready.value = true;
          }

          print("banner ad loaded");
        }), onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (isHomeBanner == true) {
            _isBannerAdReady.value = false;
          } else {
            _isBannerAd2Ready.value = false;
          }
        }),
        request: const AdRequest());
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: INTERSTITIAL_AD ,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd.value = ad;
          _isInterstitialAdReady.value = true;
          print('Interstitial Ad loaded');
        },
        onAdFailedToLoad: (error) {
          print('Interstitial Ad failed to load: $error');
        },
      ),
    );
  }

  void loadAppOpenAd() async{
    if (_isAppOpenAdReady.value == true) return;
    _isLoadingOpenAd.value = true;
  
   await AppOpenAd.load(
      adUnitId: APP_OPEN_AD ,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
         
        onAdLoaded: (ad) {
          _isLoadingOpenAd.value = false;
          print("Ad Loadede.................................");
          _appOpenAd.value = ad;
          _isAppOpenAdReady.value = true;
          FlutterNativeSplash.remove();
           showAppOpenAd();
        },
        onAdFailedToLoad: (error) {
          _isLoadingOpenAd.value = false;
          FlutterNativeSplash.remove();
          // Handle the error.
        },
      ),
    );
  }

  void showAppOpenAd() {
    if (_appOpenAd.value == null) {
      print('Tried to show App Open Ad before loaded.');
      return;
    }
  
    _appOpenAd.value!.show();
    _appOpenAd.value?.dispose();
     _isAppOpenAdReady.value = false; 
  }

  void showInterstitialAd(Function? onComplete) {
    if (_interstitialAd.value == null) {
      print('Tried to show Interstitial Ad before loaded.');
      return;
    }
    _interstitialAd.value!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) =>
          print('Interstitial Ad onAdShowedFullScreenContent'),
      onAdDismissedFullScreenContent: (_) {
        print('Interstitial Ad onAdDismissedFullScreenContent');
        _interstitialAd.value!.dispose();
        loadInterstitialAd();
        _isInterstitialAdReady.value = false;
        if (onComplete != null) {
          onComplete();
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('Interstitial Ad onAdFailedToShowFullScreenContent: $error');
        _interstitialAd.value!.dispose();
        loadInterstitialAd();
      },
      onAdImpression: (_) => print('Interstitial Ad onAdImpression'),
    );
    _interstitialAd.value!.show();
    _isInterstitialAdReady.value = false;
  }

  void loadBannerAd2() {
    if (!_isBannerAd2Ready.value) {
      _bannerAd2.value = loadBannerAd();
      _bannerAd2.value?.load();
    }
  }

  @override
  void dispose() {
    _bannerAd.value?.dispose();
    _bannerAd2.value?.dispose();
    _interstitialAd.value!.dispose();
    _appOpenAd.value!.dispose();

    super.dispose();
  }
}
