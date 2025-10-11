// Web implementation using dart:html
import 'dart:html' as html;

String getCurrentUrl() {
  return html.window.location.href;
}

Map<String, String> getUrlParameters() {
  final uri = Uri.parse(html.window.location.href);
  return uri.queryParameters;
}