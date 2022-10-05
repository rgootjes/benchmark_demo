import 'package:flutter/material.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({Key? key}) : super(key: key);

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
        width: 800,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Question 1"),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: InputDecoration(hintText: "Question 1"),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Question 2"),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: InputDecoration(hintText: "Question 2"),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Question 3"),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: InputDecoration(hintText: "Question 3"),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 28.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/summary');
                },
                color: Colors.green,
                child: const SizedBox(
                  height: 60,
                  width: 400,
                  child: Center(child: Text("Continue")),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
