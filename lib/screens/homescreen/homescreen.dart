import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sql_lite_demo/config/app_colors.dart';
import 'package:sql_lite_demo/db/db_helper.dart';
import 'package:sql_lite_demo/model/student_model.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  var studentData = [];
  String greeting = "Good\nmoring!";
  void getGreeting() {
    var hour = DateTime.now().hour;
    print("Current hour: $hour");

    if (hour >= 1 && hour < 12) {
      setState(() {
        greeting = "Good\nmoring!";
      });
    } else if (hour >= 12 && hour < 18) {
      setState(() {
        greeting = "Good\nAfternoon!";
      });
    } else {
      setState(() {
        greeting = "Good\nEvening!";
      });
    }
  }

  void loadData() async {
    var data = await DbHelper.readStudents();
    setState(() {
      studentData = data;
    });
    print("Student Data : $studentData");

    var stu = StudentModel.fromJson(studentData[1]);
    print("Student Name : ${stu.firstName}");
    print("Student Name : ${stu.lastName}");
    print("Student Name : ${stu.dob}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    getGreeting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: addButton(),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        // physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            buildHeader(),
            buildOption(),
            buildStudentList(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      color: AppColors.primaryColor,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
            ),
            Spacer(),
            SizedBox(
              //for responsive text
              width: MediaQuery.of(context).size.width * 0.8,
              child: FittedBox(
                child: Text(
                  "${greeting.toUpperCase()}",
                  style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      height: 1),
                ),
              ),
            ),
            Text(
              "You have ${studentData.length} student(s) in your database",
              style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  height: 2),
            )
          ],
        ),
      ),
    );
  }

  Widget buildOption() {
    return Container();
  }

  Widget buildStudentList() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "All Students",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              GestureDetector(
                child: Text(
                  "View All",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 20),
            itemBuilder: (context, index) {
              var student = StudentModel.fromJson(studentData[index]);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      radius: 35,
                      backgroundImage: FileImage(File(student.profile)),
                      child: student.profile.isEmpty
                          ? Text(
                              "${student.firstName[0].toUpperCase()}${student.lastName[0].toUpperCase()}",
                              style: GoogleFonts.spaceGrotesk(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          : SizedBox(),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          "Full name : ${student.firstName} ${student.lastName}",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "Gender : ${student.gender}",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              showDragHandle: true,
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                AppColors.primaryColor,
                                            radius: 30,
                                            backgroundImage: FileImage(
                                                File(student.profile)),
                                            child: student.profile.isEmpty
                                                ? Text(
                                                    "${student.firstName[0].toUpperCase()} ${student.lastName[0].toUpperCase()}",
                                                    style: GoogleFonts
                                                        .spaceGrotesk(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                  )
                                                : SizedBox(),
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              title: Row(
                                                children: [
                                                  Text(
                                                    "${student.firstName} ${student.lastName}",
                                                    style: GoogleFonts
                                                        .spaceGrotesk(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: student
                                                                      .gender ==
                                                                  "Male"
                                                              ? Colors
                                                                  .blueAccent
                                                              : Colors
                                                                  .pinkAccent,
                                                          width: 2),
                                                      color: student.gender ==
                                                              "Male"
                                                          ? const Color
                                                              .fromARGB(
                                                              93, 33, 149, 243)
                                                          : const Color
                                                              .fromARGB(
                                                              76, 233, 30, 98),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Text(
                                                      student.gender,
                                                      style: GoogleFonts
                                                          .spaceGrotesk(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: student
                                                                          .gender ==
                                                                      "Male"
                                                                  ? Colors.blue
                                                                  : Colors
                                                                      .pink),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Text(
                                                " DOB : ${student.dob}",
                                                style: GoogleFonts.spaceGrotesk(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey.withValues(alpha: 0.3),
                                      thickness: 1,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, "/addStudent",
                                            arguments: [true, student]).then(
                                          (value) {
                                            loadData();
                                          },
                                        );
                                      },
                                      title: Text(
                                        "Update Student",
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Update student details",
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      leading: Icon(
                                        Icons.edit,
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        DbHelper.deleteStudent(student.id);
                                        loadData();
                                      },
                                      textColor: Colors.red,
                                      iconColor: Colors.red,
                                      title: Text(
                                        "Delete Student",
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Delete student details",
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      leading: Icon(Icons.delete),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.more_horiz_sharp,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: studentData.length,
          )
        ],
      ),
    );
  }

  Widget addButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/addStudent", arguments: [false, null])
            .then(
          (value) {
            loadData();
          },
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: AppColors.primaryColor),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
