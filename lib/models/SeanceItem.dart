class SeanceItem {
  int cid;
  String moduleName;
  String elementName;
  String subjectName;
  int? enseignantId;
  SeanceItem({
    required this.cid,
    required this.moduleName,
    required this.elementName,
    required this.subjectName,
    required this.enseignantId,
  });

  // Getters
  int get getCID => cid;
  String get getClassName => moduleName;
  String get getElementName => elementName;
  String get getSubjectName => subjectName;

  // Setters
  set setClassName(String name) => moduleName = name;
  set setSubjectName(String name) => subjectName = name;
    set setElementName(String name) => elementName = name;
    set setCID(int id) => cid = id;
}
