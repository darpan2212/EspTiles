class ProductReq {
  int subCategoryId;
  int pageIndex;

  ProductReq({this.subCategoryId, this.pageIndex});

  ProductReq.fromJson(Map<String, dynamic> json) {
    subCategoryId = json['SubCategoryId'];
    pageIndex = json['PageIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SubCategoryId'] = this.subCategoryId;
    data['PageIndex'] = this.pageIndex;
    return data;
  }
}
