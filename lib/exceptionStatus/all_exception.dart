class UnProcessedEntitiy implements Exception {
  @override
  String toString() {
    return " Missing Field";
  }
}

class LoginFailed implements Exception {
  @override
  String toString() {
    return " Creadintal rejected !!!";
  }
}

class RedirectionFound implements Exception {
  @override
  String toString() {
    return "too Many Redirections !!!";
  }
}

class ResouceNotFound implements Exception {
  String message;

  ResouceNotFound(this.message);

  @override
  String toString() {
    return "Resource $message Not Found";
  }
}

class NoInternetConnection implements Exception{

  @override
  String toString() {
    return " No Interneeeeeeeeeeeeet ";
  }
}

class PropertyIsRequired implements Exception{
  String field;
  PropertyIsRequired(this.field);

  @override
  String toString() {
    return 'Property ${this.field} is Required';
  }


}
