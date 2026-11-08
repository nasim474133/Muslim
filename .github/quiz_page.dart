import 'package:flutter/material.dart';

import '../data/quiz_data.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _i = 0;
  int _score = 0;
  int? _picked;

  void _next() {
    setState(() {
      _i++;
      _picked = null;
    });
  }

  void _restart() {
    setState(() {
      _i = 0;
      _score = 0;
      _picked = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final done = _i >= quizQuestions.length;
    return Scaffold(
      appBar: AppBar(title: const Text('ইসলামিক কুইজ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: done
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('আপনার স্কোর: $_score / ${quizQuestions.length}',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    FilledButton(
                        onPressed: _restart, child: const Text('আবার খেলুন')),
                  ],
                ),
              )
            : _question(context),
      ),
    );
  }

  Widget _question(BuildContext context) {
    final q = quizQuestions[_i];
    return ListView(
      children: [
        Text('প্রশ্ন ${_i + 1} / ${quizQuestions.length}',
            style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Text(q.$1, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        for (var k = 0; k < q.$2.length; k++)
          Card(
            color: _picked == null
                ? null
                : k == q.$3
                    ? Colors.green.shade100
                    : k == _picked
                        ? Colors.red.shade100
                        : null,
            child: ListTile(
              title: Text(q.$2[k]),
              onTap: _picked != null
                  ? null
                  : () => setState(() {
                        _picked = k;
                        if (k == q.$3) _score++;
                      }),
            ),
          ),
        if (_picked != null)
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: _next,
              child: Text(_i == quizQuestions.length - 1 ? 'ফলাফল' : 'পরবর্তী'),
            ),
          ),
      ],
    );
  }
}
