// ignore_for_file: deprecated_member_use

import 'dart:typed_data';
import 'package:cumnange_dei/controller/API/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AiController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // ── State ───────────────────────────────────────────────
  var selectedImage = Rxn<XFile>();
  var selectedImageBytes = Rxn<Uint8List>();
  var selectedImageName = ''.obs;
  var isLoading = false.obs;
  var resultText = ''.obs;

  // ── Pick Image ──────────────────────────────────────────
  Future<void> pickImageFromGallery() => _pickImage(ImageSource.gallery);

  Future<void> pickImageFromCamera() => _pickImage(ImageSource.camera);

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(source: source);
      if (file != null) {
        selectedImage.value = file;
        selectedImageBytes.value = await file.readAsBytes();
        selectedImageName.value = file.name;
      }
    } catch (e) {
      _showError("ការជ្រើសរើសរូបភាពបរាជ័យ: $e");
    }
  }

  void clearImage() {
    selectedImage.value = null;
    selectedImageBytes.value = null;
    selectedImageName.value = '';
    resultText.value = '';
  }

  // ── Convert Image To JSON ───────────────────────────────
  Future<void> convertImageToJson() async {
    final file = selectedImage.value;
    if (file == null) {
      _showError("សូមជ្រើសរើសរូបភាពជាមុនសិន");
      return;
    }

    try {
      isLoading.value = true;
      resultText.value = '';

      final response = await ApiService.uploadImage(
        endpoint: 'image/json/',
        filePath: file.path,
        fieldName: 'image',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        resultText.value = response.body.trim();
        if (resultText.value.isEmpty) {
          _showError("មិនអាចបំប្លែងរូបភាពទៅជា JSON បានទេ");
        }
      } else {
        _showError(
          "ការបំប្លែងបរាជ័យ: ${response.statusCode}\n${response.body}",
        );
      }
    } catch (e) {
      _showError("ការបំប្លែងបរាជ័យ: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ── Helpers ─────────────────────────────────────────────
  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
    );
  }
}
