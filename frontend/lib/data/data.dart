import '../models/player.dart';
import '../models/levelprogress.dart';
import '../models/room.dart';

final players = <Player>[
  Player(
    id: 1,
    name: 'Sun',
    email: 'sun@gmail.com',
    avatarUrl: 'assets/images/sun.jpg',
    elo: 1000,
    exp: 500,
    totalMatches: 20,
    wins: 10,
    losses: 10,
  ),
  Player(
    id: 2,
    name: 'Top1',
    email: 'top1@gmail.com',
    avatarUrl: 'assets/images/avatar.jpg',
    elo: 2000,
    exp: 900,
    totalMatches: 111,
    wins: 100,
    losses: 11,
  ),
  Player(
    id: 3,
    name: 'Mèo Lười',
    email: 'meoluoi@gmail.com',
    avatarUrl: 'assets/images/meo_luoi.jpg',
    elo: 1900,
    exp: 450,
    totalMatches: 100,
    wins: 80,
    losses: 20,
  ),
  Player(
    id: 4,
    name: 'Bạch Hổ',
    email: 'bachho@gmail.com',
    avatarUrl: 'assets/images/bach_ho.jpg',
    elo: 1600,
    exp: 600,
    totalMatches: 120,
    wins: 85,
    losses: 35,
  ),
];


/// Giả định user đang đăng nhập
Player currentUser = players[0];

//User password
final List<Map<String, dynamic>> userData = [
  {"username": "abc", "password": "123", "playerIndex": 0}, // Maps to Sun
  {"username": "a", "password": "a", "playerIndex": 1}, // Maps to Top1
  {
    "username": "meoluoi123",
    "password": "meo789",
    "playerIndex": 2,
  }, // Maps to Mèo Lười
  {
    "username": "bachho456",
    "password": "ho101",
    "playerIndex": 3,
  }, // Maps to Bạch Hổ
];

/// Danh sách phòng sẵn có
final rooms = <Room>[
  Room(id: '2001222', host: players[2], opponent: null),
  Room(id: '20902112', host: players[0], opponent: players[3]),
  Room(id: '20902111', host: players[3], opponent: null),
  Room(id: '20901101', host: players[0], opponent: null),
  Room(id: '20901100', host: players[2], opponent: null),
  Room(id: '2080229', host: players[1], opponent: null),
  Room(id: '2070458', host: players[3], opponent: null),
  Room(id: '2050259', host: players[0], opponent: null),
];

