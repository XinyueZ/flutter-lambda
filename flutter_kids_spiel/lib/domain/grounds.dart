import 'ground.dart';

class Grounds {
  final List<Ground> data = List<Ground>();

  @override
  String toString() {
    final StringBuffer stringBuffer = StringBuffer();
    data.forEach((ground) {
      stringBuffer.writeln(ground.toString());
    });
    final ret = stringBuffer.toString();
    stringBuffer.clear();
    return ret;
  }
}
