import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:parkx/api/wallet_repository.dart';
import 'package:parkx/models/credit_card.dart';
import 'package:parkx/providers/wallet_provider.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_prepaid.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';

class PrepaidAddScreen extends StatefulWidget {
  const PrepaidAddScreen({super.key});

  static const routeName = '/prepaid_add';

  @override
  State<PrepaidAddScreen> createState() => _PrepaidAddScreenState();
}

class _PrepaidAddScreenState extends State<PrepaidAddScreen> {
  bool validAmount = false;
  CreditCard? paymentCard;
  int amount = 100;
  bool hasBonus = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Abona a prepago',
        withBackButton: true,
        function: () {
          Navigator.of(context).pop('');
        },
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Selecciona la cantidad a abonar a tu cuenta Parkx',
                    textAlign: TextAlign.center,
                    style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold, height: 1.1),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: const BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    '$amount MXN',
                    style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                      height: 1.1,
                    ),
                  ),
                ),
                (hasBonus)
                    ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: const BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        'Recibe un 5% en tu primer abono',
                        style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                          height: 1.1,
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
                const SizedBox(height: 15),
                Expanded(
                  child: Container(
                    color: AppTheme.primaryColor,
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 130),
                        child: Column(
                          children:
                              [1, 2, 3, 4, 5, 6, 7, 8, 9]
                                  .map(
                                    (index) => ButtonPrepaid(
                                      title: '\$${index * 100}',
                                      isSelected: (index * 100 == amount) ? true : false,
                                      subtitle: (hasBonus) ? '(\$${((index * 100) * .05).toStringAsFixed(0)} GRATIS)' : '',
                                      function: () {
                                        setState(() {
                                          amount = index * 100;
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          height: 55,
                          child: DropdownButtonFormField2<CreditCard>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            hint: const Text('Selecciona una tarjeta', style: TextStyle(fontSize: 14)),
                            items:
                                walletProvider.wallet?.cards!
                                    .map(
                                      (CreditCard card) => DropdownMenuItem<CreditCard>(
                                        value: card,
                                        child: Text(
                                          '****${card.last4} ${card.brand.toUpperCase()} - ${(card.expMonth < 10) ? '0' : ''}${card.expMonth}/${card.expYear}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Por favor selecciona una tarjeta.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                paymentCard = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                paymentCard = value;
                              });
                            },
                            buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
                            iconStyleData: const IconStyleData(icon: Icon(Icons.keyboard_arrow_down, color: Colors.black), iconSize: 26),
                            dropdownStyleData: DropdownStyleData(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15))),
                            menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 16)),
                          ),
                        ),
                      ),
                      ButtonSecondary(title: 'Abonar a mi cuenta Parkx', function: _addFunds),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goFinish() {
    Navigator.of(
      context,
    ).pushReplacementNamed('/prepaid_finish', arguments: {'amount': (hasBonus) ? (amount + (amount * .05)).toString() : amount.toString()});
  }

  void _addFunds() {
    if (amount == 0 || paymentCard == null) {
      showErrorDialog(context, message: 'Necesitas seleccionar el monto y la tarjeta');
    } else {
      context.loaderOverlay.show();
      WalletRepository()
          .addFunds(amount: (hasBonus) ? (amount + (amount * .05)).toString() : amount.toString(), cardId: paymentCard!.id)
          .then(
            (response) async {
              if (!mounted) return;
              context.loaderOverlay.hide();
              _goFinish();
            },
            onError: (error) {
              context.loaderOverlay.hide();
              print(error);
              showErrorDialog(context, message: error.message);
            },
          );
    }
  }
}
