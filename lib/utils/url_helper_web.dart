// Web implementation using package:web
import 'package:web/web.dart' as web;

String getCurrentUrl() {
  return web.window.location.href;
}

Map<String, String> getUrlParameters() {
  final uri = Uri.parse(web.window.location.href);
  return uri.queryParameters;
}