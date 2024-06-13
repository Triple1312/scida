import 'dart:math';

import 'package:meta/meta.dart';

import '../errors/typed.dart';
import 'old/OMatrix.dart';

enum ArrayType {
  int8,
  int16,
  int32,
  int64,
  uint8,
  uint16,
  uint32,
  uint64,
  float,
  double
}


typedef Tensor = NDarray<num>;


class COO<T extends num> {
  late List<num> V;
  late List<List<int>> indices;

  COO({required this.V, required this.indices});

  COO.fromNDarray(NDarray<num> nda) { // todo make more efficient
    this.V = nda.flat;
    indices = new List<List<int>>.generate(nda.ndim, (i) => []);
    for (int i = 0; i < nda.size; i++) {
      List<int> x = nda.flatIndexToIndeces(i);
      for (int j = 0; j < x.length; j++) {
        indices[j].add(x[j]);
      }
    }
  }
}


class NDarray<T extends num> extends Iterable<NDarray<num>>{
  late List<T> _values;
  late List<int> _shape;

  get valueType => T;

  NDarray({required List<dynamic> values}) {
    this._values = _multidim_flat(values);
    this._shape = _get_shape(values);
  }

  NDarray.array({required List<T> values, required List<int> shape}) {
    this._values = values;
    this._shape = shape;
    if (values.length != shape.fold(1, (a, b) => a*b)) {
      throw Exception('Array has the wrong number of elements for the shape given');
    }
  }
  //  a constructor that works if not all dimensions are the same size
  // will use the largest length of any dimension to fill that dimension
  NDarray.fillna({required List<dynamic> values, dynamic value= null}) {

  }

  NDarray.tensor(List<dynamic> values) {
    this._values = _multidim_flat(values);
    this._shape = _get_shape(values);
  }

  NDarray.matrix(List<List<num>> values) {
    this._values = _multidim_flat(values);
    this._shape = _get_shape(values);
  }

  NDarray.zeros(List<int> shape) {
    this._values = List<T>.filled(shape.fold(1, (a, b) => a*b), 0 as T);
    this._shape = shape;
  }

  NDarray.vector(List<T> values) {
    this._values = values;
    this._shape = [values.length];
  }

  @protected
  NDarray.upgrade(NDarray<T> nda) { // todo maybe other name
    this._values = nda._values;
    this._shape = nda._shape;
  }

  NDarray.identity(int size, int dim) {
    values = List<T>.filled(pow(size, dim) as int, 0 as T);
    _shape = List<int>.filled(dim, size);
    for (int i = 0; i < size; i++) {
      var x = new List<int>.generate(dim, (j) => i);
      this[x] = 1 as T;
    }
  }

  get data {
    List<List> splitListInParts(dynamic lst, int parts) {
      List<List> result = [];
      int partLength = lst.length ~/ parts;
      for (var i = 0; i < parts; i++) {
        result.add(lst.sublist(i * partLength, (i + 1) * partLength));
      }
      return result;
    }

    List splitList(List list, List<int> shape) {
      if (shape.length == 1) {
        return list;
      }
      else {
        var lists = splitListInParts(list, shape[0]);
        for (var i = 0; i < lists.length; i++) {
          lists[i] = splitList(lists[i], shape.sublist(1));
        }
        return lists;
      }
    }
    return splitList(_values, _shape);
  }

  List<T> _multidim_flat(List lst) {
    List<T> flat = [];
    getFlat(List list) {
      for (var element in list) {
        if (element is List) {
          getFlat(element);
        } else {
          flat.add(element);
        }
      }
      return flat;
    }
    return getFlat(lst);
  }

  @protected
  set values(List<T> values) => _values = values;

  // List<T> _multidim_flat_fillna() {  todo
  //   List<dynamic> flat = [_NDStart()];
  //   int getFlat(List lst) {
  //     int maxlength = 0;
  //     for (var element in lst) {
  //       dynamic type = element.runtimeType;
  //       if (element is List) {
  //         if (!type is List){throw Exception('list has wrong type dimensions');}
  //         int length = getFlat(element);
  //         if (length > maxlength) {
  //           maxlength = length;
  //         }
  //       } else {
  //         if (type != T) {
  //           throw Exception('list has wrong type elements');
  //         }
  //         flat.add(element);
  //       }
  //     }
  //     if (lst.length == 0) {
  //       flat.add(_NDEmpty());
  //     }
  //     flat.add(_NDSep());
  //     return maxlength;
  //   }
  //   getFlat(data);
  //
  //
  //
  // }

