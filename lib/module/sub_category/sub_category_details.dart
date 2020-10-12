import 'package:esp_tiles/bloc/category/category_event.dart';
import 'package:esp_tiles/bloc/category/category_repo.dart';
import 'package:esp_tiles/bloc/category/category_state.dart';
import 'package:esp_tiles/bloc/sub_category/sub_category_bloc.dart';
import 'package:esp_tiles/model/request/category_req.dart';
import 'package:esp_tiles/model/response/category_resp.dart';
import 'package:esp_tiles/module/product_list/product_list_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubCategoryDetailsScreen extends StatefulWidget {
  final Category category;

  SubCategoryDetailsScreen(this.category);

  @override
  _SubCategoryDetailsScreenState createState() =>
      _SubCategoryDetailsScreenState();
}

class _SubCategoryDetailsScreenState extends State<SubCategoryDetailsScreen> {
  CategoryRepo subCategoryRepo;
  int currentPageIndex;
  SubCategoryBloc subCategoryBloc;

  ScrollController _listController = ScrollController();

  bool isSubCategoryLoading;

  @override
  void dispose() {
    subCategoryRepo.dispose();
    subCategoryBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    // _listController.addListener(_onListScroll);
    isSubCategoryLoading = true;
    currentPageIndex = 1;
    subCategoryRepo = CategoryRepository(
      CategoryReq(
        categoryId: widget.category.id,
        pageIndex: currentPageIndex,
      ),
    )..getCategories();
    subCategoryBloc = SubCategoryBloc();
    subCategoryRepo.categories().listen((categoryResp) {
      subCategoryBloc.add(CategoryFetch(categoryResp));
      isSubCategoryLoading = true;
    });
    super.initState();
  }

  void _onListScroll() {
    final maxScroll = _listController.position.maxScrollExtent;
    final currentScroll = _listController.position.pixels;
    if (maxScroll - currentScroll <= 200 &&
        isSubCategoryLoading &&
        currentPageIndex > 0) {
      isSubCategoryLoading = false;
      subCategoryRepo.categoryReq = CategoryReq(
        categoryId: widget.category.id,
        pageIndex: ++currentPageIndex,
      );
      print('Current page index $currentPageIndex');
      subCategoryRepo.getCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CategoryRepo>(
      create: (_) => subCategoryRepo,
      child: BlocProvider<SubCategoryBloc>(
        create: (_) => subCategoryBloc,
        child: BlocBuilder<SubCategoryBloc, CategoryState>(
          builder: (_, state) {
            if (state is CategoryListFailure) {
              return Container(
                child: Center(
                  child: Text('${state.failureMsg}'),
                ),
              );
            }
            if (state is CategoryListSuccess) {
              List<SubCategories> subCategories =
                  state.categoryResp.result.category[0].subCategories;
              currentPageIndex = state.hasMaxData ? -1 : currentPageIndex;
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    _onListScroll();
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  controller: _listController,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            subCategories != null && subCategories.isNotEmpty
                                ? subCategories.length
                                : 0,
                        itemBuilder: (_, index) {
                          return buildSubCategoryTiles(subCategories[index]);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      state.hasMaxData
                          ? Container()
                          : Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black,
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildSubCategoryTiles(SubCategories subCat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subCat.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        ProductListDetailsScreen(subCat),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
