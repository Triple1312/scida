

import 'dart:collection';
import 'dart:io';

import '../../numdart/data/NDSparce.dart';
import '../series/series.dart';
import 'DDataFrame.dart';
import 'DataFrame.dart';

class RelationalDataFrame extends DataFrame {

  late List<String> columnNames;

  late HashMap<String, int> rowNames;

  late SparceBinMatrix data;

  // a dataframe does need to have every column named, row names are optional
  RelationalDataFrame.from_csv(String path, {String sep=",", List<String> columnNames = const [], List<String> rowNames = const [], String lineSeperator = '\n'}) {
    var file = File(path).readAsStringSync();
    List<String> lines = file.split(lineSeperator);

    // set column names if not provided
    if (columnNames.isEmpty) {
      this.columnNames = lines[0].split(sep);
    }
    else {
      this.columnNames = columnNames;
    }

    // setRowNames if not provided
    for (int i = 0; i < rowNames.length; i++) {
      rowNames[i] = rowNames[i];
    }
  }

  @override
  addColumn({DFColumn? column, String? name, List? data}) {
    if (column != null) {
      columnNames.add(column.name);
      this.data.addColumnBool(column.asBool());
    }
    if (name != null && data != null) {
      columnNames.add(name);
      this.data.addColumnBool(data);
    }
  }

  @override
  List<List<bool?>> asBool() {
    // TODO: implement asBool
    throw UnimplementedError();
  }

  @override
  List<List<double?>> asDouble() {
    // TODO: implement asDouble
    throw UnimplementedError();
  }

  @override
  List<List<int?>> asInt() {
    // TODO: implement asInt
    throw UnimplementedError();
  }

  @override
  List<List> asList() {
    // TODO: implement asList
    throw UnimplementedError();
  }

  @override
  List<List<String>> asString() {
    // TODO: implement asString
    throw UnimplementedError();
  }

  @override
  List<List> as_type(Type type) {
    // TODO: implement as_type
    throw UnimplementedError();
  }

  @override
  // TODO: implement columns
  get columns => throw UnimplementedError();

  @override
  DataFrame copy() {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  dot({DataFrame? df, DFColumn? col, Series? ser}) {
    // TODO: implement dot
    throw UnimplementedError();
  }

  @override
  drop({List<int>? labels, int axis = 0, int index = 0, bool inplace = true}) {
    // TODO: implement drop
    throw UnimplementedError();
  }

  @override
  DFColumn? getColumn(String name) {
    int index = getColumnIndex(name);
    // TODO: implement getColumn
    throw UnimplementedError();
  }

  @override
  getColumnByIndex(int index) {
    // TODO: implement getColumnByIndex
    throw UnimplementedError();
  }

  @override
  int getColumnIndex(String name) {
    for (int i = 0; i < columnNames.length; i++) {
      if (columnNames[i] == name) {
        return i;
      }
    }
    return -1;
  }

  @override
  bool hasColumnName(String name) {
    return columnNames.contains(name);
  }

  @override
  insert({required int loc, required DFColumn column}) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  // TODO: implement lenght
  get lenght => throw UnimplementedError();

  @override
  setColumn(String name, DFColumn column) {
    // TODO: implement setColumn
    throw UnimplementedError();
  }

  @override
  // TODO: implement shape
  get shape => throw UnimplementedError();

  @override
  // TODO: implement size
  get size => throw UnimplementedError();

  @override
  DataFrame transpose() {
    // TODO: implement transpose
    throw UnimplementedError();
  }

  @override
  // TODO: implement valueType
  get valueType => throw UnimplementedError();

  @override
  List<List<bool>> asBoolZ() {
    // TODO: implement asBoolZ
    throw UnimplementedError();
  }
}