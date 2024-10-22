

import 'dart:io';

import 'package:meta/meta.dart';


import '../series/series.dart';

part 'DFColumn.dart';
part 'node.dart';

class DDataFrame {
  List<DFColumn> _data = [];
  Map<dynamic,int> indeces = {}; // a dict to store the index of a row with a different name


  //////////////////////////////// Constructors ////////////////////////////////

  DDataFrame.fromLL(List<List<dynamic>> data, {bool inferTypes = false}) {
    int i = 7;
  }

  DDataFrame.from_csv(String path, {bool inferTypes = false, List<Type> columntypes = const [], bool removePadding = false, String sep=','}) {
    var file = File(path).readAsStringSync();
    List<String> lines = file.split('\n');
    List<String> columnNames = lines[0].split(sep);
    List<String> data = lines.sublist(1).map((e) => e.split(sep)).toList().fold(([]), (List<String> prev, List<String> lst) => prev + lst);
    int columnCount = columnNames.length;
    int rowCount = lines.length - 1;
    List<int> rowList = List.generate(rowCount-1, (index) => index);
    if (inferTypes) {
      _data = List.generate(columnCount, (index) => DFColumn.autoInferType(columnNames[index], rowList.map((i) => data[i*columnCount + index]).toList()));
    }
    else {
      _data = List.generate(columnCount, (index) => DFColumn<String>(columnNames[index], values: rowList.map((i) => data[i*columnCount + index]).toList()));
    }
  }

  // from_records todo


  DDataFrame.from_dict(Map<String, Map<int, dynamic>> data, {bool inferTypes = false}) {
    for (var entry in data.entries) {
      if (inferTypes) {
        _data.add(DFColumn.autoInferType(entry.key, entry.value.values.toList()));
      }
      else {
        _data.add(DFColumn(entry.key, values: entry.value.values.toList()));
      }
    }
  }

  // if NDarray has a specific type, it will be used for all columns // todo not tested at all
  DDataFrame.from_ndarray(NDarray ndarray ,{bool inferTypes = false}) {
    if (ndarray.depth > 2) {
      throw Exception('NDarray must be 1 or 2 dimensional');
    }
    List<List> ndvalues = ndarray.data;
    Type narraytype = ndarray.valueType;
    if (narraytype == dynamic && inferTypes) {
      _data = List.generate(ndvalues.length, (index) => DFColumn.autoInferType("Column_${index.toString()}", ndvalues[index]));
    }
    else if(narraytype == dynamic) {
      _data = List.generate(ndvalues.length, (index) => DFColumn("Column_${index.toString()}", values: ndvalues[index]));
    }
    else if(narraytype == int) {
      _data = List.generate(ndvalues.length, (index) => DFColumn<int>("Column_${index.toString()}", values: ndvalues[index] as List<int>));
    }
    else if(narraytype == double) {
      _data = List.generate(ndvalues.length, (index) => DFColumn<double>("Column_${index.toString()}", values: ndvalues[index] as List<double>));
    }
    else if(narraytype == bool) {
      _data = List.generate(ndvalues.length, (index) => DFColumn<bool>("Column_${index.toString()}", values: ndvalues[index] as List<bool>));
    }
    else if(narraytype == String) {
      _data = List.generate(ndvalues.length, (index) => DFColumn<String>("Column_${index.toString()}", values: ndvalues[index] as List<String>));
    }

  }

  DDataFrame({ // todo should really do something
    Object? data,
    List<dynamic>? index,
    List<dynamic>? dtypes,
    bool inferTypes = false,
    List<DFColumn>? columns
  }) {

  }

  //////////////////////////////// Getters ////////////////////////////////

  // todo check if works
  List<List<dynamic>> get axes => [new List<dynamic>.generate(_data[0].length, (i)=> i+1)
    ..map((e) => indeces.values.contains(e)? indeces.entries.firstWhere((e) => e.value == e): e),
    _data.map((e) => e.asList()).toList()];

  // get shape todo no idea

  // todo test
  bool get _is_homogeneous_type => _data.map((e) => e.runtimeType).toSet().length == 1;

  //bool get _can_fast_transpose todo

  // get _values todo

  // _get_values_for_csv(...) todo

  // get style todo

  get length => _data.isEmpty? 0: _data[0].length;

  get shape => [_data.isEmpty? 0: _data[0].length, _data.length];

