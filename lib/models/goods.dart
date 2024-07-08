class Goods {
  final String? id;
  final String saleId;
  final String productId;
  final num qty;
  final String? issuer;

  Goods({
    this.id,
    required this.saleId,
    required this.productId,
    required this.qty,
    this.issuer,
  });

  factory Goods.fromJson(Map<String, dynamic> json) {
    return Goods(
      id: json['id'] as String?,
      saleId: json['sale_id'],
      productId: json['product_id'],
      qty: json['qty'],
      issuer: json['issuer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'sale_id': saleId,
      'product_id': productId,
      'qty': qty,
      'issuer': issuer,
    };
    if (id != null) {
      data['id'] = id!;
    }
    return data;
  }
}
