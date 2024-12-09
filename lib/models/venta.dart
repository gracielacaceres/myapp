class Venta {
  final int idVenta;
  final int idUsuario;
  final DateTime fechaVenta;
  final double montoTotal;

  Venta({
    required this.idVenta,
    required this.idUsuario,
    required this.fechaVenta,
    required this.montoTotal,
  });

  // Convertir la venta a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_venta': idVenta,
      'id_usuario': idUsuario,
      'fecha_venta': fechaVenta.toIso8601String(),
      'monto_total': montoTotal,
    };
  }

  // Crear una venta desde JSON
  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      idVenta: json['id_venta'],
      idUsuario: json['id_usuario'],
      fechaVenta: DateTime.parse(json['fecha_venta']),
      montoTotal: json['monto_total'],
    );
  }
}

class DetalleVenta {
  final int idDetalleVenta;
  final int idVenta;
  final int idProducto;
  final double cantidad;
  final double precioUnitario;
  final double subtotal;

  DetalleVenta({
    required this.idDetalleVenta,
    required this.idVenta,
    required this.idProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  // Convertir el detalle de la venta a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_detalle_venta': idDetalleVenta,
      'id_venta': idVenta,
      'id_producto': idProducto,
      'cantidad': cantidad,
      'precio_unitario': precioUnitario,
      'subtotal': subtotal,
    };
  }

  // Crear un detalle de venta desde JSON
  factory DetalleVenta.fromJson(Map<String, dynamic> json) {
    return DetalleVenta(
      idDetalleVenta: json['id_detalle_venta'],
      idVenta: json['id_venta'],
      idProducto: json['id_producto'],
      cantidad: json['cantidad'],
      precioUnitario: json['precio_unitario'],
      subtotal: json['subtotal'],
    );
  }
}
