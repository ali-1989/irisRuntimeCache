import 'package:iris_runtime_cache/src/runtime_kv.dart';
import 'package:iris_runtime_cache/src/runtime_scope.dart';

class IrisRuntimeCache {
  static final List<RuntimeKv> _list = [];

  IrisRuntimeCache._();

  static bool store(RuntimeKv kv){
    if(find(kv.scope, kv.key) == null) {
      _list.add(kv);
      return true;
    }

    return false;
  }

  static bool storeWith<K, V>(RuntimeScope scope, K key, V value){
    final rt = RuntimeKv<K, V>(scope, key);
    rt.value = value;

    return store(rt);
  }

  static bool storeOrUpdate<K, V>(RuntimeScope scope, K key, V value, {Duration? updateDuration}){
    RuntimeKv? rt;

    rt = find(scope, key);

    if(rt != null){
      rt.value = value;
      return true;
    }

    rt = RuntimeKv<K, V>(scope, key);
    rt.value = value;
    rt.updateDuration = updateDuration;

    return store(rt);
  }

  static RuntimeKv? find(RuntimeScope scope, dynamic key){
    for(final itm in _list){
      if(itm.scope == scope && itm.key == key){
        return itm;
      }
    }

    return null;
  }

  static void remove(RuntimeKv kv){
    _list.removeWhere((element) {
      return element.scope == kv.scope && element.key == kv.key;
    });
  }

  static void removeBy(RuntimeScope scope, dynamic key){
    _list.removeWhere((element) {
      return element.scope == scope && element.key == key;
    });
  }

  static bool isUpdate(RuntimeScope scope, dynamic key, {Duration? duration, bool defaultResult = false}){
    final kv = find(scope, key);

    if(kv != null){
      if(duration != null){
        return kv.isUpdateFrom(duration);
      }

      return kv.isUpdate();
    }

    return defaultResult;
  }

  static void resetUpdateTime(RuntimeScope scope, dynamic key){
    final kv = find(scope, key);

    if(kv != null){
      kv.resetUpdateTime();
    }
  }
}