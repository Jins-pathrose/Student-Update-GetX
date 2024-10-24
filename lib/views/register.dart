// ignore_for_file: prefer_const_constructors, sort_child_properties_last, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:students_getx/cotroller/students_controller.dart';
import 'package:students_getx/database/crud_operations.dart';
import 'package:students_getx/database/models.dart';
import 'package:students_getx/database/validator.dart';


class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key, required this.isEdit, this.value});
  bool isEdit = false;
  Studentupdate? value;
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<String> domain = [
    'Mern Stack',
    'Flutter',
    'Python',
    'Data Science',
    'Machine Lerning',
    'Cyber Security',
    'Java',
    'Not Conform'
  ];
  String? selectedDomain;
  File? selectedImage;

  List<String> place = [
    'Bangalure',
    'Kochi',
    'Calicut',
    'Trivandrum',
    'Chennai'
  ];
  String? selectedPlace;
  final _formKey = GlobalKey<FormState>();
  final contactController = TextEditingController();
  final studentnameContoller = TextEditingController();
  final controller = Get.put(StudentContoller());
  @override
  Widget build(BuildContext context) {
    if (widget.isEdit) {
      contactController.text = widget.value!.phone.toString();
      studentnameContoller.text = widget.value!.name.toString();
      controller.selectedimage.value = widget.value!.image.toString();
      selectedDomain = widget.value!.domain;
      selectedPlace = widget.value!.place;
    }
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          title: widget.isEdit
              ? Text(
                  'Edit',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                )
              : Text(
                  'Register',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                )),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(border: Border.all()),
                          child: controller.selectedimage.isNotEmpty
                              ? Image.file(
                                  File(controller.selectedimage.value),
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.person,
                                  size: 40,
                                ),
                        ),
                        Column(
                          children: [
                            IconButton(
                                onPressed: () async {
                                  // final picker = ImagePicker();
                                  // final pickedImage = await picker.pickImage(
                                  //     source: ImageSource.gallery);
                                  // if (pickedImage != null) {
                                  //   selectedImage = File(pickedImage.path);
                                  controller.getImage();
                                  // }
                                },
                                icon: Icon(Icons.image)),
                          ],
                        )
                      ],
                    ),
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validations.nameValidator,
                  controller: studentnameContoller,
                  decoration: InputDecoration(hintText: 'Student Name'),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validations.phoneValidator,
                  controller: contactController,
                  decoration: InputDecoration(hintText: 'Contact'),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 150),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: 'Select Domain',
                      focusedBorder: UnderlineInputBorder(),
                      // filled: true,
                      //fillColor: Colors.greenAccent,
                    ),
                    //  dropdownColor: const Color.fromARGB(255, 171, 185, 178),
                    value: selectedDomain,
                    onChanged: (String? newValue) {
                      selectedDomain = newValue!;
                    },
                    items: domain.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 150),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: 'Select Hub',
                      focusedBorder: UnderlineInputBorder(),
                      // filled: true,
                      //fillColor: Colors.greenAccent,
                    ),
                    //  dropdownColor: const Color.fromARGB(255, 171, 185, 178),
                    value: selectedPlace,
                    onChanged: (String? newValue) {
                      selectedPlace = newValue!;
                    },
                    items: place.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                widget.isEdit == false
                    ? InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate() &&
                              studentnameContoller.text.isNotEmpty &&
                              contactController.text.isNotEmpty &&
                              selectedDomain != null &&
                              selectedPlace != null &&
                              controller.selectedimage.isNotEmpty) {
                            registerStudent(
                                context,
                                studentnameContoller.text.trim(),
                                selectedPlace.toString(),
                                selectedDomain.toString(),
                                int.parse(contactController.text),
                                controller.selectedimage.toString(),
                                _formKey);
                            controller.selectedimage.value = '';
                          } else {
                            studentnameContoller.clear();
                            contactController.clear();
                            selectedImage = controller.getImage();
                            selectedDomain = null;
                            selectedPlace = null;
                            showSnackBar(
                                context, 'Register Faild!', Colors.red);
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ))
                    : InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate() &&
                                  studentnameContoller.text.isNotEmpty &&
                                  contactController.text.isNotEmpty &&
                                  selectedDomain != null &&
                                  selectedPlace != null
                              //  selectedImage!.path.isNotEmpty
                              ) {
                            editStudent(
                                context,
                                File(controller.selectedimage.toString()),
                                studentnameContoller.text,
                                selectedDomain.toString(),
                                selectedPlace.toString(),
                                int.parse(contactController.text.toString()),
                                int.parse(widget.value!.id.toString()));
                          } else {
                            studentnameContoller.clear();
                            contactController.clear();
                            selectedImage =
                                //  value.getimage(selectedImage = null);
                                // value.getimage(File(selectedImage.path.));
                                selectedDomain = null;
                            selectedPlace = null;
                            showSnackBar(
                                context, 'Register Faild!', Colors.red);
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 0, 0, 0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
