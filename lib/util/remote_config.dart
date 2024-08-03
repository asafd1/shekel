import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfig {
  static const String reviewMode = "REVIEW_MODE";

  static final RemoteConfig _instance = RemoteConfig._internal();
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  factory RemoteConfig() {
    return _instance;
  }

  RemoteConfig._internal();

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await _remoteConfig.setDefaults(const {
      reviewMode: true,
    });

    _remoteConfig.onConfigUpdated.listen((event) async {
      await _remoteConfig.activate();
    });

    await _fetchAndActivate();
  }

  Future<void> _fetchAndActivate() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      FirebaseCrashlytics.instance.log("Failed to fetch remote config: $e");
    }
  }

  bool getReviewMode() => _remoteConfig.getBool(reviewMode);
}
