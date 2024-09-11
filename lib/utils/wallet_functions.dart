import 'package:flutter/material.dart';
import 'package:parkx/api/wallet_repository.dart';
import 'package:parkx/models/wallet.dart';
import 'package:parkx/providers/wallet_provider.dart';
import 'package:provider/provider.dart';

getWallet(BuildContext context) async {
  final walletProvider = Provider.of<WalletProvider>(context, listen: false);
  Wallet? wallet = await WalletRepository().wallet();
  walletProvider.wallet = wallet;
}
