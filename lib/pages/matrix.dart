import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/pages/quespage.dart';
import 'package:eduflex/provider.dart';
import 'package:eduflex/service/dbservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Matrix extends StatefulWidget {
  const Matrix({super.key});

  @override
  State<Matrix> createState() => _MatrixState();
}

class _MatrixState extends State<Matrix> {
  DBservice dBservice = DBservice.instance;
  List<Map<String, dynamic>> _ques = [];
  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    await MyProvider.loadMatrix();
    List<Map<String, dynamic>> ques = await dBservice.fetchQue();
    print(ques);
    setState(() {
      _ques = ques;
    });
  }

  List<String> list = ['By chapter', 'By order'];
  String? dropdownValue = 'By order';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Matrix"),
        centerTitle: true,
        actions: [profilepic()],
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              children: [
                subject(
                  "Biology",
                  "assets/image/biology.jpg",
                ),
                subject("Maths", "assets/image/maths.jpg"),
                subject("English", "assets/image/english.jpg"),
                subject("Physics", "assets/image/physics.jpg"),
                subject("Chemistry", "assets/image/chemistry.jpg"),
                subject("Civics", "assets/image/civics.jpg"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget subject(String text, String image) {
    return GestureDetector(
      onTap: () async {
        List<Map<String, dynamic>> res =
            await dBservice.fetchBySub(text.toLowerCase());
        print(res);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuePage(subject: text, ques: res)));
        // MyProvider.loadMatrix();
      },
      child: Container(
        child: Column(
          children: [
            Text(text),
            SizedBox(width: 180, child: Image.asset(image))
          ],
        ),
      ),
    );
  }
}
