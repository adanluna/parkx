import 'package:parkx/models/estado.dart';
import 'package:parkx/providers/parkings_provider.dart';
import 'package:parkx/providers/parking_provider.dart';
import 'package:parkx/providers/preguntas_provider.dart';
import 'package:parkx/utils/account_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

Future<Estado?> seleccionarYActualizarEstado(BuildContext context) async {
  await Provider.of<PreguntasProvider>(context, listen: false).fetchPreguntas(); // Cargar preguntas frecuentes
  await Provider.of<ParkingsProvider>(context, listen: false).fetchEstados(); // Cargar estados
  var parkingsProvider = Provider.of<ParkingsProvider>(context, listen: false); // Obtener el provider de parkings

  // Obtener el id guardado (si existe)
  final estadoId = await AccountManager.instance.getEstadoId();
  Estado? estadoSeleccionado;

  if (estadoId != null) {
    estadoSeleccionado = parkingsProvider.estados.firstWhere((e) => e.id == estadoId, orElse: () => parkingsProvider.estados[0]);
  } else {
    estadoSeleccionado = parkingsProvider.estados.isNotEmpty ? parkingsProvider.estados[0] : null;
  }

  if (estadoSeleccionado != null) {
    await AccountManager.instance.setEstado(estadoSeleccionado);
    Provider.of<ParkingProvider>(context, listen: false).estado = estadoSeleccionado;
  }
  return estadoSeleccionado;
}
