import 'package:flutter/material.dart';
import '../services/ProductoService.dart';
import '../models/producto.dart';

class ProductDetailScreen extends StatefulWidget {
  final Producto producto;

  const ProductDetailScreen({super.key, required this.producto});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late Producto producto;

  final List<String> categorias = ['Electrónica', 'Ropa', 'Alimentos', 'Hogar'];

  @override
  void initState() {
    super.initState();
    producto = Producto.fromJson(widget.producto.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Producto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                  'Nombre', producto.nombre, (value) => producto.nombre = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio' : null),
              _buildTextField('Descripción', producto.descripcion,
                  (value) => producto.descripcion = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio' : null),
              _buildTextField('Precio', producto.precio.toString(),
                  (value) => producto.precio = double.tryParse(value) ?? 0,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio' : null),
              _buildTextField('Stock', producto.stock.toString(),
                  (value) => producto.stock = double.tryParse(value) ?? 0,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio' : null),
              _buildTextField('Unidad de Medida', producto.unidadMedida,
                  (value) => producto.unidadMedida = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio' : null),
              _buildTextField(
                  'Fecha de Ingreso',
                  producto.fechaIngreso != null
                      ? producto.fechaIngreso!
                          .toLocal()
                          .toString()
                          .split(' ')[0]
                      : '',
                  (value) => producto.fechaIngreso =
                      DateTime.tryParse(value) ?? DateTime.now(),
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio' : null),
              _buildTextField(
                  'Fecha de Expiración',
                  producto.fechaExpiracion != null
                      ? producto.fechaExpiracion!
                          .toLocal()
                          .toString()
                          .split(' ')[0]
                      : '',
                  (value) =>
                      producto.fechaExpiracion = DateTime.tryParse(value),
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio' : null),
              _buildDropdown(
                  'Categoría',
                  producto.categoria
                      .nombre, // Asegurarse de que se pase el nombre de la categoría
                  categorias, (value) {
                setState(() {
                  // Aquí deberías actualizar el objeto categoría según el nombre seleccionado
                  producto.categoria = Categoria(
                      idCategoria: producto.categoria.idCategoria,
                      nombre: value ?? categorias[0]);
                });
              },
                  validator: (value) =>
                      value == null ? 'Este campo es obligatorio' : null),
              SwitchListTile(
                title: const Text('Activo'),
                value: producto.estado == 1,
                onChanged: (value) =>
                    setState(() => producto.estado = value ? 1 : 0),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarCambios,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String initialValue, Function(String) onChanged,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator}) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildDropdown(String label, String currentValue, List<String> options,
      Function(String?) onChanged,
      {String? Function(String?)? validator}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: currentValue,
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  void _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ProductoService()
            .actualizarProducto(producto.idProducto, producto);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto actualizado')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar producto: $e')),
        );
      }
    }
  }
}
