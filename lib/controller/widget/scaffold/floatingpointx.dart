import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FloatingPointx extends StatelessWidget {
  final Widget goto;
  const FloatingPointx({super.key, required this.goto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.h),
      child: FloatingActionButton(
        tooltip: 'increment',
        backgroundColor: const Color(0xFF80B3FF),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Get.to(transition: Transition.rightToLeftWithFade, goto);
        },
      ),
    );
  }
}
