
part of 'DataFrame.dart';


abstract class DFColumn {
  String name;

  int get length;

  List<dynamic> get values;

  get type;

  get valueType;

  List<String> asString();

  List<int?> asInt();

  List<double?> asDouble();

  List<bool?> asBool();

  List asList(); // todo: atm does nothing special

  DFColumn(this.name, {List? values});

  extend(int length) {
    if (length < this.length) {
      throw Exception('Cannot extend column to shorter length');
    }
    else {
      while (this.length < length) {
        values.add(null);
      }
    }
  }

  static DFColumn autoInferType(String name, List<String> values) {
    T? changeType<T>(String value) {
      if (T == int) {
        return int.tryParse(value) as T;
      }
      else if (T == double) {
        return double.tryParse(value) as T;
      }
      else if (T == bool) {
        if (value == 'true' || value == 'True') return true as T;
        if (value == 'false' || value == 'False') return false as T;
        throw Exception('Invalid bool value');
      }
      else if (T == String) {
        return value as T;
      }
      else {
        throw Exception('Invalid type');
      }
    }


    Type? getLowestType(String value) {
      if (value == '' || value == 'null' || value == 'None') {
        return null;
      }
      else if (value.contains('.')){
        try {
          double x = double.parse(value);
          return double;
        }
        catch (e){}
      }
      else if (value == 'true'|| value == 'false' || value == 'True' || value == 'False') {
        return bool;
      }
      try {
        int x = int.parse(value);
        return int;
      }
      catch (e){}
      return String;
    }

    List<Type?> types = [];
    for (String value in values) {
      var type = getLowestType(value);
      if (!types.contains(type)) {
        types.add(type);
        if (types.length > 1) {
          if (types.contains(String) && (types.contains(double) || types.contains(int) || types.contains(bool))) {
            types = [dynamic];
            break;
          }
          else if (types.contains(bool) && (types.contains(double) || types.contains(int))) {
            types = [dynamic];
            break;
          }
        }
      }
    }
    var ntypes = types.map((t) => t).toList();

    Type x = String;
    if (ntypes.length == 1) {
      if (ntypes[0] == null){
        x = dynamic;
      }
      else {
        x = ntypes[0]!;
      }

    }
    else if (ntypes.length == 2) {
      if (ntypes.contains(double) && ntypes.contains(int)) {
        x = double;
      }
    }

    if (x == dynamic) {
      var tmp = DFDColumn(name);
      for (String value in values) {
        Type? tt = getLowestType(value);
        if (tt == null) {
          tmp.values.add(null);
        }
        else if (tt == double) {
          tmp.values.add(changeType<double>(value));
        }
        else if (tt == int) {
          tmp.values.add(changeType<int>(value));
        }
        else if (tt == bool) {
          tmp.values.add(changeType<bool>(value));
        }
        else if (tt == String) {
          tmp.values.add(changeType<String>(value));
        }
      }
      return tmp;
    }
    else if (x == double) {
      var tmp = DFFColumn(name);
      for (String value in values) {
        tmp.values.add(changeType<double>(value));
      }
      return tmp;
    }
    else if (x == int) {
      var tmp = DFIColumn(name);
      for (String value in values) {
        tmp.values.add(changeType<int>(value));
      }
      return tmp;
    }
    else if (x == bool) {
      var tmp = DFBColumn(name);
      for (String value in values) {
        tmp.values.add(changeType<bool>(value));
      }
      return tmp;
    }
    else if (x == String) {
      var tmp = DFSColumn(name);
      for (String value in values) {
        tmp.values.add(changeType<String>(value));
      }
      return tmp;
    }
    else {
      throw Exception('Invalid type');
    }
  }

  bool all() {
    for (var element in values) {
      if (element == null) {
        return false;
      }
    }
    return true;
  }

  bool any() {
    for (var element in values) {
      if (element != null) {
        return true;
      }
    }
    return false;
  }

  void fillna(dynamic value) {
    if (type != DFDColumn && value.runtimeType != valueType) {
      throw("Invalid fill type ${value.runtimeType} for $type");
    }
    for (var i in naLocs()) {
      this[i] = value;
      print(values[i]);
    }
  }

