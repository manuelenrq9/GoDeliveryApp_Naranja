import 'package:godeliveryapp_naranja/features/discount/domain/discount.dart';

num getDiscountedPrice(num price, Discount? discount) {
  // Si el descuento es nulo o el porcentaje es 0, devuelve el precio original
  if (discount == null || discount.percentage <= 0) {
    return price;
  }

  // Verificar si el descuento es válido (dentro de las fechas de validez)
  final currentDate = DateTime.now();

  if (currentDate.isAfter(discount.initDate) &&
      currentDate.isBefore(discount.expireDate)) {
    // Descuento válido, aplicar el descuento

    double discountPercentage = discount.percentage;
    double discountedPrice = price / (1 + discountPercentage);
    return discountedPrice;
  } else {
    return price;
  }
}
