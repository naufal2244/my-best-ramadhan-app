import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'create_habit_screen.dart';
import 'habit_detail_screen.dart';
import '../../widgets/habit_tutorial_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedTab = 'Harian';
  final List<String> _tabs = ['Harian', 'Mingguan', 'Keseluruhan'];

  // Unified Habit List
  List<Map<String, dynamic>> _habits = [
    {
      'id': 1,
      'title': 'Tilawah 5 Halaman',
      'type': 'harian',
      'scheduledDays': [0, 2, 4], // Sen, Rab, Jum
      'targetPerWeek': null,
      'completedDates': [1, 3, 10],
    },
    {
      'id': 2,
      'title': 'Duha',
      'type': 'mingguan',
      'scheduledDays': null,
      'targetPerWeek': 3,
      'completedDates': [1, 5],
    },
  ];

  bool _showCompleted = false;
  bool _showTutorial = false;
  bool _tutorialShownInThisSession = false; // Add this track to session only
  final dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  int get _todayDate {
    final now = DateTime.now();
    return now.day > 30 ? 30 : now.day;
  }

  bool _isDoneToday(Map<String, dynamic> habit) =>
      habit['completedDates'].contains(_todayDate);

  int get _dailyCompletedCount => _habits.where((h) => _isDoneToday(h)).length;

  // Navigation Logic
  Future<void> _navToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateHabitScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _habits.add(result);
      });

      // Show tutorial on the very first manual creation of this session
      if (!_tutorialShownInThisSession) {
        setState(() {
          _showTutorial = true;
          _tutorialShownInThisSession = true;
        });
      } else {
        // Only show SnackBar if tutorial is NOT shown
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Habit baru berhasil dibuat! 🎉'),
            backgroundColor: Color(0xFF32D74B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _dismissTutorial() {
    setState(() {
      _showTutorial = false;
    });
  }

  Future<void> _navToDetail(Map<String, dynamic> habit) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitDetailScreen(
          habitName: habit['title'],
          habitId: habit['id'].toString(),
          habitType: habit['type'],
          scheduledDays: habit['scheduledDays'] != null
              ? List<int>.from(habit['scheduledDays'])
              : null,
          targetPerWeek: habit['targetPerWeek'],
          // We could pass the whole object if we want
        ),
      ),
    );

    if (result == 'delete') {
      setState(() {
        _habits.removeWhere((h) => h['id'] == habit['id']);
      });
    } else if (result != null && result is Map<String, dynamic>) {
      // Handle update if needed
      setState(() {
        final index = _habits.indexWhere((h) => h['id'] == habit['id']);
        if (index != -1) {
          _habits[index] = {..._habits[index], ...result};
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 22,
                          color: Color(0xFF1A1A1A),
                        ),
                        children: [
                          TextSpan(
                            text: 'Assalamualaikum, ',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[600],
                            ),
                          ),
                          const TextSpan(
                            text: 'Naufal! 👋',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Motivational Quote Card
                      _buildQuoteCard(),

                      const SizedBox(height: 24),

                      // Tab Filter
                      Row(
                        children: _tabs.map((tab) => _buildTab(tab)).toList(),
                      ),

                      const SizedBox(height: 16),

                      // Content berdasarkan tab yang dipilih
                      if (_selectedTab == 'Harian') ..._buildDailyView(),
                      if (_selectedTab == 'Mingguan') ..._buildWeeklyView(),
                      if (_selectedTab == 'Keseluruhan') ..._buildMonthlyView(),

                      const SizedBox(height: 80),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // Tutorial Overlay
          if (_showTutorial)
            HabitTutorialOverlay(
              onDismiss: _dismissTutorial,
            ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF32D74B), Color(0xFF63E677)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF32D74B).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('🌙', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Ramadhan Hari ke-12',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"Bulan Ramadhan adalah bulan yang di dalamnya diturunkan Al-Qur\'an"',
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 14,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '— QS. Al-Baqarah: 185',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tab) {
    final isSelected = _selectedTab == tab;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = tab),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            : const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFE8F9EC),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Text(
          tab,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color:
                isSelected ? const Color(0xFF32D74B) : const Color(0xFF9E9E9E),
          ),
        ),
      ),
    );
  }

  // ============ HARIAN VIEW ============
  List<Widget> _buildDailyView() {
    final activeHabits = _habits.where((h) => !_isDoneToday(h)).toList();
    final completedHabits = _habits.where((h) => _isDoneToday(h)).toList();

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 180,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor:
                    _habits.isEmpty ? 0 : _dailyCompletedCount / _habits.length,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF32D74B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _navToCreate,
            child: const Icon(Icons.add, color: Color(0xFF1A1A1A), size: 28),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        '$_dailyCompletedCount dari ${_habits.length} Selesai Hari Ini!',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A1A),
        ),
      ),
      const SizedBox(height: 16),
      ...activeHabits.map((habit) => _buildDailyHabitItem(habit)).toList(),
      const SizedBox(height: 16),
      if (completedHabits.isNotEmpty) ...[
        _buildCompletedToggle(completedHabits.length),
        const SizedBox(height: 12),
        if (_showCompleted)
          ...completedHabits
              .map((habit) => _buildDailyHabitItem(habit))
              .toList(),
      ],
    ];
  }

  Widget _buildCompletedToggle(int count) {
    return InkWell(
      onTap: () => setState(() => _showCompleted = !_showCompleted),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _showCompleted
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              _showCompleted
                  ? 'Sembunyikan yang selesai'
                  : 'Tampilkan yang selesai ($count)',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyHabitItem(Map<String, dynamic> habit) {
    final isDone = _isDoneToday(habit);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () => _navToDetail(habit),
        child: Slidable(
          key: ValueKey(habit['id']),
          enabled: !isDone,
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.3,
            dismissible: DismissiblePane(
              onDismissed: () {
                setState(() {
                  if (!habit['completedDates'].contains(_todayDate)) {
                    habit['completedDates'].add(_todayDate);
                  }
                });
              },
            ),
            children: [
              SlidableAction(
                onPressed: (context) {
                  setState(() {
                    if (!habit['completedDates'].contains(_todayDate)) {
                      habit['completedDates'].add(_todayDate);
                    }
                  });
                },
                backgroundColor: const Color(0xFF32D74B),
                foregroundColor: Colors.white,
                icon: Icons.check,
                label: 'Selesai',
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDone ? const Color(0xFFE8F9EC) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDone
                    ? const Color(0xFF32D74B).withOpacity(0.3)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    habit['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                if (!isDone)
                  Icon(Icons.chevron_left, color: Colors.grey[400], size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============ MINGGUAN VIEW ============
  List<Widget> _buildWeeklyView() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: _navToCreate,
            child: const Icon(Icons.add, color: Color(0xFF1A1A1A), size: 28),
          ),
        ],
      ),
      const SizedBox(height: 16),
      ..._habits.map((habit) {
        final List<int> completedThisWeek =
            (habit['completedDates'] as List<dynamic>)
                .where((d) => (d as int) <= 7)
                .map((d) => (d as int) - 1)
                .cast<int>()
                .toList();

        String subtitle = habit['type'] == 'harian'
            ? (habit['scheduledDays'] as List)
                .map((d) => dayNames[d as int])
                .join(', ')
            : '${habit['targetPerWeek']} kali seminggu';

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: GestureDetector(
            onTap: () => _navToDetail(habit),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(habit['title'],
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A))),
                      ),
                      Text(subtitle,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      final bool isCompleted =
                          completedThisWeek.contains(index);
                      final bool isScheduled = habit['type'] == 'harian' &&
                          (habit['scheduledDays'] as List).contains(index);
                      return _buildWeeklyCircle(
                          index, isCompleted, isScheduled, habit);
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    ];
  }

  Widget _buildWeeklyCircle(int index, bool isDone, bool isScheduled, Map h) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (isDone) {
                h['completedDates'].remove(index + 1);
              } else {
                h['completedDates'].add(index + 1);
              }
            });
          },
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDone
                  ? const Color(0xFF32D74B)
                  : (isScheduled ? const Color(0xFFE0E0E0) : Colors.white),
              shape: BoxShape.circle,
              border: Border.all(
                  color: isDone
                      ? const Color(0xFF32D74B)
                      : (isScheduled
                          ? const Color(0xFFCCCCCC)
                          : Colors.grey[300]!),
                  width: 2),
            ),
            child: Center(
              child: Icon(Icons.check,
                  color: isDone
                      ? Colors.white
                      : (isScheduled
                          ? Colors.white.withOpacity(0.5)
                          : Colors.transparent),
                  size: 18),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(dayNames[index],
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600])),
      ],
    );
  }

  // ============ KESELURUHAN VIEW ============
  List<Widget> _buildMonthlyView() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: _navToCreate,
            child: const Icon(Icons.add, color: Color(0xFF1A1A1A), size: 28),
          ),
        ],
      ),
      const SizedBox(height: 16),
      ..._habits.map((habit) {
        final completedDates = List<int>.from(habit['completedDates']);
        String subtitle = habit['type'] == 'harian'
            ? 'Setiap ${(habit['scheduledDays'] as List).map((d) => dayNames[d as int]).join(', ')}'
            : '${habit['targetPerWeek'] * 4} kali sebulan';
        String targetText = habit['type'] == 'harian'
            ? 'Target: Rutin Harian'
            : 'Target: ${habit['targetPerWeek'] * 4} kali';
        final percentage = (completedDates.length / 30 * 100).toInt();

        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: GestureDetector(
            onTap: () => _navToDetail(habit),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(habit['title'],
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A1A))),
                            const SizedBox(height: 4),
                            Text(subtitle,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('$percentage%',
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF32D74B))),
                          const SizedBox(height: 4),
                          Text(targetText,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: List.generate(30, (index) {
                      final dNum = index + 1;
                      final isDone = completedDates.contains(dNum);
                      final isSched = habit['type'] == 'harian' &&
                          (habit['scheduledDays'] as List).contains(index % 7);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isDone)
                              habit['completedDates'].remove(dNum);
                            else
                              habit['completedDates'].add(dNum);
                          });
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isDone
                                ? const Color(0xFF32D74B)
                                : (isSched
                                    ? const Color(0xFFE0E0E0)
                                    : Colors.white),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: isDone
                                    ? const Color(0xFF32D74B)
                                    : (isSched
                                        ? const Color(0xFFCCCCCC)
                                        : Colors.grey[300]!),
                                width: 1.5),
                          ),
                          child: Center(
                              child: Icon(Icons.check,
                                  color: isDone
                                      ? Colors.white
                                      : (isSched
                                          ? Colors.white.withOpacity(0.5)
                                          : Colors.transparent),
                                  size: 14)),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    ];
  }
}
