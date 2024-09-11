import 'package:parkx/app.dart';
import 'package:parkx/env.dart';
import 'package:parkx/utils/account_manager.dart';
import 'package:parkx/utils/flavor_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() {
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = merchantIdApplePay;
  WidgetsFlutterBinding.ensureInitialized();
  AccountManager.instance.configure().then((_) {
    FlavorConfig(
      flavor: Flavor.staging,
      values: const FlavorValues(appName: parkxAppName, hostName: 'vps-10121c7f.vps.ovh.ca', scheme: 'https'),
    );
    runApp(const MyApp());
  });
}
