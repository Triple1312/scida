
part of 'DataFrame.dart';


abstract class DFNode {
  String asString();
  int asInt();
  double asDouble(); //
  bool asBool(); // todo: implement strict mode
}

class DFSNode extends DFNode {
  String value;

  DFSNode(this.value);

  @override
  bool asBool() => value != 'false' && value != '0' && value != '' && value != 'null' && value != 'False';

  @override
  double asDouble() {
    var dub = double.tryParse(value);
    if (dub == null) {
      return 0.0;
    }
    return dub;
  }

  @override
  int asInt() {
    var dub = int.tryParse(value);
    if (dub == null) {
      return 0;
    }
    return dub;
  }

  @override
  String asString() => value;
}

class DFINode extends DFNode {
  int value;

  @override
  bool asBool() => value != 0;

  DFINode(this.value);

  @override
  double asDouble() => value.toDouble();

  @override
  int asInt() => value;

  @override
  String asString() => value.toString();

}

class DFFNode extends DFNode {
  double value;

  bool asBool() => value != 0;

  @override
  double asDouble() => value;

  @override
  int asInt() => value.toInt();

  @override
  String asString() => value.toString();


  DFFNode(this.value);
}

class DFBNode extends DFNode {
  bool value;

  @override
  bool asBool() => value;

  @override
  double asDouble() => value ? 1.0 : 0.0;

  @override
  int asInt() => value ? 1 : 0;

  @override
  String asString() => value.toString();

  DFBNode(this.value);
}

class DFNNode extends DFNode {
  get value => null;

  @override
  bool asBool() => value;

  @override
  double asDouble() => value ? 1.0 : 0.0;

  @override
  int asInt() => value ? 1 : 0;

  @override
  String asString() => value.toString();

  DFBNode(){}
}