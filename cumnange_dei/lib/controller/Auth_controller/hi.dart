// Future<void> updateData() async {
//     // ត្រួតពិនិត្យមើលថា តើមាន ID ឬនៅ?
//     if (id ==null ) {
//       Get.snackbar("Error", "រកមិនឃើញ ID សម្រាប់ Update ទេ");
//       return;
//     }

//     if (!_isValid()) return;

//     try {
//       isLoading.value = true;

//       final updateData = PostDataModel(
//         name:    controllername.text.trim(),
//         price:   double.tryParse(controllerprice.text.trim()) ?? 0.0, 
//         village: controllervillage.text.trim(),
//       );

//       final response = await ApiService.put(
//         endpoint: "api/detail_userdata/$id/",
//         data: updateData.toJson(),
//       );

//       _handleResponse(response);

//     } catch (e) {
//       print('error');
//     } finally {
//       isLoading.value = false;
//     }
//   }
