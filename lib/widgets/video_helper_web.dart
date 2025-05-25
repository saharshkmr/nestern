import 'dart:html' as html;

String createObjectUrl(List<int> bytes) {
  final blob = html.Blob([bytes]);
  return html.Url.createObjectUrl(blob);
}
