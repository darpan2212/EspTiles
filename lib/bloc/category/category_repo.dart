import 'dart:async';
import 'dart:convert';

import 'package:esp_tiles/common/app_constant.dart';
import 'package:esp_tiles/model/request/category_req.dart';
import 'package:esp_tiles/model/response/category_resp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class CategoryRepo {
  var client = http.Client();

  Stream<CategoryResp> categories();

  void dispose();

  void getCategories();
}

class CategoryRepository extends CategoryRepo {
  final categoryStream = StreamController<CategoryResp>();

  String allCategoryListUrl;
  CategoryReq categoryReq;

  CategoryRepository(BuildContext context) {
    allCategoryListUrl = '${AppConstants.of(context).baseUrl}Product/DashBoard';
    categoryReq = CategoryReq(
      categoryId: 0,
      deviceManufacturer: '${AppConstants.of(context).deviceManufacturer}',
      deviceModel: '${AppConstants.of(context).deviceModel}',
      deviceToken: '',
      pageIndex: 1,
    );
  }

  @override
  Stream<CategoryResp> categories() => categoryStream.stream;

  @override
  void dispose() {
    categoryStream.close();
  }

  @override
  void getCategories() async {
    String categoryReqJson = json.encode(categoryReq);
    http.Response res =
        await client?.post(allCategoryListUrl, body: categoryReqJson);
    if (res.statusCode == 200) {
      CategoryResp categoryResult =
          CategoryResp.fromJson(json.decode(res.body));
      categoryStream.add(categoryResult);
    } else {
      throw Exception(
          'The Server refused connection, Please try after some time.');
    }
  }
}
