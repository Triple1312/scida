
class Series {
  List<dynamic> _data = [];
  String? name;
  List<dynamic> indeces = []; // todo could reorder for faster reaccess

  // todo why index ?
  Series({Map<dynamic, dynamic>? data, this.name, List<dynamic>? index, List<dynamic>? ldata}) {
    assert(data != null && ldata != null, 'Both mapdata and listdata provided, only one can be provided');
    if (data != null) {
      _data = data.values.toList();
      indeces = data.keys.toList();
    }
    else {
      _data = ldata != null? ldata.map((e) => e).toList() : [];
    }
  }

  isEmpty() => _data.isEmpty;

  List<int> asInt() => _data.map((e) => e as int).toList();




}