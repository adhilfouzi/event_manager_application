import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:project_event/controller/event_controller/task_event/task_delete_conformation.dart';
import 'package:project_event/model/core/color/color.dart';
import 'package:project_event/model/db_functions/fn_taskmodel.dart';
import 'package:project_event/model/data_model/event/event_model.dart';
import 'package:project_event/model/data_model/task/task_model.dart';

import 'package:project_event/controller/widget/box/textfield_blue.dart';
import 'package:project_event/controller/services/categorydropdown_widget.dart';
import 'package:project_event/controller/widget/scaffold/app_bar.dart';
import 'package:project_event/controller/widget/sub/date_widget.dart';
import 'package:project_event/controller/widget/sub/status_button_widget.dart';
import 'package:project_event/model/getx/snackbar/getx_snackbar.dart';

import 'package:sizer/sizer.dart';

class EditTask extends StatefulWidget {
  final Eventmodel eventModel;
  final int step;
  final TaskModel taskdata;

  const EditTask(
      {super.key,
      required this.taskdata,
      required this.eventModel,
      required this.step});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(actions: [
          AppAction(
              icon: Icons.delete,
              onPressed: () {
                doDeleteTask(widget.taskdata, widget.step, widget.eventModel);
              }),
        ], titleText: 'Edit Task'),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(1.5.h),
          child: Form(
            key: _formKey,
            child: Column(children: [
              TextFieldBlue(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Task name is required';
                    }
                    return null; // Return null if the input is valid
                  },
                  keyType: TextInputType.name,
                  textcontent: 'Task Name',
                  controller: _tasknameController),
              CategoryDown(
                defaultdata: _categoryController.text,
                onCategorySelected: (String value) {
                  _categoryController.text = value;
                },
              ),
              TextFieldBlue(textcontent: 'Note', controller: _noteController),
              StatusBar(
                defaultdata: _statusController == 1 ? true : false,
                textcontent1: 'Pending',
                textcontent2: 'Completed',
                onStatusChange: (bool status) {
                  _statusController = status == true ? 1 : 0;
                },
              ),
              Date(
                defaultdata: _dateController.text,
                controller: _dateController,
              ),
              SizedBox(
                height: 3.h,
              ),
              Padding(
                padding: EdgeInsets.all(2.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            EdgeInsets.symmetric(
                                vertical: 1.5.h, horizontal: 4.h),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                          ),
                          backgroundColor: WidgetStateProperty.all(buttoncolor),
                        ),
                        onPressed: () {
                          edittaskclicked(context, widget.taskdata);
                        },
                        child: Text(
                          'Update Task',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  final _tasknameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _noteController = TextEditingController();
  late int _statusController;
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tasknameController.text = widget.taskdata.taskname;
    _categoryController.text = widget.taskdata.category;
    _noteController.text = widget.taskdata.note!;
    _statusController = widget.taskdata.status;
    _dateController.text = widget.taskdata.date;
  }

  Future<void> edittaskclicked(BuildContext context, TaskModel task) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final taskname = _tasknameController.text.toUpperCase();
      final category = _categoryController.text;
      final note = _noteController.text;
      final date = _dateController.text;
      final eventId = task.eventid;

      await editTask(
          task.id, taskname, category, note, _statusController, date, eventId);
      Get.back();
      refreshEventtaskdata(eventId);
      SnackbarModel.successSnack(message: "Successfully edited");
    } else {
      SnackbarModel.errorSnack();
    }
  }
}
