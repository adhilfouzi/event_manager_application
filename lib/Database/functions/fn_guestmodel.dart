// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/foundation.dart';
import 'package:project_event/Database/model/Guest_Model/guest_model.dart';
import 'package:sqflite/sqflite.dart';

ValueNotifier<List<GuestModel>> guestlist = ValueNotifier<List<GuestModel>>([]);
late Database guestDB;

// Function to initialize the database.
Future<void> initialize_guest_database() async {
  guestDB = await openDatabase(
    'guestDB',
    version: 1,
    onCreate: (Database db, version) async {
      // Create the 'student' table when the database is created.
      await db.execute(
          'CREATE TABLE guest (id INTEGER PRIMARY KEY, gname TEXT, sex TEXT, status INTEGER, note TEXT, number TEXT, eventid INTEGER, email TEXT, address TEXT)');
    },
  );
  print("guestDB created successfully.");
}

// Function to retrieve task data from the database.
Future<void> refreshguestdata(int id) async {
  final result = await guestDB.rawQuery(
      "SELECT * FROM guest WHERE eventid = ? ORDER BY status DESC",
      [id.toString()]);
  print('All guest data: $result');
  guestlist.value.clear();
  for (var map in result) {
    final student = GuestModel.fromMap(map);
    guestlist.value.add(student);
  }

  // Sort the taskList to place rows with status=false at the beginning
  guestlist.value.sort((a, b) {
    if (a.status == 0 && b.status == 1) {
      return -1; // a comes before b
    } else if (a.status == 1 && b.status == 0) {
      return 1; // b comes before a
    } else {
      return 0; // no change in order
    }
  });

  guestlist.notifyListeners();
}

// Function to add a new student to the database.
Future<void> addguest(GuestModel value) async {
  try {
    await guestDB.rawInsert(
      'INSERT INTO guest(eventid,gname,sex,note,status,number,email,address) VALUES(?,?,?,?,?,?,?,?)',
      [
        value.eventid,
        value.gname,
        value.sex,
        value.note,
        value.status,
        value.number,
        value.email,
        value.address
      ],
    );
    refreshguestdata(value.eventid);
  } catch (e) {
    //------> Handle any errors that occur during data insertion.
    print('Error inserting data: $e');
  }
}

// Function to delete a student from the database by their ID.
Future<void> deleteGuest(id, int eventid) async {
  await guestDB.delete('guest', where: 'id=?', whereArgs: [id]);
  refreshguestdata(eventid);
}

// Function to edit/update a student's information in the database.
Future<void> editGuest(
    id, eventid, gname, sex, note, status, number, email, address) async {
  final dataflow = {
    'eventid': eventid,
    'gname': gname,
    'sex': sex,
    'note': note,
    'status': status,
    'number': number,
    'email': email,
    'address': address,
  };
  await guestDB.update('guest', dataflow, where: 'id=?', whereArgs: [id]);
  refreshguestdata(eventid);
}

// Function to delete data from event's database.
Future<void> clearGuestDatabase() async {
  try {
    await guestDB.delete('guest');
    // refreshguestdata();
  } catch (e) {
    print('Error while clearing the database: $e');
  }
}