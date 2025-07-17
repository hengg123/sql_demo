import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sql_lite_demo/config/app_colors.dart';
import 'package:badges/badges.dart' as badges;
import 'package:sql_lite_demo/db/db_helper.dart';
// import 'package:sql_lite_demo/model/student_model.dart';

class AddStuScreen extends StatefulWidget {
  const AddStuScreen({super.key});

  @override
  State<AddStuScreen> createState() => _AddStuScreenState();
}

class _AddStuScreenState extends State<AddStuScreen> {
  var fnCtrl = TextEditingController();
  var lnCtrl = TextEditingController();
  String gender = "";
  String selectedDOB = "";
  String selectedProfile = "";

  void chooseProfile(ImageSource source) async {
    var imgPicked = await ImagePicker().pickImage(source: source);

    print("Image : ${imgPicked!.path}");

    setState(() {
      selectedProfile = imgPicked.path;
    });
  }

  var isUpdate = false;
  int id = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  // @override
void loadData(){
  var student = ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    isUpdate = student[0];
    if(student[1] != null ){
      fnCtrl.text = student[1].firstName;
      lnCtrl.text = student[1].lastName;
      gender = student[1].gender;
      selectedDOB = student[1].dob;
      selectedProfile = student[1].profile;
      id = student[1].id;
    }
    setState(() {
      isInit = true;
    });
}

bool isInit = false;

  @override
  Widget build(BuildContext context) {
  if(isInit == false){
    loadData();
  }
    

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          isUpdate ? "Update Student" : "Add Student",
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSelectProfile(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "First name",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    height: 2.5,
                  ),
                ),
                buildTextField(hint: "Enter first name", controller: fnCtrl),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Last name",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    height: 2.5,
                  ),
                ),
                buildTextField(hint: "Enter last name", controller: lnCtrl),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Gender",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                buildGenderSelector(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Date of Birth",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 2.5,
                  ),
                ),
                buildDobSelector(),
                SizedBox(
                  height: 20,
                ),
                buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSelectProfile() {
    return GestureDetector(
            
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              //dialog self-design
              title: Text("Choose options"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      chooseProfile(ImageSource.camera);
                    },
                    leading: Icon(Icons.camera_alt),
                    title: Text("Camera"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      chooseProfile(ImageSource.gallery);
                    },
                    leading: Icon(Icons.photo_library),
                    title: Text("Gallery"),
                  )
                ],
              ),
              contentPadding: EdgeInsets.only(left: 20, right: 20),
              actionsPadding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                )
              ],
            );
          },
        );
      },
      child: Center(
        child: badges.Badge(
          badgeContent: Icon(
            Icons.add,
            color: Colors.white,
          ),
          position: badges.BadgePosition.bottomEnd(
            bottom: 5,
            end: 5,
          ),
          child: Container(
            width: 150,
            height: 150,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: selectedProfile.isEmpty
                ? SizedBox()
                : Image.file(
                    File(selectedProfile),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      {required String hint, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.all(20),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget buildGenderSelector() {
    return Row(
      children: [
        Radio(
          value: "Male",
          groupValue: gender, // value for comparison
          onChanged: (value) {
            setState(() {
              gender = value!;
            });
          },
        ),
        Text(
          "Male",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Radio(
          value: "Female",
          groupValue: gender, // value for comparison
          onChanged: (value) {
            setState(() {
              gender = value!;
            });
          },
        ),
        Text(
          "Female",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Widget buildDobSelector() {
    return GestureDetector(
      onTap: () {
        showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDate: DateTime.now(),
        ).then(
          (value) {
            setState(() {
              print(value);

              //EEE : day of the week (mon, tue ...)
              //EEEE : full day of the week (Monday, Tuesday ...)
              //dd : day of the month (01, 02, ...)
              //MMM : short month name (Jan, Feb, ...)
              //MMMM : full month name (January, February, ...)
              //yyyy : full year (2023, 2024, ...)
              //yy : short year (23, 24, ...)

              selectedDOB = DateFormat("EEE, dd MMMM ''yyyy").format(value!);
            });
          },
        );
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            selectedDOB.isEmpty ? "Select DOB" : selectedDOB,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton() {
    return GestureDetector(
      onTap: () {
        if (fnCtrl.text.isEmpty || lnCtrl.text.isEmpty || gender.isEmpty || selectedDOB.isEmpty ) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields!!"),),);         
        }
        else{
          isUpdate ? DbHelper.updateStudents(
          fn: fnCtrl.text,
          ln: lnCtrl.text,
          gender: gender,
          dob: selectedDOB,
          profile: selectedProfile,
          id: id,
        ) :
        DbHelper.insertStudents(
          fn: fnCtrl.text,
          ln: lnCtrl.text,
          gender: gender,
          dob: selectedDOB,
          profile: selectedProfile
        );

        if(isUpdate == true){
          Navigator.pop(context);
        }

         setState(() {
          fnCtrl.clear();
          lnCtrl.clear();
          gender = "";
          selectedDOB = "";
          selectedProfile = "";
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text( isUpdate ? "Student updated successfully!" : "Student added successfully!")));
        };
      },

      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primaryColor,
        ),
        child: Center(
          child: Text(isUpdate ? "Update Student" : "Add Student",
              style:
                  GoogleFonts.spaceGrotesk(fontSize: 15, color: Colors.white)),
        ),
      ),
    );
  }
}
