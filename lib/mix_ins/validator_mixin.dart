class ValidatorMixin {
  // very basic validation for email in front end
  String emailValidation(String value) {
    // automatically passing text entered --> value
    if(value.contains('@')) return null;
    return 'Enter a valid email';
  }

  String passwordValidation (String value) {
    // current value of the formfield
    if(value.length < 4) return 'Password must be at least 4 charactors';
    return null;
  }

  String nameValidation (String value) {
    if(value.length == 0) return 'Name cannot be empty';
    return null;
  }

  String phoneValidation(String value) {
    if(value.length == 10 && value.startsWith('0') && !value.contains(RegExp(r'[^0-9]'))){
      return null;
    }
    return 'Enter a valid mobile number';
  }

}