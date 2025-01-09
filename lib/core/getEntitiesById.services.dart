import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:godeliveryapp_naranja/core/dataID.services.dart';

Future<List<T>> getEntitiesByIds<T>(
  List<String> ids,
  String endpoint,
  T Function(Map<String, dynamic>) fromJson,
) async {
  if (!await hasInternetConnection()) {
    throw 'No tienes conexión a internet';
  }

  List<T> entityList = [];
  for (var id in ids) {
    T entity = await fetchEntityById<T>(id, endpoint, fromJson);
    entityList.add(entity);
  }
  return entityList;
}

  Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
