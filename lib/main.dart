import 'package:parkx/app.dart';
import 'package:parkx/env.dart';
import 'package:parkx/utils/account_manager.dart';
import 'package:parkx/utils/flavor_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = merchantIdApplePay;
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  AccountManager.instance.configure().then((_) {
    FlavorConfig(
      flavor: Flavor.staging,
      values: const FlavorValues(appName: parkxAppName, hostName: 'vps-10121c7f.vps.ovh.ca', scheme: 'https'),
      //values: const FlavorValues(appName: parkxAppName, hostName: '127.0.0.1', scheme: 'http'),
    );
    runApp(const MyApp());
  });
}