// generalKnowledgeQuestions, physicsQuestions, mathQuestions, computerScienceQuestions, animalQuestions, plantQuestions
List<List<Map<String, dynamic>>> allTopics = [
  generalKnowledgeQuestions,
  physicsQuestions,
  mathQuestions,
  computerScienceQuestions,
  animalQuestions,
  plantQuestions,
];
// General Knowledge (Học tập)
List<Map<String, dynamic>> generalKnowledgeQuestions = [
  {
    "id": 1,
    "question": "Thủ đô của Việt Nam là gì?",
    "options": ["Hà Nội", "TP.HCM", "Đà Nẵng", "Cần Thơ"],
    "correctAnswer": "Hà Nội",
  },
  {
    "id": 2,
    "question": "Ngôn ngữ chính thức của Nhật Bản là gì?",
    "options": ["Tiếng Nhật", "Tiếng Anh", "Tiếng Hàn", "Tiếng Trung"],
    "correctAnswer": "Tiếng Nhật",
  },
  {
    "id": 3,
    "question": "Ai là tác giả của 'Truyện Kiều'?",
    "options": ["Nguyễn Du", "Hồ Xuân Hương", "Tố Hữu", "Xuân Diệu"],
    "correctAnswer": "Nguyễn Du",
  },
  {
    "id": 4,
    "question": "Năm bao nhiêu Việt Nam giành độc lập?",
    "options": ["1945", "1954", "1975", "1930"],
    "correctAnswer": "1945",
  },
  {
    "id": 5,
    "question": "Sông dài nhất thế giới là gì?",
    "options": [
      "Sông Nile",
      "Sông Amazon",
      "Sông Dương Tử",
      "Sông Mississippi",
    ],
    "correctAnswer": "Sông Nile",
  },
  {
    "id": 6,
    "question": "Núi cao nhất thế giới là gì?",
    "options": ["Everest", "K2", "Kangchenjunga", "Lhotse"],
    "correctAnswer": "Everest",
  },
  {
    "id": 7,
    "question": "Ai là tổng thống đầu tiên của Mỹ?",
    "options": [
      "George Washington",
      "Abraham Lincoln",
      "Thomas Jefferson",
      "John Adams",
    ],
    "correctAnswer": "George Washington",
  },
  {
    "id": 8,
    "question": "Hành tinh lớn nhất trong Hệ Mặt Trời là gì?",
    "options": ["Sao Mộc", "Sao Thổ", "Trái Đất", "Sao Hỏa"],
    "correctAnswer": "Sao Mộc",
  },
  {
    "id": 9,
    "question": "Quốc gia nào có diện tích lớn nhất?",
    "options": ["Nga", "Trung Quốc", "Mỹ", "Canada"],
    "correctAnswer": "Nga",
  },
  {
    "id": 10,
    "question": "Ai phát minh ra bóng đèn?",
    "options": [
      "Thomas Edison",
      "Nikola Tesla",
      "Albert Einstein",
      "Isaac Newton",
    ],
    "correctAnswer": "Thomas Edison",
  },
  {
    "id": 11,
    "question": "Đại dương lớn nhất thế giới là gì?",
    "options": [
      "Thái Bình Dương",
      "Đại Tây Dương",
      "Ấn Độ Dương",
      "Bắc Băng Dương",
    ],
    "correctAnswer": "Thái Bình Dương",
  },
  {
    "id": 12,
    "question": "Ai là tác giả của 'Harry Potter'?",
    "options": [
      "J.K. Rowling",
      "J.R.R. Tolkien",
      "George R.R. Martin",
      "C.S. Lewis",
    ],
    "correctAnswer": "J.K. Rowling",
  },
  {
    "id": 13,
    "question": "Nước nào tổ chức Thế vận hội đầu tiên?",
    "options": ["Hy Lạp", "Pháp", "Anh", "Mỹ"],
    "correctAnswer": "Hy Lạp",
  },
  {
    "id": 14,
    "question": "Hành tinh nào gần Mặt Trời nhất?",
    "options": ["Thủy Tinh", "Kim Tinh", "Trái Đất", "Sao Hỏa"],
    "correctAnswer": "Thủy Tinh",
  },
  {
    "id": 15,
    "question": "Ai là nhà soạn nhạc của 'Symphony No. 5'?",
    "options": ["Beethoven", "Mozart", "Bach", "Chopin"],
    "correctAnswer": "Beethoven",
  },
  {
    "id": 16,
    "question": "Quốc hoa của Việt Nam là gì?",
    "options": ["Hoa sen", "Hoa mai", "Hoa đào", "Hoa cúc"],
    "correctAnswer": "Hoa sen",
  },
  {
    "id": 17,
    "question": "Ai vẽ bức 'Mona Lisa'?",
    "options": ["Leonardo da Vinci", "Michelangelo", "Raphael", "Van Gogh"],
    "correctAnswer": "Leonardo da Vinci",
  },
  {
    "id": 18,
    "question": "Ngôn ngữ nào được sử dụng nhiều nhất thế giới?",
    "options": ["Tiếng Trung", "Tiếng Anh", "Tiếng Tây Ban Nha", "Tiếng Ả Rập"],
    "correctAnswer": "Tiếng Trung",
  },
  {
    "id": 19,
    "question": "Quốc gia nào có dân số đông nhất?",
    "options": ["Trung Quốc", "Ấn Độ", "Mỹ", "Indonesia"],
    "correctAnswer": "Ấn Độ",
  },
  {
    "id": 20,
    "question": "Ai là người đầu tiên bay vào vũ trụ?",
    "options": ["Yuri Gagarin", "Neil Armstrong", "Buzz Aldrin", "John Glenn"],
    "correctAnswer": "Yuri Gagarin",
  },
];

