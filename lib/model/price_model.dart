import 'dart:convert';

class CollabPrice {
  final double originalPrice;
  final int? discountPercent;
  final String currency;
  final String currenySign;

  CollabPrice({
    required this.originalPrice,
    this.discountPercent,
    this.currency = 'dollar',
    this.currenySign = '\$',
  });

  CollabPrice copyWith({
    double? originalPrice,
    int? discountPercent,
    String? currency,
    String? currenySign,
  }) {
    return CollabPrice(
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      currency: currency ?? this.currency,
      currenySign: currenySign ?? this.currenySign,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'originalPrice': originalPrice,
      'discountPercent': discountPercent,
      'currency': currency,
      'currenySign': currenySign,
    };
  }

  factory CollabPrice.fromMap(Map<String, dynamic> map) {
    return CollabPrice(
      originalPrice: map['originalPrice'].toDouble(),
      discountPercent: map['discountPercent']?.toInt(),
      currency: map['currency'] ?? '',
      currenySign: map['currenySign'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CollabPrice.fromJson(String source) => CollabPrice.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CollabPrice(originalPrice: $originalPrice, discountPercent: $discountPercent, currency: $currency, currenySign: $currenySign)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CollabPrice &&
        other.originalPrice == originalPrice &&
        other.discountPercent == discountPercent &&
        other.currency == currency &&
        other.currenySign == currenySign;
  }

  @override
  int get hashCode {
    return originalPrice.hashCode ^ discountPercent.hashCode ^ currency.hashCode ^ currenySign.hashCode;
  }
}
