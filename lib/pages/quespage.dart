import 'package:eduflex/components/QueBox.dart';
import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:flutter/material.dart';

class QuePage extends StatefulWidget {
  final String subject;
  final List<Map<String, dynamic>> ques;
  const QuePage({super.key, required this.subject, required this.ques});

  @override
  State<QuePage> createState() => _QuePageState();
}

enum SingingCharacter { a, b, c, d }

class _QuePageState extends State<QuePage> {
  SingingCharacter? _character = SingingCharacter.a;
  Map<int, String> answer = {};
  void addAnswer(int key, String value) {
    print('${key} ${value}');
    answer[key] = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Matrix"),
        centerTitle: true,
        actions: [profilepic()],
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: widget.ques.length,
                itemBuilder: (context, index) {
                  return QueBox(
                    answer: addAnswer,
                    ques: widget.ques[index],
                    index: index + 1,
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
          onPressed: () {
            popForm(context);
          },
          child: Text("answers")),
    );
  }

  void popForm(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              child: Column(
                children: [
                  Text("Answers for the question"),
                  Expanded(
                    child: ListView.builder(
                        itemCount: widget.ques.length,
                        itemBuilder: (context, index) {
                          return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black87)),
                              child: Column(
                                children: [
                                  Text(widget.ques[index]['question']),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: answer[index + 1] !=
                                                    widget.ques[index]['answer']
                                                ? Colors.red
                                                : Colors.green),
                                        child: Text(
                                          'Your choice: ${answer[index + 1]}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Container(
                                        decoration:
                                            BoxDecoration(color: Colors.green),
                                        child: Text(
                                          'Answer: (${widget.ques[index]['answer']}) ${widget.ques[index][widget.ques[index]['answer']]}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(widget.ques[index]['explain'])
                                ],
                              ));
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
