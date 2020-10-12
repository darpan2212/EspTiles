import 'package:esp_tiles/bloc/category/category_bloc.dart';
import 'package:esp_tiles/bloc/category/category_repo.dart';
import 'package:esp_tiles/bloc/category/category_state.dart';
import 'package:esp_tiles/common/app_constant.dart';
import 'package:esp_tiles/model/request/category_req.dart';
import 'package:esp_tiles/model/response/category_resp.dart';
import 'package:esp_tiles/module/sub_category/sub_category_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  CategoryRepo categoryRepo;
  CategoryBloc categoryBloc;

  TabController categoryTabController;

  @override
  void initState() {
    categoryRepo = CategoryRepository(
      CategoryReq(
        categoryId: 0,
        deviceManufacturer: '${AppConstants.deviceManufacturer}',
        deviceModel: '${AppConstants.deviceModel}',
        deviceToken: '',
        pageIndex: 1,
      ),
    )..getCategories();
    categoryBloc = CategoryBloc(categoryRepo);
    super.initState();
  }

  @override
  void dispose() {
    categoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CategoryRepo>(
      create: (_) => categoryRepo,
      child: BlocProvider<CategoryBloc>(
        create: (_) => categoryBloc,
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (_, state) {
            if (state is CategoryListFailure) {
              return Container(
                child: Center(
                  child: Text('${state.failureMsg}'),
                ),
              );
            }
            if (state is CategoryListSuccess) {
              List<Category> categoryList = state.categoryList;
              categoryTabController = TabController(
                length: categoryList.length,
                vsync: this,
              );
              return Scaffold(
                appBar: AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  bottom: TabBar(
                    isScrollable: true,
                    controller: categoryTabController,
                    tabs: categoryList.map((e) => Tab(text: e.name)).toList(),
                  ),
                ),
                body: Container(
                  padding: EdgeInsets.all(8),
                  child: buildTabBarView(categoryList),
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

  Widget buildTabBarView(List<Category> categoryList) {
    return TabBarView(
      controller: categoryTabController,
      children: categoryList
          .map(
            (e) => SubCategoryDetailsScreen(e),
          )
          .toList(),
    );
  }
}
