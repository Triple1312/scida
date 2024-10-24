
part of 'DDataFrame.dart';

class DFColumn<T> extends Iterable<T?>  {
  String name;

  List<T?> _values = [];

  get type => DFColumn<T>;

  get valueType => T;

  get length => _values.length;

  get unique => _values.toSet().toList(); // todo could be more efficient maybe

  get vocabulary => _values.toSet();

  operator [](int index) {
    _values[index];
  }
  operator[]=(int index, T value) {
    _values[index] = value;
  }

  DFColumn(String this.name, {List<T?>? values}) {
    if (values != null) {
      this._values = values;
    }
  }

  static DFColumn autoInferType(String name, List<dynamic> values) {
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
      var tmp = DFColumn<dynamic>(name);
      for (String value in values) {
        Type? tt = getLowestType(value);
        if (tt == null) {
          tmp._values.add(null);
        }
        else if (tt == double) {
          tmp._values.add(changeType<double>(value));
        }
        else if (tt == int) {
          tmp._values.add(changeType<int>(value));
        }
        else if (tt == bool) {
          tmp._values.add(changeType<bool>(value));
        }
        else if (tt == String) {
          tmp._values.add(changeType<String>(value));
        }
      }
      return tmp;
    }
    else if (x == double) {
      var tmp = DFColumn<double>(name);
      for (String value in values) {
        tmp._values.add(changeType<double>(value));
      }
      return tmp;
    }
    else if (x == int) {
      var tmp = DFColumn<int>(name);
      for (String value in values) {
        tmp._values.add(changeType<int>(value));
      }
      return tmp;
    }
    else if (x == bool) {
      var tmp = DFColumn<bool>(name);
      for (String value in values) {
        tmp._values.add(changeType<bool>(value));
      }
      return tmp;
    }
    else if (x == String) {
      var tmp = DFColumn<String>(name);
      for (String value in values) {
        tmp._values.add(changeType<String>(value));
      }
      return tmp;
    }
    else {
      throw Exception('Invalid type');
    }
  }

  extend(int length) {
    if (length < this.length) {
      throw Exception('Cannot extend column to shorter length');
    }
    else {
      while (this.length < length) {
        _values.add(null);
      }
    }
  }

  bool all() {
    for (var element in _values) {
      if (element == null) {
        return false;
      }
    }
    return true;
  }

  bool _any() {
    var x = any();
    return true;
  }

  @override
  bool any([bool test(T element)?]) {
    test ??= (T? element) => element != null;
    for (T? element in this._values) {
      if (element == null) {
        continue;
      }
      if (test(element)) return true;
    }
    return false;
  }

  void fillna(dynamic value) {
    if (T != dynamic && value.runtimeType != T) {
      throw("Invalid fill type ${value.runtimeType} for $type");
    }
    for (var i in naLocs()) {
      this[i] = value;
    }
  }

  List<int> naLocs() {
    List<int> locs = [];
    for (int i = 0; i < length; i++ ) {
      if (_values[i] == null) {
        locs.add(i);
      }
    }
    return locs;
  }

  Map<int, dynamic> to_dict() {
    Map<int, dynamic> res = {};
    for (int i = 0; i < length; i++) {
      res[i] = _values[i];
    }
    return res;
  }

  DFColumn<T> copy() { // todo not efficient
    return DFColumn<T>(name, values: asList());
  }

  List<String> asString()  => _values.map((e) => e.toString()).toList();

  List<T?> asList() => _values.map((e) => e).toList();

  List<int?> asInt() => _values.map((e) => e != null? valueType == String? int.tryParse(e as String) : (e as double).floor() : null).toList();

  List<double?> asDouble() => _values.map((e) => e != null? valueType == String? double.tryParse(e as String) : e as double : null).toList();

  List<bool> asBool() => _values.map((e) => e != 'false' && e != '0' && e != '' && e != 'null' && e != 'False' && e != 0 && e != 0.0).toList();


  //////////////////////////////////// ITERATOR ////////////////////////////////////
  @override
  Iterator<T?> get iterator => _ColumnIterator<T>(this);

}


class _ColumnIterator<T> implements Iterator<T> {
  final DFColumn<T> _column;
  int _index = -1;

  _ColumnIterator(this._column);

  @override
  T get current => _column[_index];

  @override
  bool moveNext() {
    _index++;
    return _index < _column.length;
  }
}