  List<int> naLocs() {
    List<int> locs = [];
    for (int i = 0; i < length; i++ ) {
      if (values[i] == null) {
        locs.add(i);
      }
    }
    print(locs);
    return locs;
  }

  DFColumn copy() {  // todo not efficient
    return DFColumn.autoInferType(name, asString());
  }

  operator [](index);
  operator []=(index, value);

}

class DFIColumn extends DFColumn {
  List<int?> values = [];

  DFIColumn(String name, {List<int?>? values}) : super(name) {
    if (values != null) {
      this.values = values;
    }
  }

  @override
  operator [](index) {
    values[index];
  }
  operator []=(index, value) {
    values[index] = value;
  }


  @override
  get length => values.length;

  @override
  get type => DFIColumn;

  @override
  get valueType => int;

  @override
  List<bool?> asBool() => values.map((e) => e != 0 ).toList();

  @override
  List<double?> asDouble() => values.map((e) => e?.toDouble()).toList();

  @override
  List<int?> asInt() => values.map((e) => e).toList();

  @override
  List<String> asString() => values.map((e) => e.toString()).toList();

  @override
  asList() => values;

}


class DFSColumn extends DFColumn {
  List<String?> values = [];

  DFSColumn(String name, {List<String?>? values}) : super(name){
    if (values != null) {
      this.values = values;
    }
  }

  @override
  operator [](index) {
    values[index];
  }
  operator []=(index, value) {
    values[index] = value;
  }

  @override
  get length => values.length;

  @override
  get type => DFSColumn;

  @override
  get valueType => String;

  @override
  List<bool?> asBool() => values.map((e) => e != 'false' && e != '0' && e != '' && e != 'null' && e != 'False' ).toList();

  @override
  List<double?> asDouble() => values.map((e) => e != null? double.tryParse(e) : null).toList();

  @override
  List<int?> asInt() => values.map((e) => e != null? int.tryParse(e) : null).toList();

  @override
  List<String> asString() => values.map((e) => (e != null)? e: "null").toList();

  @override
  asList() => values;
}

class DFFColumn extends DFColumn {
  List<double?> values = [];

  DFFColumn(String name, {List<double?>? values}) : super(name){
    if (values != null) {
      this.values = values;
    }
  }

  @override
  operator [](index) {
    values[index];
  }
  operator []=(index, value) {
    values[index] = value;
  }

  @override
  get length => values.length;

  @override
  get type => DFFColumn;

  @override
  get valueType => double;

  @override
  List<bool?> asBool() => values.map((e) => e != 0 ).toList();

  @override
  List<double?> asDouble() => values;

  @override
  List<int?> asInt() => values.map((e) => e?.toInt()).toList();

  @override
  List<String> asString() => values.map((e) => e.toString()).toList();

  @override
  asList() => values;
}

class DFBColumn extends DFColumn {
  List<bool?> values = [];

  DFBColumn(String name, {List<bool?>? values}) : super(name){
    if (values != null) {
      this.values = values;
    }
  }

  @override
  operator [](index) {
    values[index];
  }
  operator []=(index, value) {
    values[index] = value;
  }

  @override
  get length => values.length;

  @override
  get type => DFBColumn;

  @override
  get valueType => bool;

  @override
  List<bool?> asBool() => values;

  @override
  List<double?> asDouble() => values.map((e) => e != null ? e? 1.0 : 0.0 : null).toList();

  @override
  List<int?> asInt() => values.map((e) => e != null ? e? 1 : 0 : null).toList();

  @override
  List<String> asString() => values.map((e) => e.toString()).toList();

  @override
  asList() => values;
}

class DFDColumn extends DFColumn {
  List<dynamic> values = [];

  DFDColumn(String name) : super(name);

  @override
  operator [](index) {
    values[index];
  }
  operator []=(index, value) {
    values[index] = value;
  }

  @override
  get length => values.length;

  @override
  get type => DFDColumn;

  @override
  get valueType => dynamic;

  @override
  List<bool?> asBool() => values.map((e) => e != null ).toList();

  @override
  List<double?> asDouble() => [0.0]; // todo

  @override
  List<int?> asInt() => [0]; // todo

  @override
  List<String> asString() => values.map((e) => e.toString()).toList();

  @override
  asList() => values;
}