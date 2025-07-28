import 'package:url_launcher/url_launcher.dart' as launch;

launchUrl({required String url}) async {
  final uri = Uri.parse(url);
  if (await launch.canLaunchUrl(uri)) {
    await launch.launchUrl(uri);
  }
}
