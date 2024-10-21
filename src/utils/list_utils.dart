


List<bool> list_to_bool(List list) {
  List<bool> bool_list = [];
  for (var i in list) {
    if (i == null) {
      bool_list.add(false);
      continue;
    }
    switch (i.runtimeType) {
      case bool:
        bool_list.add(i);
        break;
      case int:
        if (i == 0) {
          bool_list.add(false);
        } else {
          bool_list.add(true);
        }
        break;
      case double:
        if (i == 0.0) {
          bool_list.add(false);
        } else {
          bool_list.add(true);
        }
        break;
      case String:
        if (i == "" || i == "0" || i == "false") {
          bool_list.add(false);
        } else {
          bool_list.add(true);
        }
        break;
      case List:
        if (i.length == 0) {
          bool_list.add(false);
        } else {
          bool_list.add(true);
        }
        break;
      case Object:
        if (i == null) {
          bool_list.add(false);
        } else {
          bool_list.add(true);
        }
        break;
      default:
        bool_list.add(false);
    }
  }
  return bool_list;
}

List<int> list_to_int(List list) {
  List<int> int_list = [];
  for (var i in list) {
    if (i == null) {
      int_list.add(0);
      continue;
    }
    switch (i.runtimeType) {
      case bool:
        if (i) {
          int_list.add(1);
        } else {
          int_list.add(0);
        }
        break;
      case int:
        int_list.add(i);
        break;
      case double:
        int_list.add(i.toInt());
        break;
      case String:
        int? x = int.tryParse(i);
        if (x != null) {
          int_list.add(x);
        } else {
          int_list.add(0);
        }
        break;
      case List:
        int_list.add(i.length);
        break;
      case Object:
        int_list.add(1);
        break;
      default:
        int_list.add(0);
    }
  }
  return int_list;
}

List<String> list_to_string(List list) => list.map((e) => e.toString()).toList();

List<double> list_to_double(List list) {
  List<double> double_list = [];
  for (var i in list) {
    if (i == null) {
      double_list.add(0);
      continue;
    }
    switch (i.runtimeType) {
      case bool:
        if (i) {
          double_list.add(1.0);
        } else {
          double_list.add(0.0);
        }
        break;
      case int:
        double_list.add(i);
        break;
      case double:
        double_list.add(i);
        break;
      case String:
        double? x = double.tryParse(i);
        if (x != null) {
          double_list.add(x);
        } else {
          double_list.add(0.0);
        }
        break;
      case List:
        double_list.add(i.length);
        break;
      case Object:
        double_list.add(1.0);
        break;
      default:
        double_list.add(0.0);
    }
  }
  return double_list;
}