import 'package:esp_tiles/model/response/category_resp.dart';

abstract class CategoryEvent {}

class CategoryFetch extends CategoryEvent {
  final List<Category> categoryList;

  CategoryFetch(this.categoryList);
}
