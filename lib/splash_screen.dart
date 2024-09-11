import 'package:flutter/material.dart';
import 'package:parkx/api/user_repository.dart';
import 'package:parkx/utils/account_manager.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/utils/wallet_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _showIntro;

  @override
  void initState() {
    super.initState();

    _showIntro = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('intro') ?? 0;
    });

    Future.delayed(const Duration(milliseconds: 2200), () {
      // ignore: unrelated_type_equality_checks
      if (_showIntro == 1) {
        _gotoIntro();
      } else {
        _goToOnboardingOrLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<int>(
            future: _showIntro,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF3422B8),
                    Color(0xFF170F52),
                  ],
                )),
                child: const Center(child: SizedBox(child: Image(image: AssetImage('assets/images/logo.png')))),
              );
            }));
  }

  void _gotoIntro() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      // Guardando para que no se vuelva a mostrar el intro
      prefs.setInt('intro', 1).then((bool success) async {
        Navigator.of(context).pushReplacementNamed('/intro');
      });
    });
  }

  void _goToOnboardingOrLogin() async {
    try {
      final token = await AccountManager.instance.authToken;
      if (token != null) {
        UserRepository().getCurrentUser().then((user) async {
          if (user != null) {
            await getWallet(context);
            if (!mounted) return;
            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            _goLogin();
          }
        }, onError: (_) {
          _goLogin();
        });
      } else {
        _goLogin();
      }
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, message: e.toString());
      print(e);
    }
  }

  void _goLogin() {
    AccountManager.instance.clearAuth();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
