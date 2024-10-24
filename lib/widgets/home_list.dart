// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:students_getx/cotroller/students_controller.dart';
import 'package:students_getx/database/crud_operations.dart';
import 'package:students_getx/database/functions.dart';
import 'package:students_getx/views/register.dart';
import 'package:students_getx/widgets/bottomsheet.dart';

ValueNotifier<bool> scroll = ValueNotifier(false);

class CustomList extends StatefulWidget {
  const CustomList({super.key});
  @override
  State<CustomList> createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  @override
  void initState() {
    super.initState();
    getter.getStudent();
    getter.studentList;
    // controller.students;
  }

  final getter = Get.put(DbFuctions());
  final controller = Get.put(StudentContoller());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 1,
        ),
        getter.studentList.isEmpty
            ? Container(
                height: 600,
                //width: 400,
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                    ),
                    Image.network(
                      'https://media.licdn.com/dms/image/C5112AQHh4mCEtiAL1A/article-cover_image-shrink_720_1280/0/1584010252594?e=2147483647&v=beta&t=NtXNsGeTt1B89A-cbrpobUEnsmKSKBJa3oaXrl7fDM0',
                      fit: BoxFit.cover,
                      // width: 200,
                      height: 300,
                    ),
                  ],
                ),
              )
            : Expanded(
                child: Obx(
                  () => ListView.builder(
                      itemCount: getter.studentList.length,
                      itemBuilder: (context, index) {
                        final studentdata =
                            getter.studentList.reversed.toList()[index];
                        return InkWell(
                          onTap: () {
                            bottomSheet(
                                context,
                                studentdata.name,
                                studentdata.domain!,
                                studentdata.place!,
                                studentdata.phone!,
                                studentdata.image!);
                          },
                          child: Slidable(
                            endActionPane:
                                ActionPane(motion: StretchMotion(), children: [
                              SlidableAction(
                                  backgroundColor: Colors.red,
                                  icon: Icons.delete,
                                  label: 'Remove',
                                  onPressed: (context) {
                                    delete(context, studentdata.id);
                                  }),
                              SlidableAction(
                                  label: 'Edit',
                                  icon: Icons.edit,
                                  backgroundColor:
                                      const Color.fromARGB(255, 33, 243, 72),
                                  onPressed: (context) {
                                    Get.to(RegisterScreen(
                                      isEdit: true,
                                      value: studentdata,
                                    ));
                                  })
                            ]),
                            child: Container(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6, top: 12, bottom: 12),
                                    child: CircleAvatar(
                                      radius: 41,
                                      backgroundImage:
                                          FileImage(File(studentdata.image!)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    studentdata.name!.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 26,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
      ],
    );
  }
}
