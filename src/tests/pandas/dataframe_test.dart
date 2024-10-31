import 'package:test/test.dart';

import '../../pandas/new_dataframe/DFColumn.dart';
import '../../pandas/new_dataframe/DataFrame.dart';



void main() {
  group("Integer Dataframe Tests:", () {
    var df = DataFrame.from_csv("src/tests/pandas/RandomIntegers.csv");
    test("shape", () {
      expect(df.shape, [6,5]); // I dont like it, but thats how pandas does it
    });
    test("size", () {
      expect(df.size, 30);
    });
    test("columns", () {
      expect(df.columns, ['Column_1', 'Column_2', 'Column_3', 'Column_4', 'Column_5']);
    });
    test("all", () {
      expect(df.all(), {'Column_1': true, 'Column_2': true, 'Column_3': true, 'Column_4': true, 'Column_5': true});
    });
    test("any", () {
      expect(df.anyNotNull(), {'Column_1': true, 'Column_2': true, 'Column_3': true, 'Column_4': true, 'Column_5': true});
    });
    test("count", () {
      expect(df.count(), {'Column_1': 6, 'Column_2': 6, 'Column_3': 6, 'Column_4': 6, 'Column_5': 6});
    });
  });
  group("RandomIntegersMixed Column Tests:",() {
    var df = DataFrame.from_csv("src/tests/pandas/RandomIntegersMixed.csv", columnTypes: [String, String, dynamic, String, int]);
    DFColumn col5 = df["Column_5"];
    DFColumn col2 = df["Column_2"];
    DFColumn col3 = df["Column_3"];
    DFColumn col1 = df["Column_1"];
    // test("ColumnType Int", () {
    //   expect(col5.valueType, int);
    // });
    // test("ColumnType String", () {
    //   expect(col2.valueType, String);
    // });
    test("Column length", () {
      expect(col5.length, 6);
    });
    test("Column values", () {
      expect(col5, [-100, -35, 73, -44, -97, 36]);
    });
    test("Column as string", () {
      expect(col5.asString(), ["-100", "-35", "73", "-44", "-97", "36"]);
    });
    test("Mixed column any", () {
      expect(col3.anyNotNull(), true);
    });
    test("Mixed column all", () {
      expect(col3.all(), false);
    });
    test("Mixed column empty any", () {
      expect(col1.anyNotNull(), false);
    });
    test("Mixed column all", () {
      expect(col1.all(), false);
    });
    test("Mixed column full all", (){
      expect(col5.all(), true);
    });
    test("empty column length", () {
      expect(col1.length, 6);
    });
    test("empty column values", () {
      expect(col1, [null, null, null, null, null, null]);
    });
    test("dynamic values", (){
      expect(col3, ["PEkyw", 22.283637255811087, null, "ZIaOY", 25, null]);
    });
    DFColumn col3_e = col3.copy()..fillna(69);
    test("copy + fillna", () {
      expect(col3_e, ["PEkyw", 22.283637255811087, 69, "ZIaOY", 25, 69]);
    });
  });
  group("RandomIntegersMixed Dataframe Tests", (){
    var df = DataFrame.from_csv("src/tests/pandas/RandomIntegersMixed.csv");
    test("any", () {
      expect(df.anyNotNull(), {'Column_1': false, 'Column_2': true, 'Column_3': true, 'Column_4': true, 'Column_5': true});
    });
    test("all", () {
      expect(df.all(), {'Column_1': false, 'Column_2': true, 'Column_3': false, 'Column_4': true, 'Column_5': true});
    });
  });
}
