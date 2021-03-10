class User {
  String id; // ?
  String firstName;
  String lastName;
  String email; // ?
  String mobileNumber;
  String token; // ?

  User({this.id, this.firstName, this.lastName, this.email, this.mobileNumber, this.token});

  User.fromJson(Map<String, dynamic> parsedJson){
    id = parsedJson['id'];
    firstName = parsedJson['firstName'];
    lastName = parsedJson['lastName'];
    email = parsedJson['email']; // ?
    mobileNumber = parsedJson['mobileNumber'];
    token = parsedJson['token']; // ?
  }

}