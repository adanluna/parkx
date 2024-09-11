import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parkx/providers/parking_provider.dart';
import 'package:parkx/providers/wallet_provider.dart';
import 'package:parkx/screens/auth/code_validation_screen.dart';
import 'package:parkx/screens/auth/password_recovery_screen.dart';
import 'package:parkx/screens/auth/password_success_screen.dart';
import 'package:parkx/screens/auth/password_validation_screen.dart';
import 'package:parkx/screens/help/help_screen.dart';
import 'package:parkx/screens/home_screen.dart';
import 'package:parkx/screens/intro_screen.dart';
import 'package:parkx/screens/auth/login_screen.dart';
import 'package:parkx/screens/parking/manual_scanner_screen.dart';
import 'package:parkx/screens/parking/onboard_screen.dart';
import 'package:parkx/screens/auth/register_screen.dart';
import 'package:parkx/screens/parking/parking_search_screen.dart';
import 'package:parkx/screens/parking/payment_screen.dart';
import 'package:parkx/screens/parking/payment_success_screen.dart';
import 'package:parkx/screens/profile/billing.dart';
import 'package:parkx/screens/profile/billing_update.dart';
import 'package:parkx/screens/profile/delete_account.dart';
import 'package:parkx/screens/profile/historical.dart';
import 'package:parkx/screens/profile/notifications.dart';
import 'package:parkx/screens/profile/personal_data.dart';
import 'package:parkx/screens/profile/personal_data_update.dart';
import 'package:parkx/screens/profile/profile.dart';
import 'package:parkx/screens/profile/sessions.dart';
import 'package:parkx/screens/profile/settings.dart';
import 'package:parkx/screens/scanner_screen.dart';
import 'package:parkx/screens/tickets/error_parking_screen.dart';
import 'package:parkx/screens/tickets/not_found_parking_screen.dart';
import 'package:parkx/screens/tickets/not_found_ticket_screen.dart';
import 'package:parkx/screens/wallet/credit_card_add.dart';
import 'package:parkx/screens/wallet/oxxo_add.dart';
import 'package:parkx/screens/wallet/oxxo_finish.dart';
import 'package:parkx/screens/wallet/prepaid_add.dart';
import 'package:parkx/screens/wallet/prepaid_finish.dart';
import 'package:parkx/screens/wallet/spei_add.dart';
import 'package:parkx/screens/wallet/spei_finish.dart';
import 'package:parkx/screens/wallet/wallet.dart';
import 'package:parkx/splash_screen.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loader_overlay/loader_overlay.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 50)
      ..maskColor = Colors.blue.withOpacity(1);
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
        overlayColor: Colors.black.withOpacity(0.5),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ParkingProvider>(create: (_) => ParkingProvider()),
            ChangeNotifierProvider<WalletProvider>(create: (_) => WalletProvider()),
          ],
          builder: (BuildContext context, Widget? child) {
            return MaterialApp(
              restorationScopeId: 'app-parkx',
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: EasyLoading.init(),
              supportedLocales: const [Locale('es', ''), Locale('en', '')],
              theme: AppTheme.theme,
              title: "Parkx",
              onGenerateRoute: (RouteSettings settings) {
                final arguments = (settings.arguments != null) ? settings.arguments as Map<String, dynamic> : null;
                return MaterialPageRoute<void>(
                  settings: settings,
                  builder: (BuildContext context) {
                    switch (settings.name) {
                      case IntroScreen.routeName:
                        return const IntroScreen();
                      /**** Auth ****/
                      case HomeScreen.routeName:
                        return const HomeScreen();
                      case OnboardScreen.routeName:
                        return const OnboardScreen();
                      case RegisterScreen.routeName:
                        return const RegisterScreen();
                      case CodeValidationScreen.routeName:
                        return const CodeValidationScreen();
                      case PasswordRecoveryScreen.routeName:
                        return const PasswordRecoveryScreen();
                      case PasswordValidationScreen.routeName:
                        return const PasswordValidationScreen();
                      case PasswordSuccessScreen.routeName:
                        return const PasswordSuccessScreen();
                      /***** Scanner Ticket  ****/
                      case ScannerScreen.routeName:
                        return const ScannerScreen();
                      case ManualScannerScreen.routeName:
                        return const ManualScannerScreen();
                      case PaymentScreen.routeName:
                        return PaymentScreen(code: arguments?['code'] as String);
                      case PaymentSuccessScreen.routeName:
                        return const PaymentSuccessScreen();
                      case ParkingSearchScreen.routeName:
                        return const ParkingSearchScreen();
                      case NotFoundParkingScreen.routeName:
                        return const NotFoundParkingScreen();
                      case ErrorParkingScreen.routeName:
                        return const ErrorParkingScreen();
                      case NotFoundTicketScreen.routeName:
                        return const NotFoundTicketScreen();
                      /***** Wallet  ****/
                      case WalletScreen.routeName:
                        return const WalletScreen();
                      case OxxoAddScreen.routeName:
                        return const OxxoAddScreen();
                      case OxxoFinishScreen.routeName:
                        return OxxoFinishScreen(amount: arguments?['amount'] as num);
                      case SpeiAddScreen.routeName:
                        return const SpeiAddScreen();
                      case SpeiFinishScreen.routeName:
                        return const SpeiFinishScreen();
                      case CreditCardAddScreen.routeName:
                        return const CreditCardAddScreen();
                      case PrepaidAddScreen.routeName:
                        return const PrepaidAddScreen();
                      case PrepaidFinishScreen.routeName:
                        return const PrepaidFinishScreen();
                      /***** Profile  ****/
                      case ProfileScreen.routeName:
                        return const ProfileScreen();
                      case PersonalDataScreen.routeName:
                        return const PersonalDataScreen();
                      case PersonalDataUpdateScreen.routeName:
                        return const PersonalDataUpdateScreen();
                      case HistoricalScreen.routeName:
                        return const HistoricalScreen();
                      case BillingScreen.routeName:
                        return const BillingScreen();
                      case BillingUpdateScreen.routeName:
                        return const BillingUpdateScreen();
                      case SettingsScreen.routeName:
                        return const SettingsScreen();
                      case NotificationsScreen.routeName:
                        return const NotificationsScreen();
                      case SessionsScreen.routeName:
                        return const SessionsScreen();
                      case DeleteAccountScreen.routeName:
                        return const DeleteAccountScreen();
                      /****** Help ******/
                      case HelpScreen.routeName:
                        return const HelpScreen();
                      /*****************/
                      case LoginScreen.routeName:
                      default:
                        return const LoginScreen();
                    }
                  },
                );
              },
              home: const SplashScreen(),
              navigatorObservers: <NavigatorObserver>[routeObserver],
            );
          },
        ));
  }
}
