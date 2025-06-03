import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/home_rank.dart';
import 'package:frontend/models/player.dart';
import 'data/data.dart';
import 'lobby.dart';
import 'models/player.dart';
import 'home.dart';
import 'layout.dart';

class PvPMatchScreen extends StatefulWidget {
  final Player player1;
  final Player player2;

  const PvPMatchScreen({Key? key, required this.player1, required this.player2})
    : super(key: key);

  @override
  _PvPMatchScreenState createState() => _PvPMatchScreenState();
}

class _PvPMatchScreenState extends State<PvPMatchScreen> {
  int currentQuestion = 0;
  final int totalQuestions = 15;
  bool usedFiftyFifty = false;
  bool usedChangeQuestion = false;
  int player1Point = 0;
  int player2Point = 0;
  int questionID = 0;
  List<int> shownAnswers = [0, 1, 2, 3];
  int timeLeft = 15;
  Timer? timer;

  List<Map<String, dynamic>>? topic;

  @override
  void initState() {
    super.initState();
    selectTopics().then((_) {
      startTimer();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> selectTopics() async {
    final random = Random();
    int n = random.nextInt(allTopics.length);
    setState(() {
      topic = allTopics[n];
    });
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          nextQuestion();
          timeLeft = 15;
        }
      });
    });
  }

  void nextQuestion({bool correct = false, bool changeQuestion = false}) {
    if (correct) {
      int point = 0;
      if (timeLeft > 10) {
        point = 10;
      } else if (timeLeft > 5) {
        point = 5;
      } else if (timeLeft > 0) {
        point = 1;
      }
      if (currentUser == widget.player2) {
        player1Point += point;
      } else {
        player2Point += point;
      }
    }

    setState(() {
      if (!changeQuestion) currentQuestion++;
      questionID = currentQuestion;
      shownAnswers = [0, 1, 2, 3];
    });

    if (currentQuestion >= totalQuestions) {
      timer?.cancel();
      showDialog(context: context, barrierDismissible: false, builder: (context) => rewardPopup(context));
    } else {
      startTimer();
    }
  }

  void applyFiftyFifty() {
    if (usedFiftyFifty || topic == null) return;
    setState(() {
      usedFiftyFifty = true;
      final correct = topic![questionID]['correctAnswer'];
      shownAnswers =
          shownAnswers
              .where(
                (i) =>
                    topic![questionID]['options'][i] == correct ||
                    shownAnswers.indexOf(i) < 2,
              )
              .toList();
    });
  }

  void changeQuestion() {
    if (usedChangeQuestion ||
        topic == null ||
        currentQuestion >= totalQuestions)
      return;
    setState(() {
      usedChangeQuestion = true;
      currentQuestion++;
      questionID = currentQuestion;
      shownAnswers = [0, 1, 2, 3];
      timeLeft = 15;
    });
    startTimer();
  }

  Widget rewardPopup(BuildContext context) {
    int rankDelta = widget.player1.elo - widget.player2.elo;
    rankDelta = rankDelta.abs();
    rankDelta = (rankDelta / 5).round();
    final String rankDeltaText =
        (rankDelta >= 0 ? '+' : '-') + rankDelta.toString();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Builder(
        builder:
            (dialogContext) => Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.orange[100],
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFE082),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Phần thưởng',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[800],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        color: const Color(0xFF263238),
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 24,
                        ),
                        child: Column(
                          children: [
                            _rewardRow('Xếp hạng', rankDeltaText),
                            const SizedBox(height: 12),
                            _rewardRow('EXP', '+500'),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        color: const Color(0xFFFFE082),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '+1',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.bolt,
                                color: Colors.orangeAccent,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -24,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder:
                                  (context) => MainPageLayout()
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 6),
                            ],
                          ),
                          child: const Icon(
                            Icons.home,
                            size: 28,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder:
                                  (context) => MainPageLayout()
                            ),
                            (Route<dynamic> route) => false,
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                resetToMain: false,
                              ),
                            ),
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LobbyScreen(autoCreate: false,
                            ),
                            )
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 6),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/logo_2.png',
                            width: 28,
                            height: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _rewardRow(String title, String value) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building PvPMatchScreen'); // Debug log
    if (topic == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Màn hình thi đấu'),
        backgroundColor: Colors.grey[200],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _playerCard(
                  avatar: widget.player1.avatarUrl,
                  name: widget.player1.name,
                  rank: widget.player1.elo.toString(), //should be rank here
                  point: player1Point,
                  rankPoint: widget.player1.elo,
                  isCurrentPlayer: currentUser == widget.player1,
                ),
                Text(
                  'Xếp Hạng',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                _playerCard(
                  avatar: widget.player2.avatarUrl,
                  name: widget.player2.name,
                  rank: widget.player2.elo.toString(),
                  point: player2Point,  
                  rankPoint: widget.player2.elo,
                  isCurrentPlayer: currentUser == widget.player2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${currentQuestion + 1}/$totalQuestions',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Đến Lượt Bạn!',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey, width: 3),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Text(
                      'Câu hỏi số ${currentQuestion + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      topic![questionID]['question'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.blueGrey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Chỉ giữ 2 nút trợ giúp: 50/50 và Đổi câu hỏi
                Row(
                  children: [
                    _iconButton(
                      onPressed: applyFiftyFifty,
                      iconWidget: Image.asset(
                        'assets/images/5050.png',
                        width: 28,
                        height: 28,
                      ),
                      disabled: usedFiftyFifty,
                      tooltip: 'Loại bỏ 2 đáp án sai',
                    ),
                    const SizedBox(width: 12),
                    _iconButton(
                      onPressed: changeQuestion,
                      iconWidget: Image.asset(
                        'assets/images/refresh.png',
                        width: 28,
                        height: 28,
                      ),
                      disabled: usedChangeQuestion,
                      tooltip: 'Đổi sang câu hỏi khác',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '$timeLeft',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.timer, color: Colors.blue, size: 24),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children:
                  shownAnswers.map((i) {
                    final option = topic![questionID]['options'][i];
                    return ElevatedButton(
                      onPressed: () {
                        final isCorrect =
                            option == topic![questionID]['correctAnswer'];
                        timer?.cancel();
                        nextQuestion(correct: isCorrect);
                        setState(() {
                          timeLeft = 15;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade800,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        option.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _playerCard({
    required String avatar,
    required String name,
    required String rank,
    required int point,
    required int rankPoint,
    bool isCurrentPlayer = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: isCurrentPlayer ? Colors.orange : Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 28, backgroundImage: AssetImage(avatar)),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            rank,
            style: TextStyle(
              color:
                  rankPoint > 2000
                      ? Colors.purple
                      : rankPoint > 1000
                      ? Colors.blue
                      : rankPoint > 0
                      ? Colors.green
                      : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$point',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton({
    required VoidCallback onPressed,
    required Widget iconWidget,
    required bool disabled,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        decoration: BoxDecoration(
          color:
              disabled ? Colors.grey : const Color.fromARGB(255, 255, 255, 255),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: disabled ? null : onPressed,
          icon: Opacity(opacity: disabled ? 0.5 : 1.0, child: iconWidget),
          padding: const EdgeInsets.all(8),
          splashRadius: 24,
        ),
      ),
    );
  }
}