// Physics (Vật lý)
List<Map<String, dynamic>> physicsQuestions = [
  {
    "id": 1,
    "question": "Đơn vị của lực là gì?",
    "options": ["Newton", "Joule", "Watt", "Pascal"],
    "correctAnswer": "Newton",
  },
  {
    "id": 2,
    "question": "Tốc độ ánh sáng trong chân không là bao nhiêu?",
    "options": ["300,000 km/s", "150,000 km/s", "600,000 km/s", "30,000 km/s"],
    "correctAnswer": "300,000 km/s",
  },
  {
    "id": 3,
    "question": "Ai phát triển thuyết tương đối?",
    "options": ["Einstein", "Newton", "Galileo", "Hawking"],
    "correctAnswer": "Einstein",
  },
  {
    "id": 4,
    "question": "Công thức tính gia tốc là gì?",
    "options": ["a = F/m", "a = m/F", "a = F × m", "a = m - F"],
    "correctAnswer": "a = F/m",
  },
  {
    "id": 5,
    "question": "Đơn vị của năng lượng là gì?",
    "options": ["Joule", "Newton", "Watt", "Pascal"],
    "correctAnswer": "Joule",
  },
  {
    "id": 6,
    "question": "Định luật nào liên quan đến quán tính?",
    "options": [
      "Định luật 1 Newton",
      "Định luật 2 Newton",
      "Định luật 3 Newton",
      "Định luật Hooke",
    ],
    "correctAnswer": "Định luật 1 Newton",
  },
  {
    "id": 7,
    "question": "Áp suất được tính bằng công thức nào?",
    "options": ["P = F/A", "P = A/F", "P = F × A", "P = A - F"],
    "correctAnswer": "P = F/A",
  },
  {
    "id": 8,
    "question": "Đơn vị của công suất là gì?",
    "options": ["Watt", "Joule", "Newton", "Pascal"],
    "correctAnswer": "Watt",
  },
  {
    "id": 9,
    "question": "Hằng số hấp dẫn G có giá trị bao nhiêu?",
    "options": ["6.67 × 10^-11", "9.8", "3 × 10^8", "1.6 × 10^-19"],
    "correctAnswer": "6.67 × 10^-11",
  },
  {
    "id": 10,
    "question": "Điện trở được đo bằng đơn vị gì?",
    "options": ["Ohm", "Volt", "Ampere", "Watt"],
    "correctAnswer": "Ohm",
  },
  {
    "id": 11,
    "question": "Công thức tính công là gì?",
    "options": ["W = F × d", "W = F/d", "W = F + d", "W = d/F"],
    "correctAnswer": "W = F × d",
  },
  {
    "id": 12,
    "question": "Gia tốc trọng trường trên Trái Đất là bao nhiêu?",
    "options": ["9.8 m/s²", "3.2 m/s²", "1.6 m/s²", "12.4 m/s²"],
    "correctAnswer": "9.8 m/s²",
  },
  {
    "id": 13,
    "question": "Ai phát hiện ra định luật vạn vật hấp dẫn?",
    "options": ["Newton", "Einstein", "Galileo", "Kepler"],
    "correctAnswer": "Newton",
  },
  {
    "id": 14,
    "question": "Đơn vị của tần số là gì?",
    "options": ["Hertz", "Joule", "Watt", "Newton"],
    "correctAnswer": "Hertz",
  },
  {
    "id": 15,
    "question": "Định luật Ohm có công thức nào?",
    "options": ["U = I × R", "U = I/R", "U = R/I", "U = I + R"],
    "correctAnswer": "U = I × R",
  },
  {
    "id": 16,
    "question": "Năng lượng tiềm thế được tính thế nào?",
    "options": ["E = mgh", "E = 1/2mv²", "E = mc²", "E = Fd"],
    "correctAnswer": "E = mgh",
  },
  {
    "id": 17,
    "question": "Đơn vị của điện áp là gì?",
    "options": ["Volt", "Ampere", "Ohm", "Watt"],
    "correctAnswer": "Volt",
  },
  {
    "id": 18,
    "question": "Sóng âm truyền nhanh nhất trong môi trường nào?",
    "options": ["Chất rắn", "Chất lỏng", "Chất khí", "Chân không"],
    "correctAnswer": "Chất rắn",
  },
  {
    "id": 19,
    "question": "Định luật nào nói về tác dụng lực và phản lực?",
    "options": [
      "Định luật 3 Newton",
      "Định luật 1 Newton",
      "Định luật 2 Newton",
      "Định luật Hooke",
    ],
    "correctAnswer": "Định luật 3 Newton",
  },
  {
    "id": 20,
    "question": "Nhiệt độ 0 Kelvin tương ứng với bao nhiêu độ C?",
    "options": ["-273°C", "0°C", "100°C", "-100°C"],
    "correctAnswer": "-273°C",
  },
];

