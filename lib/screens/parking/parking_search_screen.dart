import 'package:flutter/material.dart';
import 'package:parkx/models/parking.dart';
import 'package:parkx/models/estado.dart';
import 'package:parkx/providers/parking_provider.dart';
import 'package:parkx/providers/parkings_provider.dart';
import 'package:parkx/utils/account_manager.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_parking.dart';
import 'package:provider/provider.dart';

class ParkingSearchScreen extends StatefulWidget {
  final bool manual;
  final String code;
  const ParkingSearchScreen({super.key, required this.manual, required this.code});

  static const routeName = '/parking_search';

  @override
  State<ParkingSearchScreen> createState() => _ParkingSearchScreenState();
}

class _ParkingSearchScreenState extends State<ParkingSearchScreen> {
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController buscarController = TextEditingController();

  List<Parking> estacionamientos = [];
  Estado? estadoSelected;
  final ValueNotifier<bool> showDropdown = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parkingsProvider = Provider.of<ParkingsProvider>(context, listen: false);
      final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);
      if (parkingsProvider.estados.isNotEmpty) {
        setState(() {
          estadoSelected = parkingProvider.estado;
          _getParkings();
        });
      }
    });

    buscarController.addListener(_onBuscarChanged);
  }

  void _onBuscarChanged() {
    final parkingsProvider = Provider.of<ParkingsProvider>(context, listen: false);
    final query = buscarController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      showDropdown.value = false;
      setState(() {
        estacionamientos =
            parkingsProvider.estados
                .expand((estado) => estado.estacionamientos)
                .where((parking) => parking.nombre.toLowerCase().contains(query))
                .toList();
      });
    } else {
      showDropdown.value = true;
      estadoSelected = parkingsProvider.estados[0];
      _getParkings();
    }
  }

  @override
  void dispose() {
    estadoController.dispose();
    buscarController.dispose();
    showDropdown.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parkingsProvider = Provider.of<ParkingsProvider>(context);
    return Scaffold(
      appBar: AppBarWidget(title: 'Buscar Estacionamiento', function: () => Navigator.of(context).pop(''), withBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppTheme.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: buscarController,
                  style: AppTheme.theme.textTheme.bodyMedium,
                  decoration: const InputDecoration(hintText: "Buscar por nombre"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Proporciona un nombre';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
              child: Text(
                'Selecciona el estacionamiento',
                style: AppTheme.theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: showDropdown,
              builder: (context, visible, child) {
                if (!visible || parkingsProvider.estados.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: SizedBox(
                    child: DropdownMenu<Estado>(
                      initialSelection: estadoSelected,
                      controller: estadoController,
                      width: 300,
                      textStyle: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                      inputDecorationTheme: InputDecorationTheme(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        constraints: BoxConstraints.tight(const Size.fromHeight(45)),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppTheme.primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSelected: (Estado? estado) {
                        estadoSelected = estado;
                        _getParkings();
                      },
                      dropdownMenuEntries:
                          parkingsProvider.estados.map((Estado estado) {
                            return DropdownMenuEntry<Estado>(
                              value: estado,
                              label: estado.nombre,
                              style: MenuItemButton.styleFrom(elevation: 0, textStyle: const TextStyle(fontSize: 14)),
                            );
                          }).toList(),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Text(
                (estadoSelected != null && showDropdown.value) ? estadoSelected!.nombre : '',
                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            (estacionamientos.isNotEmpty)
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children:
                        estacionamientos.map((Parking estacionamiento) {
                          return ButtonParking(
                            parking: estacionamiento,
                            function: () {
                              _selectParking(estacionamiento);
                            },
                          );
                        }).toList(),
                  ),
                )
                : const Padding(padding: EdgeInsets.only(top: 20), child: Text('No hay estacionamientos')),
          ],
        ),
      ),
    );
  }

  _getParkings() {
    if (estadoSelected == null) {
      setState(() {
        estacionamientos = [];
      });
      return;
    }
    final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);
    parkingProvider.estado = estadoSelected!;
    setState(() {
      AccountManager.instance.setEstado(estadoSelected!);
      estacionamientos = estadoSelected!.estacionamientos;
    });
  }

  void _selectParking(Parking estacionamiento) {
    final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);
    AccountManager.instance.setEstado(estadoSelected!);
    parkingProvider.parking = estacionamiento;
    parkingProvider.selected = true;
    if (!widget.manual) {
      Navigator.of(context).pushNamed('/payment', arguments: {'code': widget.code});
    } else {
      Navigator.of(context).pushNamed('/manual_scanner');
    }
  }
}
