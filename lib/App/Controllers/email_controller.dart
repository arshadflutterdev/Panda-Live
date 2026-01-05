// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';

// class DynamicTextController extends GetxController {
//   /// Map to hold all TextEditingControllers by field name
//   final Map<String, TextEditingController> textControllers = {};

//   /// Map to hold reactive "isNotEmpty" status by field name
//   final Map<String, RxBool> isNotEmptyMap = {};

//   /// Initialize a field dynamically
//   void initField(String fieldName) {
//     textControllers[fieldName] = TextEditingController();
//     isNotEmptyMap[fieldName] = false.obs;

//     /// Listen to changes in text to update reactive bool automatically
//     textControllers[fieldName]!.addListener(() {
//       isNotEmptyMap[fieldName]!.value =
//           textControllers[fieldName]!.text.isNotEmpty;
//     });
//   }

//   /// onChanged for a field
//   void onChanged(String fieldName, String value) {
//     isNotEmptyMap[fieldName]!.value = value.isNotEmpty;
//   }

//   /// Clear a field
//   void clearField(String fieldName) {
//     textControllers[fieldName]!.clear();
//     isNotEmptyMap[fieldName]!.value = false;
//   }

//   /// Dispose all controllers
//   @override
//   void onClose() {
//     for (var controller in textControllers.values) {
//       controller.dispose();
//     }
//     super.onClose();
//   }
// }