// Mathematics (Toán học)
List<Map<String, dynamic>> mathQuestions = [
  {
    "id": 1,
    "question": "1 + 99 - 2 = ?",
    "options": ["98", "100", "2", "5"],
    "correctAnswer": "98",
  },
  {
    "id": 2,
    "question": "10 + 20 - 15 = ?",
    "options": ["15", "25", "5", "35"],
    "correctAnswer": "15",
  },
  {
    "id": 3,
    "question": "50 - 30 + 10 = ?",
    "options": ["20", "30", "10", "40"],
    "correctAnswer": "30",
  },
  {
    "id": 4,
    "question": "8 × 3 - 4 = ?",
    "options": ["20", "24", "16", "28"],
    "correctAnswer": "20",
  },
  {
    "id": 5,
    "question": "45 ÷ 9 + 7 = ?",
    "options": ["10", "12", "15", "8"],
    "correctAnswer": "12",
  },
  {
    "id": 6,
    "question": "100 - 25 × 2 = ?",
    "options": ["25", "50", "75", "0"],
    "correctAnswer": "50",
  },
  {
    "id": 7,
    "question": "12 + 18 ÷ 3 = ?",
    "options": ["18", "14", "10", "6"],
    "correctAnswer": "18",
  },
  {
    "id": 8,
    "question": "5² + 3² = ?",
    "options": ["34", "16", "25", "9"],
    "correctAnswer": "34",
  },
  {
    "id": 9,
    "question": "72 ÷ 8 - 3 = ?",
    "options": ["6", "9", "12", "3"],
    "correctAnswer": "6",
  },
  {
    "id": 10,
    "question": "15 × 4 + 10 = ?",
    "options": ["70", "50", "60", "80"],
    "correctAnswer": "70",
  },
  {
    "id": 11,
    "question": "100 ÷ 4 - 5 = ?",
    "options": ["20", "25", "15", "30"],
    "correctAnswer": "20",
  },
  {
    "id": 12,
    "question": "9 × 7 - 13 = ?",
    "options": ["50", "63", "40", "76"],
    "correctAnswer": "50",
  },
  {
    "id": 13,
    "question": "16 + 24 ÷ 8 = ?",
    "options": ["19", "10", "8", "5"],
    "correctAnswer": "19",
  },
  {
    "id": 14,
    "question": "3³ - 2³ = ?",
    "options": ["19", "25", "8", "27"],
    "correctAnswer": "19",
  },
  {
    "id": 15,
    "question": "48 ÷ 6 + 4 = ?",
    "options": ["12", "8", "10", "6"],
    "correctAnswer": "12",
  },
  {
    "id": 16,
    "question": "20 × 3 - 15 = ?",
    "options": ["45", "60", "30", "75"],
    "correctAnswer": "45",
  },
  {
    "id": 17,
    "question": "81 ÷ 9 + 1 = ?",
    "options": ["10", "8", "7", "9"],
    "correctAnswer": "10",
  },
  {
    "id": 18,
    "question": "7 × 8 - 6 = ?",
    "options": ["50", "56", "48", "62"],
    "correctAnswer": "50",
  },
  {
    "id": 19,
    "question": "25 + 15 ÷ 5 = ?",
    "options": ["28", "10", "15", "5"],
    "correctAnswer": "28",
  },
  {
    "id": 20,
    "question": "36 ÷ 4 + 2 = ?",
    "options": ["11", "9", "7", "13"],
    "correctAnswer": "11",
  },
];

