import 'package:esp_tiles/model/response/category_resp.dart';

abstract class CategoryState {}

class CategoryListInit extends CategoryState {}

class CategoryListSuccess extends CategoryState {
  List<Category> categoryList;
  bool hasMaxData;
  CategoryListSuccess(this.categoryList, {this.hasMaxData = false});
}

class CategoryListFailure extends CategoryState {
  String failureMsg;

  CategoryListFailure(this.failureMsg);
}
