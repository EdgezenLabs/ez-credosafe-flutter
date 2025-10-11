import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional imports for web-specific functionality
import 'url_helper_stub.dart'
    if (dart.library.html) 'url_helper_web.dart' as url_helper;

class UrlHelper {
  static String getCurrentUrl() {
    if (kIsWeb) {
      return url_helper.getCurrentUrl();
    }
    return '';
  }
  
  static Map<String, String> getUrlParameters() {
    if (kIsWeb) {
      return url_helper.getUrlParameters();
    }
    return {};
  }
}