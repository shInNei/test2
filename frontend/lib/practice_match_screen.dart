import 'dart:async';
import 'dart:math';
import 'data/data.dart';
import 'models/player.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'practice_screen.dart';
import 'services/APICall.dart';
import 'services/auth_service.dart';
import 'constants.dart';
import 'models/category.dart';
import 'models/question.dart';
import 'models/player.dart';
import 'models/playerutils.dart';

class QuizScreen extends StatefulWidget {
  // final int topicID;
  // final List<String> playerIDs;
  final String category;

  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {

  // Phần Reward sẽ chỉnh sửa data trong backend, thêm sau

  bool _isLoading = true;


  late final AnimationController _lottieController;
  bool showAnimation = false;
  bool isCorrectAnswer = false;
  int currentQuestion = 0;
  int score = 0;
  int timeLeft = 15;
  Timer? timer;
  bool usedFiftyFifty = false;
  bool usedChangeQuestion = false;
  List<int> shownAnswers = [0, 1, 2, 3]; // For 50:50 logic
  int maxQuestions = 10;
  int questionID = 0;

  Player? currentPlayer;
  List<Question>? topicQuestions;

  @override
  void initState() {
    super.initState();
    checkSignIn();

    _lottieController = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1), // shorter duration = faster
  );
    initializeGame(widget.category);
    // fetchPlayers();
    // fetchTopics();
  }

  void checkSignIn() async {
        if (!await AuthService.isLoggedIn()) {
      // If not logged in, redirect to login screen
      await AuthService.logout(); // Ensure user is logged out

      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
  }

  Future<void> initializeGame(String category) async {
    try {
      final token = await AuthService.getToken();
      final apiService = ApiService(baseUrl: SERVER_URL, token: token);

      final userData = await apiService.getCurrentUser();

      final questions = await apiService.getQuestions(category: category, total: maxQuestions + 5);

      var correctIndex = questions![questionID].options
        .indexOf(questions![questionID].correctAnswer);

      print(questions[questionID]);

      print('Correct Index: $correctIndex');


      print('User Data: $userData');
      print('Questions: $questions');

      setState(() {
        currentPlayer = userData;
        topicQuestions = questions;
        _isLoading = false;
      });
      startTimer();
    } catch(e) {
      print('Error initializing game: $e');
      // Handle error, maybe show a dialog or a snackbar
    }
  }

  Future<void> updateResult(int exp) async {
    try {
      final token = await AuthService.getToken();
      final apiService = ApiService(baseUrl: SERVER_URL, token: token);

      if (currentPlayer != null) {
        await apiService.updateAfterMatch(
          userId: currentPlayer!.id.toString(),
          eloChange: 0,
          expGain: exp,
          isWin: false, // PracticeMatch do not update elo and win
        );
      }
    } catch (e) {
      print('Error updating result: $e');
      // Handle error, maybe show a dialog or a snackbar
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft == 0) {
        timeLeft = 15;
        nextQuestion();
      } else {
        setState(() => timeLeft--);
      }
    });
  }

  void nextQuestion({bool correct = false, bool changeQuestion = false}) {
    if (correct) score += 10;
      setState(() {
        if (!changeQuestion) {
        currentQuestion++;
        }
        if(questionID < maxQuestions) {questionID++;}
        shownAnswers = [0, 1, 2, 3];
      });
  }

  void applyFiftyFifty() {
    if (usedFiftyFifty) return;
    usedFiftyFifty = true;

    int correctIndex = topicQuestions![questionID]
        .options
        .indexOf(topicQuestions![questionID].correctAnswer);
    print('Correct Index: $correctIndex');

    final rand = Random();
    final wrongIndices = List.generate(4, (i) => i)..remove(correctIndex);
    int randomWrong = wrongIndices[rand.nextInt(wrongIndices.length)];

    setState(() {
      shownAnswers = [correctIndex, randomWrong];
      shownAnswers.shuffle(); // optional, randomize order
    });
  }

  // Future<void> fetchPlayers() async {
  //   setState((){
  //     roomPlayers = players;
  //   });
  // }

  // Future<void> fetchTopics() async {
  //   setState((){
  //    topicQuestions = generalKnowledgeQuestions;
  //   });
  // }

  void changeQuestion() {
    if (usedChangeQuestion) return;
    usedChangeQuestion = true;
    nextQuestion(changeQuestion: true);
  }

  Widget rewardPopup(BuildContext context, int exp, int score) {
  return Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.orange[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFE082),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Text(
                'Phần thưởng',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),

          // Dark center area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            color: const Color(0xFF263238),
            child: Column(
              children: [
                _rewardRow("Tổng Điểm", "$score"),
                const SizedBox(height: 12),
                _rewardRow("EXP", "$exp"),
              ],
            ),
          ),

          // Bottom Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFFFE082),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              // children: [
              //   Text(
              //     "+1",
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.orangeAccent,
              //     ),
              //   ),
              //   SizedBox(width: 4),
              //   Icon(
              //     Icons.flash_on,
              //     color: Colors.orangeAccent,
              //   ),
              // ],
            ),
          ),

          // Action button
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 8),
            child: Center(
              child: GestureDetector(
                onTap: () {Navigator.of(context).pop();
                Navigator.of(context).pop();},
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.home,
                    size: 28,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _rewardRow(String title, String value) {
  return Container(
    width: 160, // Consistent fixed width
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
  void dispose() {
    timer?.cancel();
    _lottieController.dispose();
    super.dispose();
  }


Future<bool> _showExitConfirmation() async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Xác Nhận Thoát',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Bạn có chắc chắn muốn thoát không?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Hủy bỏ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Có',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ) ??
      false;
}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
            strokeWidth: 2,
          ),
        ),
      );
    }
    return PopScope(
    canPop: false,
    onPopInvoked: (didPop) async {
        if (didPop) return; // If already popped, do nothing
        final shouldPop = await _showExitConfirmation();
        if (shouldPop) {
          Navigator.of(context).pop(); // Manually pop
        }
      },
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Luyện Tập",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () async {
            bool shouldPop = await _showExitConfirmation();
            if (shouldPop) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: 
      Stack(
        children: [ Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // Header with avatar, name, title, and score
            Row(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    // Card with image, name, title
      Container(
        width: 100, // Fixed width to maintain squareness
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.pink.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.pinkAccent, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: currentPlayer!.avatarUrl.startsWith('http')
                  ? Image.network(
                      currentPlayer!.avatarUrl,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/default_image.png',
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 6),
            Text(
              currentPlayer!.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 2),
            Text(
              PlayerUtils.getRankFromElo(currentPlayer!.elo),
              style: TextStyle(
                color: PlayerUtils.getRankColor(PlayerUtils.getRankFromElo(currentPlayer!.elo)),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      SizedBox(width: 8),

      // Score Badge
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.amber[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          score.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    ],
  ),
      SizedBox(height: 20),
Stack(
  alignment: Alignment.center,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${currentQuestion + 1}/$maxQuestions",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "Toán học",
          style: TextStyle(
            fontSize: 20,
            color: Colors.blueGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
    Center(
      child: Text(
        "Đến Lượt Bạn!",
        style: TextStyle(
          color: Colors.orange,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),

            SizedBox(height: 16),

           Align(
  alignment: Alignment.center,
  child: Container(
    width: MediaQuery.of(context).size.width - 16 * 2,
    height: 200,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blueGrey.shade200),
      borderRadius: BorderRadius.circular(10),
      color: Color(0xFFF5F5EC),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Câu hỏi số ${currentQuestion + 1}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          topicQuestions![questionID].question,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
),
            SizedBox(height: 16),

            // Control buttons and timer
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // Left-side buttons
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: usedFiftyFifty ? Colors.grey : Colors.redAccent,
              ),
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: applyFiftyFifty,
              ),
            ),
            SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: usedChangeQuestion ? Colors.grey : Colors.brown,
              ),
              child: IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: changeQuestion,
              ),
            ),
          ],
        ),
        // Right-side timer
        Row(
          children: [
            Text(
              "$timeLeft",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.timer,
              color: Colors.blue,
              size: 24,
            ),
          ],
        ),
      ],
    ),
            SizedBox(height: 16),
          
            // Options
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: shownAnswers.map((i) {
                  String option = topicQuestions![questionID].options[i];
                  return ElevatedButton(
                    onPressed: () {
                      isCorrectAnswer = option == topicQuestions![questionID].correctAnswer;
                      setState(() {
                        showAnimation = true;
                        timer?.cancel();
                        timeLeft = 15;
                      });
                      
                      _lottieController
                      ..reset()
                      ..forward();
                      Future.delayed(Duration(milliseconds: 2750), () {
                        setState(() {
                          showAnimation = false;
                        });
                      });
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade800,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                    child: Text(
                      option.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          ],
        ),
        
      ),
      if (showAnimation)
  AnimatedOpacity(
    duration: Duration(milliseconds: 300),
    opacity: showAnimation ? 1.0 : 0.0,
    child: Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Lottie.asset(
          isCorrectAnswer
              ? 'assets/animations/correct.json'
              : 'assets/animations/wrong.json',
          controller: _lottieController,
          onLoaded: (composition) {
            _lottieController
              ..duration = composition.duration * 0.5 // 2x speed
              ..forward().whenComplete(() async {
        // After the animation is fully played, start the timer
        if(currentQuestion + 1 < maxQuestions) {
        nextQuestion(correct: isCorrectAnswer);
        startTimer();
        } 
        else {
          score += 10;
          final exp = await PlayerUtils.calculateExpGain(score);
          print('Exp gained: $exp');
          updateResult(exp);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => rewardPopup(context, exp, score),
          );
        }
      });
          },
          width: 300,
          height: 300,
          fit: BoxFit.contain,
          repeat: false,
        ),
      ),
    ),
  ),],
      ),
    ),
    );
  }
}