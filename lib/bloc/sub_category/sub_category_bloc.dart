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
        if (event.categoryResp.status == 0) {
          yield CategoryListFailure('${event.categoryResp.message}');
          return;
        } else {
          if (state is CategoryListSuccess &&
              event.categoryResp.result.category[0].subCategories == null) {
            event.categoryResp.result.category[0].subCategories =
                previousSubCategory;
            yield CategoryListSuccess(event.categoryResp, hasMaxData: true);
            return;
          }
          if (previousSubCategory != null && previousSubCategory.isNotEmpty) {
            event.categoryResp.result.category[0].subCategories =
                previousSubCategory +
                    event.categoryResp.result.category[0].subCategories;
          }
          previousSubCategory =
              event.categoryResp.result.category[0].subCategories;
          yield CategoryListSuccess(event.categoryResp);
          return;
        }
      } catch (e) {
        yield CategoryListFailure(e.toString());
        return;
      }
    }
  }
}