  get size => _data.isEmpty? 0: _data[0].length * _data.length;

  get columns => _data.map((e) => e.name).toList();

  get T => transpose();

  get valueType => _data.fold(null, (prev, el) => prev == null? el.valueType: prev == el.valueType? prev: dynamic);

  //////////////////////////////// Type changers ////////////////////////////////

  List<List> as_type( Type type) {
    if (type == int) {
      return asInt();
    }
    else if (type == double) {
      return asDouble();
    }
    else if (type == bool) {
      return asBool();
    }
    else if (type == String) {
      return asString();
    }
    else if (type == dynamic) {
      return _data.map((e) => e.asList()).toList();
    }
    else {
      throw Exception('Invalid type');
    }
  }

  List<List<int?>> asInt() => _data.map((e) => e.asInt()).toList();

  List<List<double?>> asDouble() => _data.map((e) => e.asDouble()).toList();

  List<List<bool?>> asBool() => _data.map((e) => e.asBool()).toList();

  List<List<String>> asString() => _data.map((e) => e.asString()).toList();

  List<List> asList() => _data.map((e) => e.asList()).toList();

  //////////////////////////////// To Formats ////////////////////////////////

  Map<String, Map<int, dynamic>> to_dict(){
    Map<String, Map<int, dynamic>> res = {};
    for (var col in _data) {
      res[col.name] = col.to_dict();
    }
    return res;
  }

  // since NDarray can not have null and be typed, it will automatically be dynamic
  NDarray to_ndarray() { // todo maybe try to autofix types
    NDarray constructWithType(Type t, List values) {
      if (t == int) {
        return NDarray<int>(values: values);
      }
      else if (t == double) {
        return NDarray<double>(values: values);
      }
      else if (t == bool) {
        return NDarray<bool>(values: values);
      }
      else if (t == String) {
        return NDarray<String>(values: values);
      }
      else {
        return NDarray(values: values);
      }
    }

    Type type = _data[0].valueType;
    for (int i=1; i < _data.length; i++) {
      if (_data[i].valueType != type) {
        if (type == double && _data[i].valueType == int) {
          type = double;
        }
        else if (type == int && _data[i].valueType == double) {
          type = double;
        }
        else {
          type = dynamic;
          break;
        }
      }
      else if(_data[i].all() != true) {
        type = dynamic;
        break;
      }
    }
    return constructWithType(type, asList());
  }

  // to_records(...) todo

  // to_stata(...) todo

  // to_feather(...) todo

  // to_markdown(...) todo

  // to_parquet(...) todo

  // to_orc(...) todo

  // to_html(...) todo

  // to_xml(...) todo

  // to_gbq(...) todo


  ////////////////////////////////  ////////////////////////////////


  // items() todo

  // iterrows() todo

  // itertuples() todo











  // info(...) todo
  
  DDataFrame transpose() {
    List<List<dynamic>> listed = _data.map((e) => e.asList()).toList();
    List<List<dynamic>> transposed = [];
    for (int i = 0; i < listed[0].length; i++) {
      transposed.add(listed.map((e) => e[i]).toList());
    }
    return DDataFrame.fromLL(transposed);
  }



  // indexing methods todo

  // lookup caching todo

  ////////////////////  unsorted  ///////////////////

  // query(...) todo

  // eval(...) todo

  // select_dtypes(...) todo

  // insert column inside specified location
  insert({required int loc, required DFColumn column}) {
    if (column.name != '' && _data.map((e) => e.name).contains(column.name)) {
      throw Exception('Column with name ${column.name} already exists');
    }
    // _data.insert(loc, column);
    if (column.length < _data[0].length) {
      column.extend(_data[0].length);
    }
    if (column.length > _data[0].length) {
      throw Exception('Column length must be equal (or shorter) to dataframe length');
    }
    _data.insert(loc, column);
  }

  DDataFrame assign(List<DFColumn> cols) {
    DDataFrame df = copy();
    for (DFColumn col in cols) {
      if (df.hasColumnName(col.name)) {
        df.setColumn(col.name, col);
      }
      else {
        df.addColumn(column: col);
      }
    }
    return df;
  }


  // reindexing and alignment methods

  // _reindex_multi todo

  // set_axis(...) todo

  // reindex(...) todo

  drop({List<int>? labels, int axis = 0, int index = 0,  bool inplace = true}){

  }







