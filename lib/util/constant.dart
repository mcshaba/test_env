class Constant {
  static const String BASE_URL = "https://letsenvision.app/api/test";


  static Constant instant = Constant._internal();


  factory Constant(){
    return instant;
  }
  Constant._internal();

}