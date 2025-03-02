// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:students_getx/cotroller/students_controller.dart';
import 'package:students_getx/database/functions.dart';
import 'package:students_getx/database/models.dart';
import 'package:students_getx/views/register.dart';
import 'package:students_getx/widgets/home_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(DbFuctions());
  final statemange = Get.put(StudentContoller());
  final gets = DbFuctions();
  String searchText = '';
  Timer? debouncer;
  @override
  void initState() {
    super.initState();
    gets.studentList;
    gets.getStudent();

    searchControler.removeListener(() {
      searchText;
    });
  }

  final searchControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 12),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            onPressed: () {
              Get.to(RegisterScreen(isEdit: false));
            },
            icon: Icon(
              Icons.add,
              size: 30,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            label: Text('Add Student',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(250),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            child: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 250,
              centerTitle: true,
              title: Column(
                children: [
                  Image.network(
                    'https://brototype.com/careers/images/logo/logo-black.png',
                    filterQuality: FilterQuality.high,
                    height: 80,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'Student Details',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
              bottom: PreferredSize(
                  preferredSize: Size.fromRadius(40),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: ValueListenableBuilder(
                        valueListenable: scroll,
                        builder: (context, isvisible, _) {
                          return isvisible
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Container(
                                    height: 40,
                                    child: TextFormField(
                                      onChanged: (values) {
                                        statemange.search(values);
                                        onSearchChange(values);
                                      },
                                      controller: searchControler,
                                      decoration: InputDecoration(
                                          suffixIcon:
                                              statemange.searchtext.isEmpty
                                                  ? Icon(
                                                      Icons.mic,
                                                      color: Colors.black,
                                                    )
                                                  : IconButton(
                                                      onPressed: () {
                                                        searchControler.clear();
                                                        // .getsearchText('');
                                                        gets.getStudent();
                                                      },
                                                      icon: Icon(
                                                        Icons.clear,
                                                        color: Colors.black,
                                                      )),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: const Color.fromARGB(
                                                    255,
                                                    0,
                                                    0,
                                                    0)), // Set underline color to white when focused
                                          ),
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          label: Text(
                                            'search',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: Colors.black,
                                          )),
                                    ),
                                  ),
                                )
                              : SizedBox();
                        }),
                  )),
            ),
          ),
        ),
        body: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              final ScrollDirection direction = notification.direction;
              if (direction == ScrollDirection.reverse) {
                scroll.value = false;
              } else if (direction == ScrollDirection.forward) {
                scroll.value = true;
              }
              return true;
            },
            child: CustomList()));
  }

  onSearchChange(
    String values,
  ) {
    final studentdb = Hive.box<Studentupdate>('student');
    final students = studentdb.values.toList();
    values = searchControler.text;

    if (debouncer?.isActive ?? false) debouncer?.cancel();
    debouncer = Timer(Duration(milliseconds: 200), () {
      if (searchText != searchControler) {
        final filterdStudent = students
            .where((students) => students.name!
                .toLowerCase()
                .trim()
                .contains(values.toLowerCase().trim()))
            .toList();
        controller.studentList.value = filterdStudent;
      }
    });
  }
}
