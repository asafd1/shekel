import 'package:flutter/services.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/util/app_state.dart';
import 'package:uni_links/uni_links.dart';

Future<void> initUniLinks() async {
  // Ensure this is called inside the `main` function.
  await initPlatformState();
}

Future<void> initPlatformState() async {
  // Listen for incoming links
    
  try {
    final initialLink = await getInitialLink();
    _handleDeepLink(initialLink);
  } on PlatformException {
    // Handle exceptions if any.
  }

  // Listen for incoming links while the app is running.
  linkStream.listen((String? link) {
    _handleDeepLink(link);
  }, onError: (err) {
    // Handle errors if any.
  });
}

void _handleDeepLink(String? deepLink) {
  if (deepLink == null) {
    return;
  }

  // Parse the deep link
  final uri = Uri.parse(deepLink);

  // Access the query parameters
  final String? familyId = uri.queryParameters['familyId'];
  
  AppState().goto(Routes.home, arguments: {'familyId': familyId});
}