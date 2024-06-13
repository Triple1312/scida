

void throwTypedError(String location, List<Type> acceptedTypes, dynamic variable, String variablename) {
  throw Exception('Error in $location: $variablename is of type ${variable.runtimeType}, but should be of type ${acceptedTypes.toString()}');
}