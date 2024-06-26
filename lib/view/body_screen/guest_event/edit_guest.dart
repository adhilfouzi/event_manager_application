import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:get/get.dart';
import 'package:project_event/controller/event_controller/guest_event/guest_delete_confirmatiion.dart';
import 'package:project_event/model/core/color/color.dart';

import 'package:project_event/model/db_functions/fn_guestmodel.dart';
import 'package:project_event/model/data_model/event/event_model.dart';
import 'package:project_event/model/data_model/guest_model/guest_model.dart';
import 'package:project_event/controller/widget/box/textfield_blue.dart';
import 'package:project_event/controller/widget/list/sexdropdown.dart';
import 'package:project_event/controller/widget/scaffold/app_bar.dart';
import 'package:project_event/controller/widget/sub/contact_form_widget.dart';

import 'package:project_event/controller/widget/sub/status_button_widget.dart';
import 'package:project_event/model/getx/snackbar/getx_snackbar.dart';

import 'package:sizer/sizer.dart';

class EditGuest extends StatefulWidget {
  final Eventmodel eventModel;
  final int step;
  final GuestModel guestdata;

  const EditGuest(
      {super.key,
      required this.guestdata,
      required this.eventModel,
      required this.step});

  @override
  State<EditGuest> createState() => _EditGuestState();
}

class _EditGuestState extends State<EditGuest> {
  final _formKey = GlobalKey<FormState>();
  PhoneContact? _phoneContact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            AppAction(
                icon: Icons.contacts,
                onPressed: () {
                  getcontact();
                }),
            AppAction(
                icon: Icons.delete,
                onPressed: () {
                  doDeleteGuest(
                      widget.guestdata, widget.step, widget.eventModel);
                }),
          ],
          titleText: 'Edit Guest',
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(1.2.h),
          child: Form(
            key: _formKey,
            child: Column(children: [
              TextFieldBlue(
                textcontent: 'Name',
                controller: _nameController,
                keyType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return ' name is required';
                  }
                  return null; // Return null if the input is valid
                },
              ),
              SexDown(
                  onChanged: (String? status) {
                    _sexController.text = status ?? 'Male';
                  },
                  defaultdata: _sexController.text),
              TextFieldBlue(textcontent: 'Note', controller: _noteController),
              StatusBar(
                defaultdata: _statusController == 1 ? true : false,
                onStatusChange: (bool status) {
                  _statusController = status == true ? 1 : 0;
                },
                textcontent1: 'Not sent',
                textcontent2: 'Invitation sent',
              ),
              ContactState(
                  acontroller: _acontroller,
                  econtroller: _econtroller,
                  pcontroller: _pcontroller),
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
                          editGuestclick(context, widget.guestdata);
                        },
                        child: Text(
                          'Update Guest',
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

  late int _statusController;
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _econtroller = TextEditingController();
  final TextEditingController _acontroller = TextEditingController();
  final TextEditingController _pcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _statusController = widget.guestdata.status;
    _sexController.text = widget.guestdata.sex;
    _nameController.text = widget.guestdata.gname;
    _noteController.text = widget.guestdata.note!;
    _econtroller.text = widget.guestdata.email!;
    _acontroller.text = widget.guestdata.address!;
    _pcontroller.text = widget.guestdata.number!;
  }

  Future<void> editGuestclick(BuildContext context, GuestModel guest) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final name = _nameController.text.toUpperCase();
      final sex = _sexController.text;
      final note = _noteController.text;
      final email = _econtroller.text;
      final eventId = guest.eventid;
      final number = _pcontroller.text;
      final adress = _acontroller.text;
      Get.back();

      await editGuest(guest.id, eventId, name, sex, note, _statusController,
          number, email, adress);

      refreshguestdata(guest.eventid);
      SnackbarModel.successSnack(message: "Successfully edited");
    } else {
      SnackbarModel.errorSnack();
    }
  }

  Future<void> getcontact() async {
    try {
      bool permission = await FlutterContactPicker.requestPermission();
      if (permission) {
        if (await FlutterContactPicker.hasPermission()) {
          _phoneContact = await FlutterContactPicker.pickPhoneContact();
          if (_phoneContact != null) {
            if (_phoneContact!.fullName!.isNotEmpty) {
              setState(() {
                _nameController.text = _phoneContact!.fullName.toString();
              });
            }
            if (_phoneContact!.phoneNumber!.number!.isNotEmpty) {
              setState(() {
                _pcontroller.text =
                    _phoneContact!.phoneNumber!.number.toString();
              });
            }
          }
        }
      }
    } catch (e) {
      if (e is UserCancelledPickingException) {
        // print('User cancelled picking contact');
        // Handle the cancellation (e.g., show a message to the user)
      } else {
        // Handle other exceptions
        // print('Error picking contact: $e');
      }
    }
  }
}
