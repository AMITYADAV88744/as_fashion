

import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/category_model.dart';
import '../model/product_model.dart';
import 'home_services.dart';

class HomeViewModel extends GetxController {
  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> _loading = ValueNotifier(false);

  List<CategoryModel> get categoryModel => _categoryModel;
  List<CategoryModel> _categoryModel = [];

  List<ProductModel> get productModel => _productModel;
  List<ProductModel> _productModel = [];

  HomeViewModel() {
    getCategory();
  }

  getCategory() async {
    _loading.value = true;
    HomeService().getCategory().then((value) {

      for (int i = 0; i < value.length; i++) {
        _categoryModel.add(CategoryModel.fromJson(value.asMap()));
        _loading.value = false;
      }
      update();
    });
  }

}
