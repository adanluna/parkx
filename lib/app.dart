import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parkx/providers/parking_provider.dart';
import 'package:parkx/providers/parkings_provider.dart';
import 'package:parkx/providers/preguntas_provider.dart';
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
import 'package:parkx/screens/profile/abonos.dart';
import 'package:parkx/screens/profile/pagos.dart';
import 'package:parkx/screens/profile/billing.dart';
import 'package:parkx/screens/profile/billing_update.dart';
import 'package:parkx/screens/profile/delete_account.dart';
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
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayColor: Colors.black.withOpacity(0.5),
      overlayWidgetBuilder: (_) {
        return const Center(child: CircularProgressIndicator(color: AppTheme.secondaryColor, strokeWidth: 4));
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ParkingProvider>(create: (_) => ParkingProvider()),
          ChangeNotifierProvider<WalletProvider>(create: (_) => WalletProvider()),
          ChangeNotifierProvider<ParkingsProvider>(create: (_) => ParkingsProvider()),
          ChangeNotifierProvider(create: (_) => PreguntasProvider()),
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
            themeMode: ThemeMode.light,
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
                      return CodeValidationScreen(email: arguments?['email'] as String);
                    case PasswordRecoveryScreen.routeName:
                      return const PasswordRecoveryScreen();
                    case PasswordValidationScreen.routeName:
                      return PasswordValidationScreen(email: arguments?['email'] as String);
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
                      return PaymentSuccessScreen(
                        total: arguments?['total'] as int,
                        comision: arguments?['comision'] as int,
                        subtotal: arguments?['subtotal'] as int,
                        descuento: arguments?['descuento'] as int,
                        cupon: arguments?['cupon'] as String,
                      );
                    case ParkingSearchScreen.routeName:
                      return ParkingSearchScreen(manual: arguments?['manual'] as bool, code: arguments?['code'] as String);
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
                      return OxxoFinishScreen(
                        amount: arguments?['amount'] as String,
                        voucherUrl: arguments?['voucherUrl'] as String,
                        expiresAt: arguments?['expiresAt'] as String,
                      );
                    case SpeiAddScreen.routeName:
                      return const SpeiAddScreen();
                    case SpeiFinishScreen.routeName:
                      return SpeiFinishScreen(amount: arguments?['amount'] as String, urlPayment: arguments?['urlPayment'] as String);
                    case CreditCardAddScreen.routeName:
                      return const CreditCardAddScreen();
                    case PrepaidAddScreen.routeName:
                      return const PrepaidAddScreen();
                    case PrepaidFinishScreen.routeName:
                      return PrepaidFinishScreen(amount: arguments?['amount'] as String);
                    /***** Profile  ****/
                    case ProfileScreen.routeName:
                      return const ProfileScreen();
                    case PersonalDataScreen.routeName:
                      return const PersonalDataScreen();
                    case PersonalDataUpdateScreen.routeName:
                      return const PersonalDataUpdateScreen();
                    case AbonosScreen.routeName:
                      return const AbonosScreen();
                    case PagosScreen.routeName:
                      return const PagosScreen();
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
      ),
    );
  }
}
