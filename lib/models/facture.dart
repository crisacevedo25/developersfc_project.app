enum FactureType { Compra, Venta }

class Facture {
  String id;
  String description;
  FactureType category;
  double total;
  int cant;

  Facture({
    required this.id,
    required this.description,
    required this.category,
    required this.total,
    required this.cant,
  });

  factory Facture.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>? ?? {};

    return Facture(
      id: json['name']?.split('/')?.last ?? 'unknown',
      description: fields['description']?['stringValue'] as String? ?? '',
      category: FactureType.values[
          int.tryParse(fields['category']?['integerValue'] as String? ?? '0') ??
              0],
      total: double.tryParse(
              fields['total']?['doubleValue']?.toString() ?? '0.0') ??
          0.0,
      cant:
          int.tryParse(fields['cant']?['integerValue'] as String? ?? '0') ?? 0,
    );
  }
}
