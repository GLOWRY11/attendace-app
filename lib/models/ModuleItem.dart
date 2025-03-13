
class ModuleItem {
  int moduleId;
  String moduleName;

  ModuleItem({
    required this.moduleId,
    required this.moduleName,
  });

  int get getModuleId => moduleId;
  String get getModuleName => moduleName;

  set setModuleId(int id) => moduleId = id;
  set setModuleName(String name) => moduleName = name;

}