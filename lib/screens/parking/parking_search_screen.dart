import 'package:flutter/material.dart';
import 'package:parkx/api/parking_repository.dart';
import 'package:parkx/models/parking.dart';
import 'package:parkx/models/state.dart';
import 'package:parkx/providers/parking_provider.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_parking.dart';
import 'package:provider/provider.dart';

class ParkingSearchScreen extends StatefulWidget {
  const ParkingSearchScreen({super.key});

  static const routeName = '/parking_search';

  @override
  State<ParkingSearchScreen> createState() => _ParkingSearchScreenState();
}

class _ParkingSearchScreenState extends State<ParkingSearchScreen> {
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController buscarController = TextEditingController();
  late List<StateModel> estados = [];
  late List<Parking> estacionamientos = [];
  late StateModel? estadoSelected;
  bool loading = true;

  @override
  void initState() {
    estadoSelected = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getStates();
    });

    super.initState();
  }

  @override
  void dispose() {
    estadoController.dispose();
    buscarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Buscar Estacionamiento',
          function: () => Navigator.of(context).pop(''),
          withBackButton: true,
        ),
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
                      decoration: const InputDecoration(
                        hintText: "Buscar por nombre",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Proporciona un nombre';
                        }
                        return null;
                      },
                    ))),
            (estados.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: SizedBox(
                      child: DropdownMenu<StateModel>(
                        initialSelection: estados[0],
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
                        onSelected: (StateModel? estado) {
                          setState(() {
                            estadoSelected = estado;
                            _getParkings();
                          });
                        },
                        dropdownMenuEntries: estados.map((StateModel estado) {
                          return DropdownMenuEntry<StateModel>(
                            value: estado,
                            label: estado.name,
                            style: MenuItemButton.styleFrom(elevation: 0, textStyle: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                : Container(),
            Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 20),
                child: Text(
                  (estadoSelected != null) ? estadoSelected!.name : '',
                  style: AppTheme.theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                )),
            (estacionamientos.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: estacionamientos.map((Parking estacionamiento) {
                        return ButtonParking(
                          title: estacionamiento.name,
                          distance: '${estacionamiento.distance} km',
                          function: () {
                            _selectParking(estacionamiento);
                          },
                        );
                      }).toList(),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 20), child: (loading) ? const Text('Cargando...') : const Text('No hay estacionamientos'))
          ],
        )));
  }

  _getStates() async {
    await ParkingRepository().getStates().then((states) async {
      if (states!.isNotEmpty) {
        setState(() {
          estadoSelected = states[0];
          estados = states;
          estacionamientos = [];
          _getParkings();
        });
      }
    }, onError: (error) {
      showErrorDialog(context, message: error.message);
    });
  }

  _getParkings() async {
    setState(() {
      estacionamientos = [];
      loading = true;
    });
    await ParkingRepository().searchState(estadoId: estadoSelected!.id, municipioId: 0).then((parkings) async {
      setState(() {
        loading = false;
      });
      if (parkings!.isNotEmpty) {
        setState(() {
          estacionamientos = parkings;
        });
      }
    }, onError: (error) {
      print(error);
      showErrorDialog(context, message: error.message);
    });
  }

  void _selectParking(Parking estacionamiento) {
    final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);
    parkingProvider.parking = estacionamiento;
    parkingProvider.selected = true;
    Navigator.of(context).pop(estacionamiento.name);
  }
}
