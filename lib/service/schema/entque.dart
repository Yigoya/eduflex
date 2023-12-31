class Entque {
  int id;
  String question;
  String a;
  String b;
  String c;
  String d;
  String answer;
  String explain;
  String subject;
  int year;
  int unit;

  Entque({
    required this.id,
    required this.question,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.answer,
    required this.explain,
    required this.subject,
    required this.year,
    required this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'a': a,
      'b': b,
      'c': c,
      'd': d,
      'answer': answer,
      'explain': explain,
      'subject': subject,
      'year': year,
      'unit': unit
    };
  }

  factory Entque.fromMap(Map<String, dynamic> map) {
    return Entque(
        id: map['id'],
        question: map['question'],
        a: map['a'],
        b: map['b'],
        c: map['c'],
        d: map['d'],
        answer: map['answer'],
        explain: map['explain'],
        subject: map['subject'],
        year: map['year'],
        unit: map['unit']);
  }
}