// Computer Science (Tin học)
List<Map<String, dynamic>> computerScienceQuestions = [
  {
    "id": 1,
    "question": "Ngôn ngữ lập trình nào ra đời đầu tiên?",
    "options": ["Fortran", "C", "Python", "Java"],
    "correctAnswer": "Fortran",
  },
  {
    "id": 2,
    "question": "1 byte bằng bao nhiêu bit?",
    "options": ["8", "4", "16", "32"],
    "correctAnswer": "8",
  },
  {
    "id": 3,
    "question": "Ai là người sáng tạo ra Linux?",
    "options": [
      "Linus Torvalds",
      "Bill Gates",
      "Steve Jobs",
      "Mark Zuckerberg",
    ],
    "correctAnswer": "Linus Torvalds",
  },
  {
    "id": 4,
    "question": "HTML là viết tắt của gì?",
    "options": [
      "HyperText Markup Language",
      "HighText Machine Language",
      "HyperTool Markup Language",
      "HighTech Markup Language",
    ],
    "correctAnswer": "HyperText Markup Language",
  },
  {
    "id": 5,
    "question": "Cấu trúc dữ liệu nào hoạt động theo nguyên tắc LIFO?",
    "options": ["Stack", "Queue", "Array", "Linked List"],
    "correctAnswer": "Stack",
  },
  {
    "id": 6,
    "question": "Ngôn ngữ nào thường dùng để phát triển web?",
    "options": ["JavaScript", "C++", "Python", "Java"],
    "correctAnswer": "JavaScript",
  },
  {
    "id": 7,
    "question": "1 GB bằng bao nhiêu MB?",
    "options": ["1024", "1000", "512", "2048"],
    "correctAnswer": "1024",
  },
  {
    "id": 8,
    "question": "HTTP là viết tắt của gì?",
    "options": [
      "HyperText Transfer Protocol",
      "HighText Transfer Protocol",
      "HyperTool Transfer Protocol",
      "HighTech Transfer Protocol",
    ],
    "correctAnswer": "HyperText Transfer Protocol",
  },
  {
    "id": 9,
    "question": "Ai sáng lập Microsoft?",
    "options": ["Bill Gates", "Steve Jobs", "Elon Musk", "Jeff Bezos"],
    "correctAnswer": "Bill Gates",
  },
  {
    "id": 10,
    "question": "Cơ số của hệ nhị phân là bao nhiêu?",
    "options": ["2", "8", "10", "16"],
    "correctAnswer": "2",
  },
  {
    "id": 11,
    "question": "Ngôn ngữ lập trình nào được tạo bởi Guido van Rossum?",
    "options": ["Python", "Java", "C++", "Ruby"],
    "correctAnswer": "Python",
  },
  {
    "id": 12,
    "question": "Cấu trúc dữ liệu nào hoạt động theo nguyên tắc FIFO?",
    "options": ["Queue", "Stack", "Array", "Tree"],
    "correctAnswer": "Queue",
  },
  {
    "id": 13,
    "question": "DNS là viết tắt của gì?",
    "options": [
      "Domain Name System",
      "Data Network System",
      "Digital Name System",
      "Domain Network System",
    ],
    "correctAnswer": "Domain Name System",
  },
  {
    "id": 14,
    "question": "1 TB bằng bao nhiêu GB?",
    "options": ["1024", "1000", "512", "2048"],
    "correctAnswer": "1024",
  },
  {
    "id": 15,
    "question": "Ngôn ngữ nào thường dùng để phát triển ứng dụng Android?",
    "options": ["Kotlin", "Python", "C++", "Ruby"],
    "correctAnswer": "Kotlin",
  },
  {
    "id": 16,
    "question": "SQL là viết tắt của gì?",
    "options": [
      "Structured Query Language",
      "Simple Query Language",
      "Structured Question Language",
      "Simple Question Language",
    ],
    "correctAnswer": "Structured Query Language",
  },
  {
    "id": 17,
    "question": "Ai sáng lập Apple?",
    "options": ["Steve Jobs", "Bill Gates", "Elon Musk", "Mark Zuckerberg"],
    "correctAnswer": "Steve Jobs",
  },
  {
    "id": 18,
    "question": "Cơ số của hệ thập lục phân là bao nhiêu?",
    "options": ["16", "2", "8", "10"],
    "correctAnswer": "16",
  },
  {
    "id": 19,
    "question": "Phần mềm nào là trình duyệt web?",
    "options": [
      "Google Chrome",
      "Microsoft Word",
      "Adobe Photoshop",
      "Notepad",
    ],
    "correctAnswer": "Google Chrome",
  },
  {
    "id": 20,
    "question": "Ngôn ngữ lập trình nào được dùng để phát triển iOS?",
    "options": ["Swift", "Java", "Python", "C++"],
    "correctAnswer": "Swift",
  },
];

