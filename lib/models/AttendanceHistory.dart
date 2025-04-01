class AttendanceHistory {
  final int id;
  final int classId;
  final DateTime date;
  final int presentCount;
  final int absentCount;
  final int filierid;
  final int enseignantid;

  AttendanceHistory({
    required this.id,
    required this.classId,
    required this.date,
    required this.presentCount,
    required this.absentCount,
    required this.filierid,
    required this.enseignantid,
  });
}
