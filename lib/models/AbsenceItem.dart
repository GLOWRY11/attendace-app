class AbsenceItem {
  final int id;
  final int studentId;
  final bool isPresent;
  final DateTime date;
  final String startTime;
  final String endTime;

  AbsenceItem({
    required this.id,
    required this.studentId,
    required this.isPresent,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
}
