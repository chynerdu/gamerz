class HelperFunctions {
  String listToString(List words) {
    return words.toString().replaceAll('[', '').replaceAll(']', '');
  }
}
