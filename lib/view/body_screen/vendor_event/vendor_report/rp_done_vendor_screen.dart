import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_event/model/core/color/color.dart';
import 'package:project_event/model/core/font/font.dart';
import 'package:project_event/model/db_functions/fn_vendormodel.dart';
import 'package:project_event/model/data_model/event/event_model.dart';
import 'package:project_event/view/body_screen/vendor_event/edit_vendor_screen.dart';
import 'package:project_event/view/body_screen/vendor_event/detailes_view_vendor_screen.dart';
import 'package:project_event/controller/widget/list/list.dart';
import 'package:project_event/controller/widget/scaffold/app_bar.dart';

import 'package:sizer/sizer.dart';

class DoneRpVendorList extends StatelessWidget {
  final Eventmodel eventModel;

  const DoneRpVendorList({super.key, required this.eventModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(actions: [], titleText: 'Vendors'),
      body: Padding(
        padding: EdgeInsets.all(1.h),
        child: ValueListenableBuilder(
          valueListenable: vendorDonelist,
          builder: (context, value, child) {
            if (value.isNotEmpty) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = value[index];
                  final categoryItem = category.firstWhere(
                    (item) => item['text'] == data.category,
                    orElse: () => {
                      'image':
                          const AssetImage('assets/UI/icons/Accommodation.png'),
                    },
                  );
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: buttoncolor, width: 1),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListTile(
                        onTap: () => Get.to(
                            transition: Transition.rightToLeftWithFade,
                            ViewVendor(
                              vendor: data,
                              eventModel: eventModel,
                            )),
                        onLongPress: () => Get.to(
                            transition: Transition.rightToLeftWithFade,
                            EditVendor(
                              eventModel: eventModel,
                              vendordataway: data,
                              val: 0,
                            )),
                        leading: Image(image: categoryItem['image']),
                        title: Text(
                          data.name,
                          style: raleway(color: Colors.black),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data.status == 0 ? 'Pending' : 'Completed',
                                  style: raleway(
                                    color: data.status == 0
                                        ? Colors.red
                                        : Colors.green,
                                    fontSize: 11.sp,
                                  ),
                                ),
                                Text(
                                  '₹ ${data.esamount}',
                                  style: racingSansOne(
                                    color: Colors.black,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pending: ₹${data.pending}',
                                  style: racingSansOne(
                                    color: Colors.black54,
                                    fontSize: 11.sp,
                                  ),
                                ),
                                Text(
                                  'Paid: ₹${data.paid}',
                                  style: racingSansOne(
                                    color: Colors.black54,
                                    fontSize: 11.sp,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'No Vendors available',
                  style: TextStyle(fontSize: 15.sp),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}