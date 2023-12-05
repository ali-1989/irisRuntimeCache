import 'package:iris_runtime_cache/src/runtime_scope.dart';

class RuntimeKv<K,V> {
  late RuntimeScope scope;
  late K key;
  V? _value;
  DateTime? lastUpdate;
  Duration? updateDuration;

  RuntimeKv(this.scope, this.key);

  RuntimeKv.fill(this.scope, this.key, V value, {this.lastUpdate, this.updateDuration}) : _value = value {
    lastUpdate = DateTime.now();
  }

  set value(V? value){
    _value = value;
    lastUpdate = DateTime.now();
  }

  V? get value => _value;

  bool isUpdateFrom(Duration duration){
    return lastUpdate != null && lastUpdate!.add(duration).isAfter(DateTime.now());
  }

  bool isUpdate(){
    if(updateDuration == null){
      return false;
    }

    return lastUpdate != null && lastUpdate!.add(updateDuration!).isAfter(DateTime.now());
  }

  void resetUpdateTime(){
    lastUpdate = null;
  }

  void changeUpdateTime(DateTime dt){
    lastUpdate = dt;
  }

  void longTimeKeepUpdate(){
    lastUpdate = DateTime.now().add(const Duration(days: 100));
  }
}