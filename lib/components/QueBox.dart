import 'package:flutter/material.dart';

class QueBox extends StatefulWidget {
  final int index;
  final void Function(int key, String value) answer;
  final Map<String, dynamic> ques;
  const QueBox(
      {super.key,
      required this.ques,
      required this.index,
      required this.answer});

  @override
  State<QueBox> createState() => _QueBoxState();
}

enum SingingCharacter { a, b, c, d }

class _QueBoxState extends State<QueBox> {
  SingingCharacter? _character;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).primaryColorLight),
        child: Column(
          children: [
            Text(
              '${widget.index}. ${widget.ques['question']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).canvasColor),
              child: Column(
                children: [
                  Row(children: [
                    Radio<SingingCharacter>(
                      value: SingingCharacter.a,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        print(value!.name);
                        widget.answer(widget.index, value!.name);
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                    Text('${widget.ques['a']}'),
                  ]),
                  Row(children: [
                    Radio<SingingCharacter>(
                      value: SingingCharacter.b,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        print(value!.name);
                        widget.answer(widget.index, value!.name);
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                    Text('${widget.ques['b']}'),
                  ]),
                  Row(children: [
                    Radio<SingingCharacter>(
                      value: SingingCharacter.c,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        print(value!.name);
                        widget.answer(widget.index, value!.name);
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                    Text('${widget.ques['c']}'),
                  ]),
                  Row(children: [
                    Radio<SingingCharacter>(
                      value: SingingCharacter.d,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        print(value!.name);
                        widget.answer(widget.index, value!.name);
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                    Text('${widget.ques['d']}'),
                  ]),
                ],
              ),
            )
          ],
        ));
  }
}