  dynamic dot({DDataFrame? df, DFColumn? col, Series? ser}) { // todo make listType so Columns work too | returnTypes are weird maybe
    // check if no arguments ar provided
    if (df == null && col == null && ser == null) {
      throw Exception('No data provided');
    }
    // check if 2 arguments are provided
    if ((df != null && col != null) || df != null && ser != null || col != null && ser != null) {
      throw Exception('Only 2 arguments can be provided');
    }
    if (df != null) {
      return DDataFrame.fromLL(mdot(as_type(int) as List<List<int>>, df.as_type(int) as List<List<int>>));
    }

    if (col != null) {
      return Series(ldata: (mvdot(mat: as_type(int) as List<List<int>>, vec: col.asInt() as List<int>)));
    }

    if (ser != null) {
      return DFColumn<int>('', values: mvdot(mat: as_type(int) as List<List<int>>, vec: ser.asInt()));
    }
  }

  bool hasColumnName(String name) {
    return _data.map((e) => e.name).contains(name);
  }

  DDataFrame copy() {
    return DDataFrame.fromLL(asList());
  }

  DFColumn? getColumn(String name) {
    return _data.firstWhere((element) => element.name == name);
  }

  int getColumnIndex(String name) {
    return _data.indexWhere((element) => element.name == name);
  }

  getColumnByIndex(int index) {
    return _data[index];
  }

  _getRow(int index) {
    return _data.map((e) => e[index]).toList();
  }

  setColumn(String name, DFColumn column) { // todo check length
    int index = getColumnIndex(name);
    _data[index] = column;
  }

  Series? operator [](dynamic index) {
    int? i = indeces[index];
    if (i == null) {
      if (i is int && i < _data[0].length) {
        return _getRow(i);
      }
    }
    else {
      throw Exception('Index not found');
    }
      return null;
  }

  // todo doesnt work
  addColumn({DFColumn? column, String? name, List<dynamic>? data}){
    if (column != null) {
      _data.add(column);
    }
    else {
      if (name == null) {
        throw Exception('Name must be provided when adding a new column to a dataframe');
      }
      else {
        // _data.add(DFNColumn(name=data, data=data));
      }
    }
  }



  Map<String, bool> all() {
    Map<String, bool> res = {};
    for (var col in _data) {
      res[col.name] = col.all();
    }
    return res;
  }

  bool all_bool() => all().values.fold(true, (prev, el) => prev? el? true: false : false);


  Map<String, bool> any() {
    Map<String, bool> res = {};
    for (var col in _data) {
      res[col.name] = col.any();
    }
    return res;
  }

  // TODO don't know what to do with this, could have 2 interpretations
  // does every column have at least one value or does entire DF have at least one value
  bool any_bool() => any().values.fold(true, (prev, el) => prev? el? true: false : false);

  Map<String, int> count() {
    Map<String, int> res = {};
    for (var col in _data) {
      res[col.name] = col.length;
    }
    return res;
  }

  get columnIterator => _DFColumnIteratable(this); // todo no idea if works

  get rowIterator => _DFRowIteratable(this); // todo no idea if works

  // get nodeIterator todo

}


class _DFColumnIteratable extends Iterable<DFColumn> {
  final DDataFrame df;

  _DFColumnIteratable(this.df);

  @override
  Iterator<DFColumn> get iterator => _DFColumnIterator(df);
}


class _DFColumnIterator implements Iterator<DFColumn> {
  final DDataFrame df; // are Pointers an idea ??
  int _index = -1;

  _DFColumnIterator(this.df);

  @override
  DFColumn get current => df.getColumnByIndex(_index);

  @override
  bool moveNext() {
    if (_index < df.shape[1] - 1) {
      _index++;
      return true;
    }
    return false;
  }

}


class _DFRowIteratable extends Iterable<Series> {
  final DDataFrame df;

  _DFRowIteratable(this.df);

  @override
  Iterator<Series> get iterator => _DFRowIterator(df);
}


class _DFRowIterator implements Iterator<Series> {
  final DDataFrame df; // are Pointers an idea ??
  int _index = -1;

  _DFRowIterator(this.df);

  @override
  Series get current => df._getRow(_index);

  @override
  bool moveNext() {
    if (_index < df.shape[1] - 1) {
      _index++;
      return true;
    }
    return false;
  }

}

















