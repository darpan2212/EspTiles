import 'package:esp_tiles/bloc/product/product_event.dart';
import 'package:esp_tiles/bloc/product/product_state.dart';
import 'package:esp_tiles/model/response/product_resp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductResp previousProducts;

  ProductBloc() : super(ProductInit());

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is ProductFetch) {
      try {
        if (event.productResp.status == 0) {
          yield ProductListFailure('${event.productResp.message}');
          return;
        } else {
          if (event.productResp.result == null) {
            event.productResp = previousProducts;
            yield ProductListSuccess(event.productResp, hasMaxData: true);
            return;
          }
          if (previousProducts != null && previousProducts.result.isNotEmpty) {
            event.productResp.result =
                previousProducts.result + event.productResp.result;
          }
          previousProducts = event.productResp;
          yield ProductListSuccess(event.productResp);
          return;
        }
      } catch (e) {
        yield ProductListFailure(e.toString());
        return;
      }
    }
  }
}
