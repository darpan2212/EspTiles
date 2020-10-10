class CategoryReq {
  int categoryId;
  String deviceManufacturer;
  String deviceModel;
  String deviceToken;
  int pageIndex;

  CategoryReq(
      {this.categoryId,
      this.deviceManufacturer,
      this.deviceModel,
      this.deviceToken,
      this.pageIndex});

  CategoryReq.fromJson(Map<String, dynamic> json) {
    categoryId = json['CategoryId'];
    deviceManufacturer = json['DeviceManufacturer'];
    deviceModel = json['DeviceModel'];
    deviceToken = json['DeviceToken'];
    pageIndex = json['PageIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CategoryId'] = this.categoryId;
    data['DeviceManufacturer'] = this.deviceManufacturer;
    data['DeviceModel'] = this.deviceModel;
    data['DeviceToken'] = this.deviceToken;
    data['PageIndex'] = this.pageIndex;
    return data;
  }
}
