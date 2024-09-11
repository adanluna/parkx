import 'package:meta/meta.dart' show required;

enum Flavor { development, staging, production }

class FlavorValues {
  const FlavorValues({required this.appName, required this.hostName, this.port, this.scheme = 'https'});

  final String appName;
  final String hostName;
  final int? port;
  final String scheme;

  String url({@required String? path}) {
    return "$scheme://$hostName$path";
  }
}

class FlavorConfig {
  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
  }) {
    instance = FlavorConfig._internal(flavor, values);
    return instance;
  }

  FlavorConfig._internal(this.flavor, this.values);

  final Flavor flavor;
  final FlavorValues values;

  static late FlavorConfig instance;

  /// Is the app in `staging` phase.
  static bool isDevelopment() => instance.flavor == Flavor.development || instance.flavor == Flavor.staging;

  /// Is the app in `production` phase.
  static bool isProduction() => instance.flavor == Flavor.production;
}