// Animals (Động vật)
List<Map<String, dynamic>> animalQuestions = [
  {
    "id": 1,
    "question": "Loài động vật nào cao nhất trên cạn?",
    "options": ["Hươu cao cổ", "Voi", "Tê giác", "Ngựa"],
    "correctAnswer": "Hươu cao cổ",
  },
  {
    "id": 2,
    "question": "Loài nào là động vật có vú lớn nhất?",
    "options": ["Cá voi xanh", "Voi châu Phi", "Hà mã", "Tê giác"],
    "correctAnswer": "Cá voi xanh",
  },
  {
    "id": 3,
    "question": "Loài chim nào không thể bay?",
    "options": ["Chim cánh cụt", "Đại bàng", "Chim ưng", "Chim sẻ"],
    "correctAnswer": "Chim cánh cụt",
  },
  {
    "id": 4,
    "question": "Loài nào được gọi là 'vua rừng'?",
    "options": ["Sư tử", "Hổ", "Gấu", "Sói"],
    "correctAnswer": "Sư tử",
  },
  {
    "id": 5,
    "question": "Loài động vật nào nhanh nhất trên cạn?",
    "options": ["Báo săn", "Ngựa", "Chó", "Hươu"],
    "correctAnswer": "Báo săn",
  },
  {
    "id": 6,
    "question": "Loài cá nào lớn nhất?",
    "options": ["Cá mập voi", "Cá voi xanh", "Cá heo", "Cá mập trắng"],
    "correctAnswer": "Cá mập voi",
  },
  {
    "id": 7,
    "question": "Loài nào có thể đổi màu da?",
    "options": ["Tắc kè hoa", "Rắn", "Cá sấu", "Thằn lằn"],
    "correctAnswer": "Tắc kè hoa",
  },
  {
    "id": 8,
    "question": "Loài chim nào có cánh dài nhất?",
    "options": ["Hải âu", "Đại bàng", "Chim ưng", "Chim sẻ"],
    "correctAnswer": "Hải âu",
  },
  {
    "id": 9,
    "question": "Loài nào có tuổi thọ cao nhất?",
    "options": ["Rùa", "Voi", "Cá voi", "Chim đại bàng"],
    "correctAnswer": "Rùa",
  },
  {
    "id": 10,
    "question": "Loài nào là động vật có túi?",
    "options": ["Kangaroo", "Gấu", "Sư tử", "Hổ"],
    "correctAnswer": "Kangaroo",
  },
  {
    "id": 11,
    "question": "Loài nào có vòi dài nhất?",
    "options": ["Voi", "Hươu cao cổ", "Tê giác", "Hà mã"],
    "correctAnswer": "Voi",
  },
  {
    "id": 12,
    "question": "Loài chim nào nhỏ nhất thế giới?",
    "options": ["Chim ruồi", "Chim sẻ", "Chim chích", "Chim én"],
    "correctAnswer": "Chim ruồi",
  },
  {
    "id": 13,
    "question": "Loài nào có thể sống dưới nước và trên cạn?",
    "options": ["Cá sấu", "Cá voi", "Cá heo", "Cá mập"],
    "correctAnswer": "Cá sấu",
  },
  {
    "id": 14,
    "question": "Loài nào có sọc đen trắng?",
    "options": ["Ngựa vằn", "Hươu", "Bò", "Dê"],
    "correctAnswer": "Ngựa vằn",
  },
  {
    "id": 15,
    "question": "Loài nào là động vật ăn thịt lớn nhất?",
    "options": ["Gấu trắng", "Sư tử", "Hổ", "Sói"],
    "correctAnswer": "Gấu trắng",
  },
  {
    "id": 16,
    "question": "Loài nào có thể bay nhưng không phải chim?",
    "options": ["Dơi", "Cá voi", "Cá sấu", "Rắn"],
    "correctAnswer": "Dơi",
  },
  {
    "id": 17,
    "question": "Loài nào có xúc tu dài nhất?",
    "options": ["Mực khổng lồ", "Bạch tuộc", "Cá voi", "Cá mập"],
    "correctAnswer": "Mực khổng lồ",
  },
  {
    "id": 18,
    "question": "Loài nào có thể ngủ đông?",
    "options": ["Gấu", "Sư tử", "Hổ", "Voi"],
    "correctAnswer": "Gấu",
  },
  {
    "id": 19,
    "question": "Loài nào là động vật ăn cỏ lớn nhất?",
    "options": ["Voi", "Hươu cao cổ", "Tê giác", "Hà mã"],
    "correctAnswer": "Voi",
  },
  {
    "id": 20,
    "question": "Loài nào có thể nhảy xa nhất?",
    "options": ["Kangaroo", "Châu chấu", "Ếch", "Thỏ"],
    "correctAnswer": "Kangaroo",
  },
];

