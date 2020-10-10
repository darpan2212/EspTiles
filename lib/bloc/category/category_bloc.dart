import 'package:esp_tiles/bloc/category/category_event.dart';
import 'package:esp_tiles/bloc/category/category_repo.dart';
import 'package:esp_tiles/bloc/category/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryRepo _categoryRepo;

  CategoryBloc(this._categoryRepo) : super(CategoryListInit()) {
    _categoryRepo.categories().listen((categoryResp) {
      add(CategoryFetch(categoryResp.result.category));
    });
  }

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is CategoryFetch) {
      try {
        if (event.categoryList == null || event.categoryList.isEmpty) {
          yield CategoryListFailure('');
          return;
        } else {
          yield CategoryListSuccess(event.categoryList);
          return;
        }
      } catch (e) {
        yield CategoryListFailure(e.toString());
        return;
      }
    }
  }
}
