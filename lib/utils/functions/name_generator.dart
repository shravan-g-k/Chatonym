import 'package:username_gen/username_gen.dart';

class NameGenerator {
  static String generateName() {
    String name = UsernameGen().generate();
    if (name.length > 17) {
      name = generateName();
    }
    return name;
  }
}
