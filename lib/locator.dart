import 'package:get_it/get_it.dart';
import 'package:time_scheduler/models/crud_model.dart';
import 'package:time_scheduler/services/api.dart';

GetIt locator = GetIt.instance;

void setupLocator(String id){
  locator.registerLazySingleton(() => Api('alarms', id));
  locator.registerLazySingleton(() => CRUDModel());
}