  List<int> _get_shape(List lst) {
    List<int> shape = [];
    getShape(List list) {
      shape.add(list.length);
      if (list[0] is List) {
        getShape(list[0]);
      }
      return shape;
    }
    return getShape(lst);
  }

  List<T> get flat => _values;

  int get depth => _shape.length;

  int get ndim => depth;

  List<int> get shape => _shape;

  int get size => _values.length;

  List<T> get values => _values;

  NDarray get copy => NDarray.array(values: _values.map((e) => e).toList(), shape: _shape);

  void reshape(List<int> dimensions) => _shape = dimensions;

  void fill(T value) => _values.fillRange(0, _values.length, value);

  void fillna(T value) {
    for (int i = 0; i < _values.length; i++) {
      if (_values[i] == null) {
        _values[i] = value;
      }
    }
  }

  num norm(int p) {
    if (ndim == 2) {
      if (p == 1) {
        double max = 0;
        for (int i = 0; 0 < _shape[0]; i++) {
          double x = 0;
          for (int j = 0; j < _shape[1]; j++) {
            x += _values[i*_shape[1] + j].abs();
          }
          if (x > max) {
            max = x;
          }
        }
        return max;
      }


    }
    return pow(_values.fold(0, (a, b) => a + pow(b.abs(), p)), 1 / p);
  }

  // todo test
  List<int> flatIndexToIndeces(int index) {
    List<int> indeces = [];
    for (int i = 0; i < _shape.length; i++) {
      indeces.add(index % _shape[i]);
      index = (index / _shape[i]).floor();
    }
    return indeces;
  }

  // fills all null values with the mean
  // axis can be given to use the mean per axis todo not implemented yet
  void fillnaMean({int axis=0}) {
    if (!(T is int? || T is double?)) {
      throwTypedError('fillnaMean', [int, double], T, 'T');
    }
    List<double> nnull = [];
    for (int i = 0; i < _values.length; i++) {
      if (_values[i] != null) {
        nnull.add(_values[i] as double);
      }
    }
    double mean = nnull.reduce((a, b) => a+b) / nnull.length;
    fillna(mean as T);
  }

  void fillnaMedian({int axis=0}) {
    if (!(T is int? || T is double?)) {
      throwTypedError('fillnaMedian', [int, double], T, 'T');
    }
    List<double> nnull = [];
    for (int i = 0; i < _values.length; i++) {
      if (_values[i] != null) {
        nnull.add(_values[i] as double);
      }
    }
    nnull.sort();
    double median;
    nnull.length % 2 == 0?
      median = (nnull[nnull.length ~/ 2] + nnull[nnull.length ~/ 2 - 1]) / 2
      : median = nnull[nnull.length ~/ 2];
    fillna(median as T);
  }

  List<T> _fFlat() => // todo werkt niet
    new List<int>.generate(_shape.last,(i) => i+1)
      .map((i) => new List<int>.generate(_values.length ~/ _shape.last,(j) => j+1)
                        .map((j) => _values[j*_shape.last + i]).toList()).toList().expand((i) => i).toList();

  List<T> flatten({String order='C'}) {
    switch(order) {
      case 'C':
        return flat;
      case 'F':
        return _fFlat();
      default:
        throw Exception('order must be either "C" or "F" at the moment');
    }
  }
  
  int _translate_index(List<int> indeces) {
    int ind = 0;
    for (int i = 0; i < _shape.length -1; i++) {
      ind += indeces[i] * _shape[i];
    }
    ind += indeces.last;
    return ind;
  }

  T operator [](List<int> indeces) { // todo not tested
    if (indeces.length != _shape.length) {
      throw Exception('Number of indeces must match number of dimensions');
    }
    return _values[_translate_index(indeces)];
  }

  void operator []=(List<int> indeces, T value) { // todo not tested
    if (indeces.length != _shape.length) {
      throw Exception('Number of indeces must match number of dimensions');
    }
    _values[_translate_index(indeces)] = value;
  }

  @override
  Iterator<NDarray<num>> get iterator => NDIterator(this);

}

class NDIterator<E extends NDarray<num>> implements Iterator<E> {
  NDarray<num> nda;
  int index = -1;

  NDIterator(this.nda);

  @override
  E get current => nda.flat[index] as E;

  @override
  bool moveNext() {
    index++;
    return index < nda.size;
  }
}