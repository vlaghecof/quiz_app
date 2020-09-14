import 'package:Quiz_App/Quiz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Quiz quiz;
  List<Results> results;

  Function callback;

  void change() {
    setState(() {
      print("reload");
    });
  }

  Future<void> fetchQuestions() async {
    var res = await http.get("https://opentdb.com/api.php?amount=20");
    print(res.toString());
    var decodedResponse = jsonDecode(res.body);
    print(decodedResponse);
    quiz = Quiz.fromJson(decodedResponse);
    results = quiz.results;
  }

  ListView QuestionList() {
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) => Card(
              color: Colors.white,
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Text(results[index].type[0].toUpperCase()),
                ),
                children: results[index].allAnswers.map((m) {
                  return AnswearWidget(results, index, m, quiz);
                }).toList(),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      results[index].question,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FilterChip(
                            backgroundColor: Colors.grey[100],
                            label: Text(results[index].category),
                            onSelected: (b) {},
                          ),
                          FilterChip(
                            backgroundColor: Colors.grey[100],
                            label: Text(results[index].difficulty),
                            onSelected: (b) {},
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Score(quiz, change),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: fetchQuestions,
        child: FutureBuilder(
          future: fetchQuestions(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text("Press buttotn to start");
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                if (snapshot.hasError) return Container(child: Text("error"));
                return QuestionList();
            }
          },
        ),
      ),
    );
  }
}

class AnswearWidget extends StatefulWidget {
  final List<Results> results;
  final int index;
  final String m;
  final Quiz quiz;

  AnswearWidget(
    this.results,
    this.index,
    this.m,
    this.quiz,
  );

  @override
  _AnswearWidgetState createState() => _AnswearWidgetState();
}

class _AnswearWidgetState extends State<AnswearWidget> {
  Color color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          if (widget.m == widget.results[widget.index].correctAnswer) {
            color = Colors.green;
            widget.quiz.score += 10;
            print(widget.quiz.score);
          } else {
            color = Colors.red;
            widget.quiz.score -= 10;
            print(widget.quiz.score);
          }
        });
      },
      title: Text(
        widget.m,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Score extends StatefulWidget {
  final Quiz quiz;

  final Function refresh;

  Score(this.quiz, this.refresh);

  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  int score = 0;

  void showScore() {
    print("function called");
    widget.refresh();
    setState(() {
      score = widget.quiz.score;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Quiz App",
          style: TextStyle(fontSize: 20),
        ),
        IconButton(
          onPressed: showScore,
          tooltip: "Refresh page",
          icon: Icon(
            Icons.autorenew,
          ),
        ),
        Text("Previous Score : "),
        Text(widget.quiz.score.toString()),
      ],
    );
  }
}