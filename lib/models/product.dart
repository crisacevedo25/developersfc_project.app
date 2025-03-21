enum ProductType { GALLETAS, DULCES, CHURROS }

class Product {
  String id;
  String image;
  String nombre;
  ProductType category;
  int preciocomp;
  int preciovent;
  int cant;

  Product({
    required this.id,
    required this.image,
    required this.nombre,
    required this.category,
    required this.preciocomp,
    required this.preciovent,
    required this.cant,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>? ?? {};

    return Product(
      id: json['name']?.split('/')?.last ?? 'unknown',
      image: fields['image']?['stringValue'] as String? ?? '',
      nombre: fields['nombre']?['stringValue'] as String? ?? '',
      category: ProductType.values[
          int.tryParse(fields['category']?['integerValue'] as String? ?? '0') ??
              0],
      preciocomp: int.tryParse(
              fields['preciocomp']?['integerValue'] as String? ?? '0') ??
          0,
      preciovent: int.tryParse(
              fields['preciovent']?['integerValue'] as String? ?? '0') ??
          0,
      cant:
          int.tryParse(fields['cant']?['integerValue'] as String? ?? '0') ?? 0,
    );
  }
}
