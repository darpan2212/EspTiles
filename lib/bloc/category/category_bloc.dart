import 'package:esp_tiles/bloc/category/category_event.dart';
import 'package:esp_tiles/bloc/category/category_repo.dart';
import 'package:esp_tiles/bloc/category/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryRepo _categoryRepo;

  CategoryBloc(this._categoryRepo) : super(CategoryListInit()) {
    _categoryRepo.categories().listen((categoryResp) {
      add(CategoryFetch(categoryResp));
    });
  }

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is CategoryFetch) {
      try {
        if (event.categoryResp.status == 0) {
          yield CategoryListFailure('${event.categoryResp.message}');
          return;
        } else {
          print(event.categoryResp.result.category);
          yield CategoryListSuccess(event.categoryResp);
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
    _categoryRepo.dispose();
    return super.close();
  }
}
