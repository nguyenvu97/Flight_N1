import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingUtils {
  static OverlayEntry? _overlayEntry;

  // Hiển thị overlay loading
  static void show() {
    // Lấy context từ GetX
    final context = Get.overlayContext;
    if (context == null) {
      throw Exception(
          "No overlay context found. Make sure GetMaterialApp is used.");
    }

    // Nếu overlay đã tồn tại thì không thêm mới
    if (_overlayEntry != null) return;

    // Tạo một OverlayEntry mới
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Container(
          color: Colors.black54, // Màu nền của overlay
          child: Center(
            child: LoadingAnimationWidget.discreteCircle(
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    // Thêm OverlayEntry vào Overlay
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  // Ẩn overlay loading
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
