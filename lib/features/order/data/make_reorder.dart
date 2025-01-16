import 'package:godeliveryapp_naranja/core/dataID.services.dart';
import 'package:godeliveryapp_naranja/features/combo/data/combo_fetchID.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/widgets/add_to_cart.dart';
class MakeReorder{
  Order order;

  MakeReorder(this.order);
  AddToCartLogic logic = AddToCartLogic();

  
  Future<void> execute() async{
    logic.clearCart();
    String id;
    Product productObject;
    Combo comboObject;
    for (var product in order.products){
      id = product.id;
      productObject = await fetchEntityById<Product>(id, 'product/one/',
      (json) => Product.fromJson(json)); // Await the asynchronous call
      logic.addToCartWithNoSnackBar(product: productObject, quantity: product.quantity, 
      price: productObject.price);
    };
    for (var combo in order.combos){
      id = combo.id;
      comboObject = await fetchComboById(id);
      logic.addToCartWithNoSnackBar(combo:comboObject, quantity:combo.quantity, 
      price: comboObject.specialPrice);
    };
  }
}

  

