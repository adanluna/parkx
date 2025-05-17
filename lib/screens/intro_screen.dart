import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:parkx/utils/app_theme.dart';

final List<String> imgList = [
  '',
  'intro1.png',
  'intro2.png',
  'intro3.png',
];

final List<String> textList = [
  '',
  'Carga saldo a la App Parkx por medio de tarjeta de crédito o débito, efectivo en OXXO o SPEI.',
  'Con tu App Parkx puedes escanear tu boleto y saber cuanto pagarás en cualquier momento.',
  'Con la App Parkx pagarás tu boleto mientas caminas hacia tu auto, listo para salir.',
];

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  static const routeName = '/intro';

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final CarouselSliderController _controller = CarouselSliderController();
  late List<Widget> imageSliders = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      final double height = MediaQuery.of(context).size.height;
      imageSliders = [
        tarjeta(1, 'Olvídate del efectivo', 'Pre-carga salgo a la App Parkx'),
        tarjeta(2, 'Monitorea tu pago', 'Escanéa tu boleto y ve cuanto pagarías'),
        tarjeta(3, 'No más filas en cajero', 'Evita filas de fin de semana')
      ];
      return Column(
        children: <Widget>[
          CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(enlargeCenterPage: false, height: height, viewportFraction: 1.0, enableInfiniteScroll: false),
            carouselController: _controller,
          ),
        ],
      );
    }));
  }

  Widget tarjeta(index, titulo, subtitulo) {
    return Column(children: [
      Expanded(
        flex: 1,
        child: Image(image: AssetImage('assets/images/${imgList[index]}'), fit: BoxFit.cover),
      ),
      Expanded(
          flex: 1,
          child: SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  titulo,
                  style: AppTheme.theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  subtitulo,
                  style: AppTheme.theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(textList[index], textAlign: TextAlign.center, style: AppTheme.theme.textTheme.bodyMedium),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: (index == 1) ? AppTheme.primaryColor : AppTheme.accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: (index == 2) ? AppTheme.primaryColor : AppTheme.accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: (index == 3) ? AppTheme.primaryColor : AppTheme.accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: AppTheme.theme.elevatedButtonTheme.style,
                    onPressed: () => (index == 3) ? _goLogin() : _controller.nextPage(),
                    child: const Text('Siguiente'),
                  ),
                ),
                SizedBox(
                  height: (index != 3) ? 15 : 0,
                ),
                (index != 3)
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: AppTheme.theme.outlinedButtonTheme.style,
                          onPressed: () => _goLogin(),
                          child: const Text('Saltar'),
                        ),
                      )
                    : Container()
              ],
            ),
          ))),
    ]);
  }

  _goLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
