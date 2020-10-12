import 'dart:async';
import 'dart:convert';

import 'package:esp_tiles/common/app_constant.dart';
import 'package:esp_tiles/model/request/product_req.dart';
import 'package:esp_tiles/model/response/product_resp.dart';
import 'package:http/http.dart' as http;

abstract class ProductRepo {
  var client = http.Client();

  ProductReq _productReq;

  set productReq(ProductReq req) {
    assert(req != null);
    _productReq = req;
  }

  Stream<ProductResp> products();

  void dispose();

  void getProducts();
}

class ProductRepository extends ProductRepo {
  final productStream = StreamController<ProductResp>.broadcast();

  String productUrl;

  ProductRepository(ProductReq productReq) {
    productUrl = '${AppConstants.baseUrl}Product/ProductList';
    this._productReq = productReq;
  }

  @override
  Stream<ProductResp> products() => productStream.stream;

  @override
  void dispose() {
    productStream.close();
  }

  @override
  void getProducts() async {
    String productReqJson = json.encode(_productReq);
    http.Response res = await client?.post(
      productUrl,
      body: productReqJson,
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode >= 200 && res.statusCode <= 299) {
      ProductResp productResp = ProductResp.fromJson(json.decode(res.body));
      productStream.add(productResp);
    } else {
      throw Exception(
          'The Server refused connection, Please try after some time.');
    }
  }
}
