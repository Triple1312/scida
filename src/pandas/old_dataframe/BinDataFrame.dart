

import '../../numdart/data/NDSparce.dart';
import '../series/series.dart';
import 'DDataFrame.dart';
import 'DataFrame.dart';

class BinDataFrame extends DataFrame {

  SparceBinMatrix data;

  BinDataFrame.from_csv() {

  }

  @override
  addColumn({DFColumn? column, String? name, List? data}) {
    // TODO: implement addColumn
    throw UnimplementedError();
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
    // TODO: implement getColumnIndex
    throw UnimplementedError();
  }

  @override
  bool hasColumnName(String name) {
    // TODO: implement hasColumnName
    throw UnimplementedError();
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

}