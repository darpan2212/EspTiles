import 'package:esp_tiles/model/response/product_resp.dart';

class ProductEvent {}

class ProductFetch extends ProductEvent {
  ProductResp productResp;

  ProductFetch(this.productResp);
}
