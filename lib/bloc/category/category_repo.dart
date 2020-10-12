import 'dart:async';
import 'dart:convert';

import 'package:esp_tiles/common/app_constant.dart';
import 'package:esp_tiles/model/request/category_req.dart';
import 'package:esp_tiles/model/response/category_resp.dart';
import 'package:http/http.dart' as http;

abstract class CategoryRepo {
  var client = http.Client();

  CategoryReq _categoryReq;

  set categoryReq(CategoryReq req) {
    assert(req != null);
    _categoryReq = req;
  }

  Stream<CategoryResp> categories();

  void dispose();

  void getCategories();
}

class CategoryRepository extends CategoryRepo {
  final categoryStream = StreamController<CategoryResp>.broadcast();

  String allCategoryListUrl;

  CategoryRepository(CategoryReq categoryReq) {
    allCategoryListUrl = '${AppConstants.baseUrl}Product/DashBoard';
    print(allCategoryListUrl);
    this._categoryReq = categoryReq;
  }

  @override
  Stream<CategoryResp> categories() => categoryStream.stream;

  @override
  void dispose() {
    categoryStream.close();
  }

  @override
  void getCategories() async {
    String categoryReqJson = json.encode(_categoryReq);
    http.Response res = await client?.post(
      allCategoryListUrl,
      body: categoryReqJson,
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode >= 200 && res.statusCode <= 299) {
      CategoryResp categoryResult =
          CategoryResp.fromJson(json.decode(res.body));
      categoryStream.add(categoryResult);
    } else {
      throw Exception(
          'The Server refused connection, Please try after some time.');
    }
  }
}
