import 'package:flutter/material.dart';
import 'models/player.dart';
import 'models/playerutils.dart';
import 'services/APICall.dart';
import 'services/auth_service.dart';
import 'constants.dart';

class RankedScreen extends StatefulWidget {
  final VoidCallback onBack;

  const RankedScreen({super.key, required this.onBack});

  @override
  State<RankedScreen> createState() => _RankedScreenState();
}

class _RankedScreenState extends State<RankedScreen> {
  List<Player> rankings = [];
  int myRankIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkSignIn();
    // Replace this with your actual API call
    fetchRankingData();
  }

  void checkSignIn() async {
    if (!await AuthService.isLoggedIn()) {
      // If not logged in, redirect to login screen
      await AuthService.logout(); // Ensure user is logged out

      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
  }

  void fetchRankingData() async {
    // Simulated API response
    // TODO: Replace with actual API call
    setState(() {
      _isLoading = true;
    });

    try {
      final api = ApiService(
        baseUrl: SERVER_URL, // Replace with your API base URL
        token: await AuthService.getToken(), // Get the token from your auth service
      );
      final leaderboard = await api.fetchLeaderboard(); // Replace with your actual API method

      final rankIndex = await api.getMyRank();

      setState(() {
        rankings = leaderboard;
        myRankIndex = rankIndex;
        _isLoading = false;
      });

    } catch(e) {
      print('Error fetching rankings: $e');
      // Handle error appropriately, e.g., show a snackbar or dialog
      setState(() {
        rankings = []; // Clear rankings on error
        _isLoading = false;
      });
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Widget _buildRankTile(int index, Player data) {
    final rank = index + 1;
    final isTop3 = rank <= 3;
    final colors = [
      Colors.greenAccent.shade400,
      Colors.amberAccent.shade700,
      Colors.deepOrangeAccent.shade200,
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isTop3 ? colors[rank - 1] : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  PlayerUtils.getRankFromElo(data.elo) ?? "Hạng chưa rõ",
                  style: TextStyle(color: PlayerUtils.getRankColor(PlayerUtils.getRankFromElo(data.elo)), fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Điểm tích lũy',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 12,
                ),
              ),
              Text(
                '${data.elo}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

    @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.brown),
        onPressed: widget.onBack,
      ),
      title: const Text(
        'Bảng xếp hạng',
        style: TextStyle(
          color: Colors.deepOrange,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    ),
    extendBodyBehindAppBar: true,
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDEEFFF), Color(0xFFEEF4FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea( // Automatically handles status bar spacing
        child: _isLoading ? const Center(child: CircularProgressIndicator()) : Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    'Thứ hạng bản thân: $myRankIndex', // <-- Replace with actual data later
                    style: TextStyle(
                      color: Colors.teal.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: rankings.length,
                itemBuilder: (context, index) =>
                    _buildRankTile(index, rankings[index]),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

