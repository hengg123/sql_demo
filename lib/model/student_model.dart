// ignore_for_file: public_member_api_docs, sort_constructors_first
class StudentModel {
  int id;
  String firstName;
  String lastName;
  String gender;
  String dob;
  String profile;

  StudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.profile
  });

  //create factory constructor
  // StudentModel.fromJson(Map<String, dynamic> data) :
  //   id = data["id"],
  //   firstName = data["first_name"],
  //   lastName = data["last_name"],
  //   gender = data["gender"],
  //   dob = data["dob"];

  factory StudentModel.fromJson(Map<String, dynamic> data) {
    return StudentModel(
      id: data["id"], 
      firstName: data["first_name"], 
      lastName: data["last_name"],
      gender: data["gender"], 
      dob: data["dob"],
      profile: data["profile"]);
  }
}
