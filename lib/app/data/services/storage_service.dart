import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late final GetStorage _box;

  Future<StorageService> init() async {
    _box = GetStorage();
    await _box.initStorage;
    return this;
  }

  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  void write(String key, dynamic value) async {
    await _box.write(key, value);
  }
}
