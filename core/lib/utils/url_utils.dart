import 'package:url_launcher/url_launcher.dart' as launch;

Future<bool> launchUrl({required String url}) async {
  final uri = Uri.parse(url);
  if (await launch.canLaunchUrl(uri)) {
    return await launch.launchUrl(uri);
  }
  return false;
}
