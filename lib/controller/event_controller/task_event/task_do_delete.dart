import 'package:get/get.dart';
import 'package:project_event/model/data_model/event/event_model.dart';
import 'package:project_event/model/data_model/task/task_model.dart';
import 'package:project_event/model/db_functions/fn_taskmodel.dart';
import 'package:project_event/view/body_screen/task_event/task_screen.dart';

void delectYes(TaskModel student, int step, Eventmodel eventModel) {
  try {
    deletetask(student.id, student.eventid);

    if (step == 2) {
      Get.offAll(
          transition: Transition.rightToLeftWithFade,
          //     allowSnapshotting: false,
          fullscreenDialog: true,
          TaskList(
            eventid: student.eventid,
            eventModel: eventModel,
          ));
    } else if (step == 1) {
      Get.back();

      refreshEventtaskdata(student.eventid);
    }
  } catch (e) {
    // print('Error inserting data: $e');
  }
}
