import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkx/api/transaction_repository.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/border_decoration.dart';
import 'package:parkx/widgets/appbar.dart';

class AbonosScreen extends StatefulWidget {
  const AbonosScreen({super.key});
  static const routeName = '/abonos';

  @override
  State<AbonosScreen> createState() => _AbonosScreenState();
}

class _AbonosScreenState extends State<AbonosScreen> {
  int showTab = 1;

  // Para paginación
  final ScrollController _scrollController = ScrollController();
  List<dynamic> abonos = [];
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    _fetchAbonos();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !isLoading && !isLastPage) {
        _fetchAbonos();
      }
    });
  }

  Future<void> _fetchAbonos() async {
    if (isLoading || isLastPage) return;
    setState(() => isLoading = true);
    try {
      final response = await TransactionRepository().getAbonos(currentPage, 15);
      final data = response['data'] as List<dynamic>;
      final meta = response;
      setState(() {
        abonos.addAll(data);
        currentPage = meta['current_page'] + 1;
        lastPage = meta['last_page'];
        isLastPage = meta['next_page_url'] == null;
      });
    } catch (e) {
      // Manejo de error opcional
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: 'Historial de Abonos',
        withBackButton: true,
        function: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SizedBox(width: double.infinity, child: Column(children: [Expanded(child: _abonosList())])),
      ),
    );
  }

  Widget _abonosList() {
    if (abonos.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (abonos.isEmpty) {
      return const Center(child: Text('No hay abonos.'));
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: abonos.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == abonos.length) {
          return const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Center(child: CircularProgressIndicator()));
        }
        final abono = abonos[index];
        return _row(
          'TRANSACCIÓN #${abono['id']}',
          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(abono['created_at'])),
          abono['metodo_pago'] == 'card'
              ? 'Tarjeta de crédito/débito'
              : abono['metodo_pago'] == 'oxxo'
              ? 'Pago en OXXO'
              : abono['metodo_pago'] == 'customer_balance'
              ? 'Transferencia Bancaria'
              : abono['metodo_pago'] ?? 'Otro',
          '\$${abono['monto']}',
        );
      },
    );
  }

  Widget _row(transaccion, fecha, lugar, monto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: boxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaccion, style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(fecha, style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(lugar, style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            Text(monto, style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
