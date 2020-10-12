import 'package:esp_tiles/model/response/product_resp.dart';

class ProductState {}

class ProductInit extends ProductState {}

class ProductListSuccess extends ProductState {
  ProductResp productResp;
  bool hasMaxData;
  ProductListSuccess(this.productResp, {this.hasMaxData = false});
}

class ProductListFailure extends ProductState {
  String failureMsg;

  ProductListFailure(this.failureMsg);
}
