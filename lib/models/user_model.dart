class User {
  String id; // ?
  String firstName;
  String lastName;
  String email; // ?
  String mobileNumber;
  String token; // ?

  User(this.id, this.firstName, this.lastName, this.email, this.mobileNumber, this.token);

  User.fromJson(Map<String, dynamic> parsedJson){
    id = parsedJson['id'] ?? 'null id';
    firstName = parsedJson['first_name'] ?? 'null firstname';
    lastName = parsedJson['last_name'] ?? 'null lastname';
    email = parsedJson['email'] ?? 'nullvalue@null.com'; // ?
    mobileNumber = parsedJson['mobile'] ?? '0999999999';
    token = parsedJson['token'] ?? 'nulltoken'; // ?
  }


}