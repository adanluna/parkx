import 'package:parkx/app.dart';
import 'package:parkx/env.dart';
import 'package:parkx/utils/account_manager.dart';
import 'package:parkx/utils/flavor_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = merchantIdApplePay;
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://99cf042ac17ba4770965c812264f0cb9@o4508497769988096.ingest.us.sentry.io/4509418659905536';
      options.sendDefaultPii = true;
    },
    appRunner:
        () => AccountManager.instance.configure().then((_) {
          FlavorConfig(flavor: Flavor.staging, values: const FlavorValues(appName: parkxAppName, hostName: 'admin.parkx.mx', scheme: 'https'));
          runApp(const MyApp());
        }),
  );
}
