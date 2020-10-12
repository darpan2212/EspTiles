import 'package:esp_tiles/bloc/product/prod_bloc.dart';
import 'package:esp_tiles/bloc/product/product_event.dart';
import 'package:esp_tiles/bloc/product/product_repo.dart';
import 'package:esp_tiles/bloc/product/product_state.dart';
import 'package:esp_tiles/model/request/product_req.dart';
import 'package:esp_tiles/model/response/category_resp.dart';
import 'package:esp_tiles/model/response/product_resp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListDetailsScreen extends StatefulWidget {
  final SubCategories subCategories;

  ProductListDetailsScreen(this.subCategories);

  @override
  _ProductListDetailsScreenState createState() =>
      _ProductListDetailsScreenState();
}

class _ProductListDetailsScreenState extends State<ProductListDetailsScreen> {
  ProductRepo productRepo;
  int currentPageIndex;
  ProductBloc productBloc;

  ScrollController _listController = ScrollController();

  bool isProductLoading;

  @override
  void dispose() {
    productRepo.dispose();
    productBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    // _listController.addListener(_onListScroll);
    isProductLoading = true;
    currentPageIndex = 1;
    productRepo = ProductRepository(
      ProductReq(
        subCategoryId: widget.subCategories.id,
        pageIndex: currentPageIndex,
      ),
    )..getProducts();
    productBloc = ProductBloc();
    productRepo.products().listen((productResp) {
      productBloc.add(ProductFetch(productResp));
      isProductLoading = true;
    });
    super.initState();
  }

  void _onListScroll() {
    final maxScroll = _listController.position.maxScrollExtent;
    final currentScroll = _listController.position.pixels;
    if (maxScroll - currentScroll <= 200 &&
        isProductLoading &&
        currentPageIndex > 0) {
      isProductLoading = false;
      productRepo.productReq = ProductReq(
        subCategoryId: widget.subCategories.id,
        pageIndex: ++currentPageIndex,
      );
      print('Current page index Product $currentPageIndex');
      productRepo.getProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ProductRepo>(
      create: (_) => productRepo,
      child: BlocProvider<ProductBloc>(
        create: (_) => productBloc,
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (_, state) {
            if (state is ProductListFailure) {
              return Container(
                child: Center(
                  child: Text('${state.failureMsg}'),
                ),
              );
            }
            if (state is ProductListSuccess) {
              currentPageIndex = state.hasMaxData ? -1 : currentPageIndex;
              ProductResp resp = state.productResp;
              return Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: resp.result != null && resp.result.isNotEmpty
                      ? resp.result.length
                      : 0,
                  itemBuilder: (_, index) {
                    return buildProductTiles(resp.result[index]);
                  },
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

  Widget buildProductTiles(ProductP result) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: NetworkImage(
                    result.imageName,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              result.name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 24,
        ),
      ],
    );
  }
}
