import 'package:flutter/material.dart';
import '../services/ProductoService.dart';
import '../models/producto.dart';

class ProductoCreateScreen extends StatefulWidget {
  @override
  _ProductoCreateScreenState createState() => _ProductoCreateScreenState();
}

class _ProductoCreateScreenState extends State<ProductoCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  // Definir el producto con valores predeterminados
  Producto producto = Producto(
    idProducto: 0,
    imagen: '',
    nombre: '',
    descripcion: '',
    precio: 0.0,
    stock: 0.0,
    unidadMedida: '',
    fechaIngreso: DateTime.now(),
    fechaExpiracion: null,
    estado: 1,
    categoria: Categoria(
      idCategoria: 0,
      nombre: '',
    ),
  );

  // Lista de categorías
  final List<Categoria> categorias = [
    Categoria(idCategoria: 1, nombre: 'Electrónica'),
    Categoria(idCategoria: 2, nombre: 'Ropa'),
    Categoria(idCategoria: 3, nombre: 'Alimentos'),
    Categoria(idCategoria: 4, nombre: 'Hogar'),
  ];

  @override
  void initState() {
    super.initState();
    producto.categoria = categorias[0]; // Inicializar con la primera categoría
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Producto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                'Nombre',
                (value) => producto.nombre = value,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              _buildTextField(
                'Descripción',
                (value) => producto.descripcion = value,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              _buildTextField(
                'Imagen (URL)',
                (value) => producto.imagen = value,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              Image.network(
                producto.imagen.isNotEmpty
                    ? producto.imagen
                    : 'https://via.placeholder.com/150',
                height: 150,
                width: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image,
                  size: 150,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Precio',
                (value) => producto.precio = double.tryParse(value) ?? 0.0,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              _buildTextField(
                'Stock',
                (value) => producto.stock = double.tryParse(value) ?? 0.0,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              _buildTextField(
                'Unidad de Medida',
                (value) => producto.unidadMedida = value,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              _buildTextField(
                'Fecha de Ingreso',
                (value) {
                  if (value.isNotEmpty) {
                    producto.fechaIngreso = DateTime.tryParse(value)!;
                  }
                },
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              _buildTextField(
                'Fecha de Expiración',
                (value) {
                  if (value.isNotEmpty) {
                    producto.fechaExpiracion = DateTime.tryParse(value);
                  }
                },
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              _buildDropdown(
                'Categoría',
                producto.categoria,
                categorias,
                (value) => setState(() => producto.categoria = value!),
              ),
              const SizedBox(height: 8),
              Text(
                'Categoría seleccionada: ${producto.categoria.nombre}',
                style: const TextStyle(color: Colors.grey),
              ),
              SwitchListTile(
                title: const Text('Activo'),
                value: producto.estado == 1,
                onChanged: (value) =>
                    setState(() => producto.estado = value ? 1 : 0),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarProducto,
                child: const Text('Crear Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    Function(String) onChanged, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    Categoria currentValue,
    List<Categoria> options,
    Function(Categoria?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<Categoria>(
        decoration: InputDecoration(labelText: label),
        value: currentValue,
        items: options.map((Categoria value) {
          return DropdownMenuItem<Categoria>(
            value: value,
            child: Text(value.nombre),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _guardarProducto() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ProductoService().guardarProducto(producto);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto creado con éxito')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear producto: $e')),
        );
      }
    }
  }
}
