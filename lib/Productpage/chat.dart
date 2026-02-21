import 'package:url_launcher/url_launcher.dart';

Future<void> openWhatsApp(String phoneNumber) async {

  const String message = 'Hello, I need help';

  final Uri whatsappUrl = Uri.parse(
    "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}"
  );

 if (!await launchUrl(
    whatsappUrl,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not open WhatsApp';
  }
}