// Plants (Thực vật)
List<Map<String, dynamic>> plantQuestions = [
  {
    "id": 1,
    "question": "Loài cây nào cao nhất thế giới?",
    "options": ["Cây Sequoia", "Cây thông", "Cây dừa", "Cây tre"],
    "correctAnswer": "Cây Sequoia",
  },
  {
    "id": 2,
    "question": "Quá trình nào giúp cây tạo năng lượng?",
    "options": ["Quang hợp", "Hô hấp", "Thoát hơi nước", "Hấp thụ"],
    "correctAnswer": "Quang hợp",
  },
  {
    "id": 3,
    "question": "Loài cây nào là biểu tượng của Việt Nam?",
    "options": ["Cây tre", "Cây dừa", "Cây thông", "Cây bạch đàn"],
    "correctAnswer": "Cây tre",
  },
  {
    "id": 4,
    "question": "Loài hoa nào là biểu tượng của Nhật Bản?",
    "options": ["Hoa anh đào", "Hoa sen", "Hoa hồng", "Hoa cúc"],
    "correctAnswer": "Hoa anh đào",
  },
  {
    "id": 5,
    "question": "Cây nào có thể sống trong sa mạc?",
    "options": ["Xương rồng", "Cây thông", "Cây dừa", "Cây chuối"],
    "correctAnswer": "Xương rồng",
  },
  {
    "id": 6,
    "question": "Loài cây nào có lá lớn nhất?",
    "options": ["Cây Raffia", "Cây chuối", "Cây dừa", "Cây thông"],
    "correctAnswer": "Cây Raffia",
  },
  {
    "id": 7,
    "question": "Cây nào được dùng để sản xuất giấy?",
    "options": ["Cây tre", "Cây bông", "Cây mía", "Cây cao su"],
    "correctAnswer": "Cây tre",
  },
  {
    "id": 8,
    "question": "Loài cây nào có tuổi thọ cao nhất?",
    "options": ["Cây thông Bristlecone", "Cây Sequoia", "Cây dừa", "Cây tre"],
    "correctAnswer": "Cây thông Bristlecone",
  },
  {
    "id": 9,
    "question": "Loài cây nào có quả lớn nhất?",
    "options": ["Cây mít", "Cây dừa", "Cây xoài", "Cây bưởi"],
    "correctAnswer": "Cây mít",
  },
  {
    "id": 10,
    "question": "Cây nào có thể bắt côn trùng?",
    "options": ["Cây nắp ấm", "Cây dừa", "Cây thông", "Cây chuối"],
    "correctAnswer": "Cây nắp ấm",
  },
  {
    "id": 11,
    "question": "Loài hoa nào nở vào ban đêm?",
    "options": ["Hoa quỳnh", "Hoa hồng", "Hoa cúc", "Hoa sen"],
    "correctAnswer": "Hoa quỳnh",
  },
  {
    "id": 12,
    "question": "Cây nào được dùng để sản xuất cao su?",
    "options": ["Cây cao su", "Cây dừa", "Cây thông", "Cây tre"],
    "correctAnswer": "Cây cao su",
  },
  {
    "id": 13,
    "question": "Loài cây nào có gai trên thân?",
    "options": ["Cây hồng", "Cây dừa", "Cây chuối", "Cây tre"],
    "correctAnswer": "Cây hồng",
  },
  {
    "id": 14,
    "question": "Cây nào là nguồn gốc của cà phê?",
    "options": ["Cây cà phê", "Cây chè", "Cây ca cao", "Cây mía"],
    "correctAnswer": "Cây cà phê",
  },
  {
    "id": 15,
    "question": "Loài hoa nào tượng trưng cho tình yêu?",
    "options": ["Hoa hồng", "Hoa sen", "Hoa cúc", "Hoa lan"],
    "correctAnswer": "Hoa hồng",
  },
  {
    "id": 16,
    "question": "Cây nào có thể sống dưới nước?",
    "options": ["Cây súng", "Cây thông", "Cây dừa", "Cây tre"],
    "correctAnswer": "Cây súng",
  },
  {
    "id": 17,
    "question": "Loài cây nào có lá đổi màu theo mùa?",
    "options": ["Cây phong", "Cây dừa", "Cây chuối", "Cây tre"],
    "correctAnswer": "Cây phong",
  },
  {
    "id": 18,
    "question": "Cây nào được dùng để sản xuất đường?",
    "options": ["Cây mía", "Cây dừa", "Cây thông", "Cây chuối"],
    "correctAnswer": "Cây mía",
  },
  {
    "id": 19,
    "question": "Loài hoa nào có mùi hương mạnh nhất?",
    "options": ["Hoa nhài", "Hoa hồng", "Hoa cúc", "Hoa sen"],
    "correctAnswer": "Hoa nhài",
  },
  {
    "id": 20,
    "question": "Cây nào là nguồn gốc của sô-cô-la?",
    "options": ["Cây ca cao", "Cây cà phê", "Cây chè", "Cây mía"],
    "correctAnswer": "Cây ca cao",
  },
];
