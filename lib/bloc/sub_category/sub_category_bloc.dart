import 'package:esp_tiles/bloc/category/category_event.dart';
import 'package:esp_tiles/bloc/category/category_state.dart';
import 'package:esp_tiles/model/response/category_resp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubCategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  List<SubCategories> previousSubCategory;

  SubCategoryBloc() : super(CategoryListInit());

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is CategoryFetch) {
      try {
        if (event.categoryList == null || event.categoryList.isEmpty) {
          yield CategoryListFailure('There are no data to show');
          return;
        } else {
          if (state is CategoryListSuccess &&
              event.categoryList[0].subCategories == null) {
            event.categoryList[0].subCategories = previousSubCategory;
            yield CategoryListSuccess(event.categoryList, hasMaxData: true);
            return;
          }
          if (previousSubCategory != null && previousSubCategory.isNotEmpty) {
            event.categoryList[0].subCategories =
                previousSubCategory + event.categoryList[0].subCategories;
          }
          previousSubCategory = event.categoryList[0].subCategories;
          yield CategoryListSuccess(event.categoryList);
          return;
        }
      } catch (e) {
        yield CategoryListFailure(e.toString());
        return;
      }
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
