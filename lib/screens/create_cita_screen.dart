import 'package:flutter/material.dart';
import '../models/cita.dart';
import '../services/cita_service.dart';

class CreateCitaScreen extends StatefulWidget {
  const CreateCitaScreen({super.key});

  @override
  _CreateCitaScreenState createState() => _CreateCitaScreenState();
}

class _CreateCitaScreenState extends State<CreateCitaScreen> {
  final _formKey = GlobalKey<FormState>();
  final CitaService _citaService = CitaService();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _servicioController = TextEditingController();

  String _servicioSeleccionado = 'Corte de cabello'; // Valor inicial
  final List<String> _servicios = ['Corte de cabello', 'Barba']; // Servicios

  // Datos de prueba para clientes y barberos
  final int _clienteSeleccionado =
      2; // ID de cliente autenticado (esto debería obtenerse dinámicamente)
  int _barberoSeleccionado = 3; // Barbero seleccionado (ejemplo estático)
  final List<Map<String, dynamic>> _barberos = [
    {'id': 1, 'nombre': 'Barbero 1'},
    {'id': 2, 'nombre': 'Barbero 2'},
    {'id': 3, 'nombre': 'Barbero 3'},
  ];

  Future<void> _seleccionarFecha() async {
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (fechaSeleccionada != null) {
      setState(() {
        _fechaController.text =
            fechaSeleccionada.toString().substring(0, 10); // Formato YYYY-MM-DD
      });
    }
  }

  Future<void> _seleccionarHora() async {
    TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (horaSeleccionada != null) {
      setState(() {
        _horaController.text =
            horaSeleccionada.format(context); // Formato HH:MM
      });
    }
  }

  Future<void> _crearCita() async {
    if (_formKey.currentState!.validate()) {
      Cita nuevaCita = Cita(
        id: 0, // Este campo se genera automáticamente
        fecha: _fechaController.text,
        hora: _horaController.text,
        nota: _servicioSeleccionado, // Usamos el servicio seleccionado
        estado: 'pendiente',
        idCliente: _clienteSeleccionado, // ID del cliente autenticado
        idBarbero: _barberoSeleccionado, // ID del barbero seleccionado
      );

      try {
        await _citaService.crearCita(nuevaCita);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cita creada exitosamente')),
        );
        Navigator.pop(
            context); // Volver a la pantalla anterior después de crear la cita
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear cita')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Nueva Cita')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _fechaController,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _seleccionarFecha,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona una fecha';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _horaController,
                decoration: InputDecoration(
                  labelText: 'Hora',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: _seleccionarHora,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona una hora';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _servicioSeleccionado,
                decoration: const InputDecoration(labelText: 'Servicio'),
                items: _servicios.map((String servicio) {
                  return DropdownMenuItem<String>(
                    value: servicio,
                    child: Text(servicio),
                  );
                }).toList(),
                onChanged: (String? nuevoServicio) {
                  setState(() {
                    _servicioSeleccionado = nuevoServicio!;
                  });
                },
              ),
              DropdownButtonFormField<int>(
                value: _barberoSeleccionado,
                decoration:
                    const InputDecoration(labelText: 'Seleccionar Barbero'),
                items: _barberos.map((barbero) {
                  return DropdownMenuItem<int>(
                    value: barbero['id'],
                    child: Text(barbero['nombre']),
                  );
                }).toList(),
                onChanged: (int? nuevoBarbero) {
                  setState(() {
                    _barberoSeleccionado = nuevoBarbero!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _crearCita,
                child: const Text('Crear Cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
