import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:project_event/controller/widget/scaffold/floatingpointx.dart';
import 'package:project_event/model/core/color/color.dart';
import 'package:project_event/model/core/font/font.dart';
import 'package:project_event/model/db_functions/fn_guestmodel.dart';
import 'package:project_event/model/data_model/event/event_model.dart';

import 'package:project_event/view/body_screen/guest_event/add_guest.dart';
import 'package:project_event/view/body_screen/guest_event/edit_guest.dart';
import 'package:project_event/view/body_screen/event/event_view_screen.dart';
import 'package:project_event/view/body_screen/guest_event/guest_search.dart';
import 'package:project_event/controller/widget/scaffold/app_bar.dart';
import 'package:sizer/sizer.dart';

class Guests extends StatelessWidget {
  final int eventid;
  final Eventmodel eventModel;

  const Guests({super.key, required this.eventid, required this.eventModel});

  @override
  Widget build(BuildContext context) {
    refreshguestdata(eventid);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.offAll(
            transition: Transition.leftToRightWithFade,
            //     allowSnapshotting: false,
            fullscreenDialog: true,
            ViewEvent(eventModel: eventModel));
      },
      child: Scaffold(
        appBar: CustomAppBar(
            leading: () {
              Get.offAll(
                  transition: Transition.leftToRightWithFade,
                  //     allowSnapshotting: false,
                  fullscreenDialog: true,
                  ViewEvent(eventModel: eventModel));
            },
            actions: [
              AppAction(
                  icon: Icons.search,
                  onPressed: () {
                    Get.to(
                        transition: Transition.rightToLeftWithFade,
                        GuestSearch(eventModel: eventModel));
                  }),
              SizedBox(
                width: 2.w,
              )
            ],
            titleText: 'Guests'),
        body: Padding(
          padding: EdgeInsets.all(1.2.h),
          child: ValueListenableBuilder(
            valueListenable: guestlist,
            builder: (context, value, child) {
              if (value.isNotEmpty) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = value[index];
                    return Slidable(
                      key: const ValueKey(1),
                      startActionPane: ActionPane(
                        dragDismissible: false,
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {}),
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              int fine = data.status = 0;
                              editGuest(
                                  data.id,
                                  data.eventid,
                                  data.gname,
                                  data.sex,
                                  data.note,
                                  fine,
                                  data.number,
                                  data.email,
                                  data.address);
                            },
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            icon: Icons.pending_actions,
                            label: 'Pending',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        dragDismissible: false,
                        dismissible: DismissiblePane(onDismissed: () {}),
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              int fine = data.status = 1;
                              editGuest(
                                  data.id,
                                  data.eventid,
                                  data.gname,
                                  data.sex,
                                  data.note,
                                  fine,
                                  data.number,
                                  data.email,
                                  data.address);
                            },
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            icon: Icons.verified,
                            label: 'invited',
                          ),
                        ],
                      ),
                      child: Card(
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
                            onTap: () {
                              Get.to(
                                  transition: Transition.rightToLeftWithFade,
                                  EditGuest(
                                    step: 2,
                                    guestdata: data,
                                    eventModel: eventModel,
                                  ));
                            },
                            leading: Image.asset('assets/UI/icons/person.png'),
                            title: Text(
                              data.gname,
                              style:
                                  raleway(color: Colors.black, fontSize: 15.sp),
                            ),
                            subtitle: Text(
                              data.status == 0
                                  ? 'Pending invitation'
                                  : 'Invitation sent',
                              style: raleway(
                                color: data.status == 0
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text(
                    'No Guest available',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingPointx(
            goto: AddGuest(
          eventModel: eventModel,
          eventID: eventid,
        )),
      ),
    );
  }
}
