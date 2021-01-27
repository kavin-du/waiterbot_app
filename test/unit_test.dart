import 'package:flutter_test/flutter_test.dart';
import 'package:waiterbot_app/mix_ins/validator_mixin.dart';


// these are unit tests
void main() {

    // setup

    // run 

    // verify

  // you can add several expects to single test
  // startUp(){} , tearDown(){} -> calls before and after each test
  group('Email testing', (){
    test('empty email returns error message', (){
      
      var result = ValidatorMixin().emailValidation('');
      expect(result, 'Enter a valid email');

    });

    test('correct email returns null', (){
      
      var result = ValidatorMixin().emailValidation('test@test.com');
      expect(result, null);

    });
  });
  
  group('Password testing', (){
    test('password less than 8 returns error message', (){
      var result = ValidatorMixin().passwordValidation('sdff');
      expect(result, 'Password must be at least 8 charactors');
    });

    test('correct password returns null', (){
      var result = ValidatorMixin().passwordValidation('sdfsdfs5d22f');
      expect(result, null);
    });

  });

  


}