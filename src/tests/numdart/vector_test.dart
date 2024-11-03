


import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../numdart/new_data/Vector.dart';

void main() {
  group("normal vector", () {
    Vector v = Vector([1, 2, 3, 4, 5]);
    test("sum", () {
      expect(v.sum, 15);
    });
    test("product", () {
      expect(v.product, 120);
    });
    test("operator *", () {
      expect((v * 2).sum, 30);
    });
    test("operator /", () {
      expect((v / 2).sum, 7.5);
    });
    test("norm2", () {
      expect(v.norm(2), 7.416198487095663);
    });
    test("mean", () {
      expect(v.mean, 3);
    });
    test("median", () {
      expect(v.median, 3);
      v.add(6);
      expect(v.median, 3.5);
    });
  });
  group("vector interactions", () {
    Vector v = Vector([1, 2, 3, 4, 5]);
    Vector v2 = Vector([2, 5, 8, 4, 1]);
    test("dot", () {
      expect(v.dot(v2), 57);
    });
    test("proj", () {
      expect(v.proj(v2).sum, 10.363636363636363);
    });
    test("minusVector", () {
      expect(v.minusVector(v2).sum, -5);
    });
    test("plusVector", () {
      expect(v.plusVector(v2).sum, 35);
    });


  });
  group("Sparce vector tests", () {
    SparceVector v = SparceVector([1, 0, 0, 0, 5, 0, 8]);
    test("length", () {
      expect(v.length, 7);
    });
    test("sum", () {
      expect(v.sum, 14);
    });
    test("product", () {
      expect(v.product, 0);
    });
    test("operator *", () {
      expect((v * 2).sum, 28);
    });
    test("operator /", () {
      expect((v / 2).sum, 7);
    });
    test("norm2", () {
      expect(v.norm(2), 9.486832980505138);
    });
    List<int> ints = [1, 0, 0, 0, 5, 0, 8];
    for (int i = 0; i < ints.length; i++) {
      test("iterator" + i.toString() , () {
        expect(v[i], ints[i]);
      });
    }
    test("get", () {
      expect(v[0], 1);
      expect(v[3], 0);
      expect(v[6], 8);
      expect(v[4], 5);
      expect(v[5], 0);
    });
    test("set non-zero to non-zero", () {
      v[0] = 3;
      expect(v[0], 3);
      expect(v.sum, 16);
    });
    test("set non-zero to zero", () {
      v[0] = 0;
      expect(v[0], 0);
      expect(v.sum, 13);
    });
    test("set zero to non-zero", () {
      v[3] = 3;
      expect(v[3], 3);
      expect(v.sum, 16);
    });

    Vector v1 = SparceVector([1, 0, 3, 4, 5]);
    Vector v2 = SparceVector([2, 5, 8, 0, 1]);
    test("dot", () {
      expect(v1.dot(v2), 31);
    });
    test("normalize", () {
      expect(v1.normalize(), [
        0.14002800840280097,
        0,
        0.42008402520840293,
        0.5601120336112039,
        0.7001400420140048
      ]);
    });
  });
}