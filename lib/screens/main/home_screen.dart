import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../widgets/habit_tutorial_overlay.dart';
import '../../utils/ramadhan_utils.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:intl/intl.dart';
import '../../models/habit_model.dart';
import 'create_habit_screen.dart';
import 'habit_detail_screen.dart';
import '../../providers/notification_provider.dart';
import '../../models/quote_model.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedTab = 'Harian';
  final List<String> _tabs = ['Harian', 'Mingguan', 'Bulanan'];

  // Unified Habit List
  bool _showCompleted = false;
  bool _showTutorial = false;
  bool _initialTutorialTriggered =
      false; // Guard flag to prevent double trigger
  final dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.userData != null) {
        _fetchInitialData(authProvider);
      }
    });
  }

  void _fetchInitialData(AuthProvider auth) {
    context.read<HabitProvider>().fetchHabits(auth);

    // FETCH QUOTES FOR HOME SCREEN
    final notifProvider = context.read<NotificationProvider>();
    if (notifProvider.quotes.isEmpty) {
      notifProvider.fetchAndScheduleNotifications();
    }
  }

  String get _todayKey => DateFormat('yyyy-MM-dd').format(DateTime.now());

  bool _isDoneToday(HabitModel habit) =>
      habit.completionStatus[_todayKey] ?? false;

  int _getDailyCompletedCount(List<HabitModel> habits) =>
      habits.where((h) => _isDoneToday(h)).length;

  // Navigation Logic
  Future<void> _navToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateHabitScreen()),
    );

    if (result == true) {
      // Refresh data
      final auth = context.read<AuthProvider>();
      if (auth.userData != null) {
        context.read<HabitProvider>().fetchHabits(auth);

        // Show tutorial only if the user hasn't seen it yet
        if (!auth.userData!.hasSeenTutorial) {
          setState(() {
            _showTutorial = true;
          });
          // Update status in Firestore
          auth.setHasSeenTutorial(true);
        } else {
          // Only show SnackBar if tutorial is NOT shown
          if (mounted) {
            _showSuccessSnackBar('Amalan baru berhasil dibuat! 🎉');
          }
        }
      }
    }
  }

  void _dismissTutorial() {
    setState(() {
      _showTutorial = false;
    });
    // Mark only the initial entrance tutorial as seen
    context.read<AuthProvider>().setHasSeenInitialTutorial(true);
  }

  Future<void> _navToDetail(HabitModel habit) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitDetailScreen(habit: habit),
      ),
    );

    if (result == 'delete') {
      // Refresh data
      final auth = context.read<AuthProvider>();
      if (auth.userData != null) {
        context.read<HabitProvider>().fetchHabits(auth);
      }
      if (mounted) {
        _showSuccessSnackBar('Amalan berhasil dihapus.');
      }
    } else if (result == 'edit') {
      // Refresh data
      final auth = context.read<AuthProvider>();
      if (auth.userData != null) {
        context.read<HabitProvider>().fetchHabits(auth);
      }
      if (mounted) {
        _showSuccessSnackBar('Amalan berhasil diperbarui! ✨');
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF32D74B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showUndoSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          // Jika data user belum siap, tampilkan loading
          if (auth.userData == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Trigger fetch habits otomatis jika data user baru saja tersedia
          // atau jika list habit masih kosong (misal setelah logout/login)
          final habitProvider = context.read<HabitProvider>();
          if (habitProvider.habits.isEmpty &&
              !habitProvider.isLoading &&
              !auth.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _fetchInitialData(auth);
              }
            });
          }

          // TUTORIAL CONDITION 1: Muncul saat pertama kali masuk Home (Akun Baru)
          // Fokus hanya pada flag database agar tidak terpengaruh loading habit
          if (!auth.userData!.hasSeenInitialTutorial &&
              !_initialTutorialTriggered) {
            _initialTutorialTriggered =
                true; // Langsung tandai agar tidak berkali-kali
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_showTutorial) {
                setState(() {
                  _showTutorial = true;
                });
              }
            });
          }

          return Stack(
            children: [
              SafeArea(
                child: CustomScrollView(
                  slivers: [
                    // App Bar - Adaptive sizing
                    SliverAppBar(
                      floating: true,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      centerTitle: false,
                      toolbarHeight: (MediaQuery.of(context).size.height * 0.1).clamp(65.0, 85.0), // Even smaller
                      title: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.005), // Even smaller padding 
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assalamualaikum,',
                              style: TextStyle(
                                fontSize: (MediaQuery.of(context).size.width * 0.045).clamp(14.0, 18.0),
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF757575),
                              ),
                            ),
                            const SizedBox(height: 2), // Reduced from 4
                            Text(
                              '${auth.userData?.displayName ?? "User"}! 👋',
                              style: TextStyle(
                                fontSize: (MediaQuery.of(context).size.width * 0.06).clamp(20.0, 26.0), // Smaller
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverPadding(
                      padding:
                          const EdgeInsets.fromLTRB(24.0, 4.0, 24.0, 20.0), // Reduced top padding from 12.0
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Motivational Quote Card
                          _buildQuoteCard(),

                          const SizedBox(height: 24),

                          // Tab Filter
                          Row(
                            children:
                                _tabs.map((tab) => _buildTab(tab)).toList(),
                          ),

                          const SizedBox(height: 16),

                          // Content berdasarkan tab yang dipilih
                          Consumer<HabitProvider>(
                            builder: (context, habitProvider, _) {
                              final habits = habitProvider.habits;
                              if (habitProvider.isLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (_selectedTab == 'Harian')
                                return Column(
                                    children: _buildDailyView(habits));
                              if (_selectedTab == 'Mingguan')
                                return Column(
                                    children: _buildWeeklyView(habits));
                              if (_selectedTab == 'Bulanan')
                                return Column(
                                    children: _buildMonthlyView(habits));

                              return const SizedBox();
                            },
                          ),

                          const SizedBox(height: 100), // Spacing for FAB
                        ]),
                      ),
                    ),
                  ],
                ),
              ),

              // UI Button Plus (FAB) - Put inside Stack but AFTER SafeArea
              // This is behind the tutorial overlay
              Positioned(
                bottom: 24,
                right: 24,
                child: SizedBox(
                  width: 56, // Standard MD FAB Size
                  height: 56, // Standard MD FAB Size
                  child: FloatingActionButton(
                    onPressed: _navToCreate,
                    backgroundColor: const Color(0xFF32D74B),
                    elevation: 6,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add, color: Colors.white, size: 28), // Smaller icon
                  ),
                ),
              ),

              // Tutorial Overlay - Highest layer in Stack
              if (_showTutorial)
                HabitTutorialOverlay(
                  onDismiss: _dismissTutorial,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Consumer<NotificationProvider>(
      builder: (context, notifProvider, _) {
        final quotes = notifProvider.quotes;

        // Pilih quote secara random jika ada
        QuoteModel? randomQuote;
        if (quotes.isNotEmpty) {
          randomQuote = quotes[math.Random().nextInt(quotes.length)];
        }

        final String quoteText = randomQuote != null
            ? '\"${randomQuote.content}\"'
            : '\"Bulan Ramadhan adalah bulan yang di dalamnya diturunkan Al-Qur\'an\"';

        final String quoteSource = randomQuote != null
            ? randomQuote.source
            : 'QS. Al-Baqarah: 185';

        // Quote Section
        return Consumer<AuthProvider>(
          builder: (context, auth, _) {
            final currentDay = RamadhanUtils.getCurrentRamadhanDay(
              auth.ramadhanStartDate,
            );
            final isAfterRamadhan = currentDay > auth.totalRamadhanDays;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4), // Reduced from 8
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Reduced from 16
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF32D74B), Color(0xFF63E677)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF32D74B).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
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
                        child: const Text(
                          '🌙',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isAfterRamadhan
                              ? 'Selamat Idul Fitri 1447 H'
                              : (currentDay > 0
                                  ? 'Ramadhan Hari ke-$currentDay'
                                  : 'Menuju Ramadhan'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14, // Reduced from 16
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isAfterRamadhan
                        ? 'Yuk rayakan hari kemenangan ini dengan penuh kegembiraan! Saatnya berbagi kebahagiaan dan mempererat tali persaudaraan.'
                        : quoteText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13, // Reduced from 14
                      fontStyle: FontStyle.italic,
                      height: 1.4, // Reduced from 1.5
                    ),
                  ),
                  if (!isAfterRamadhan && quoteSource.isNotEmpty) ...[
                    const SizedBox(height: 8), // Reduced from 12
                    Text(
                      '— $quoteSource',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11, // Reduced from 12
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTab(String tab) {
    final isSelected = _selectedTab == tab;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = tab),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 6) // Reduced from 16, 8
            : const EdgeInsets.symmetric(horizontal: 2, vertical: 6), // Reduced from 8
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFE8F9EC),
                borderRadius: BorderRadius.circular(16), // Reduced from 20
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
  List<Widget> _buildDailyView(List<HabitModel> habits) {
    final activeHabits = habits.where((h) => !_isDoneToday(h)).toList();
    final completedHabits = habits.where((h) => _isDoneToday(h)).toList();
    final totalDaily = habits.length;
    final dailyCompleted = _getDailyCompletedCount(habits);

    return [
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 8,
          width: 180,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: totalDaily == 0 ? 0 : dailyCompleted / totalDaily,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF32D74B),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 6), // Reduced from 8
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '$dailyCompleted dari $totalDaily Selesai Hari Ini!',
          style: const TextStyle(
            fontSize: 13, // Reduced from 14
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      const SizedBox(height: 12), // Reduced from 16
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

  Widget _buildDailyHabitItem(HabitModel habit) {
    final isDone = _isDoneToday(habit);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0), // Reduced from 12.0
      child: GestureDetector(
        onTap: () => _navToDetail(habit),
        child: Slidable(
          key: ValueKey('${habit.id}_${isDone}'),
          // Geser ke KANAN untuk Selesai (Hanya jika belum selesai)
          startActionPane: isDone
              ? null
              : ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.3,
                  dismissible: DismissiblePane(
                    onDismissed: () {
                      final auth = context.read<AuthProvider>();
                      context
                          .read<HabitProvider>()
                          .toggleHabit(habit.id, DateTime.now(), auth);
                      _showSuccessSnackBar(
                          'Alhamdulillah, amalan diselesaikan! 🌟');
                    },
                  ),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        final auth = context.read<AuthProvider>();
                        context
                            .read<HabitProvider>()
                            .toggleHabit(habit.id, DateTime.now(), auth);
                        _showSuccessSnackBar(
                            'Alhamdulillah, amalan diselesaikan! 🌟');
                      },
                      backgroundColor: const Color(0xFF32D74B),
                      foregroundColor: Colors.white,
                      icon: Icons.check,
                      label: 'Selesai',
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),
          // Geser ke KIRI untuk Batal (Hanya jika sudah selesai)
          endActionPane: !isDone
              ? null
              : ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.3,
                  dismissible: DismissiblePane(
                    onDismissed: () {
                      final auth = context.read<AuthProvider>();
                      context
                          .read<HabitProvider>()
                          .toggleHabit(habit.id, DateTime.now(), auth);
                      _showUndoSnackBar('Amalan dibatalkan. Semangat ya! 💪');
                    },
                  ),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        final auth = context.read<AuthProvider>();
                        context
                            .read<HabitProvider>()
                            .toggleHabit(habit.id, DateTime.now(), auth);
                        _showUndoSnackBar('Amalan dibatalkan. Semangat ya! 💪');
                      },
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      icon: Icons.undo,
                      label: 'Batal',
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Reduced from 12
            width: double.infinity,
            decoration: BoxDecoration(
              color: habit.isAutoGenerated
                  ? (isDone
                      ? const Color(0xFFD4F4DD)
                      : const Color(0xFFE8F9EC))
                  : (isDone
                      ? const Color(0xFFE8F9EC)
                      : const Color(0xFFF5F5F5)),
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
                    habit.name,
                    style: TextStyle(
                      fontSize: 14, // Reduced from 16
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                Icon(
                  isDone ? Icons.chevron_left : Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============ MINGGUAN VIEW ============
  List<Widget> _buildWeeklyView(List<HabitModel> habits) {
    return [
      const SizedBox(height: 16),
      ...habits.map((habit) {
        // Logic untuk menentukan tanggal-tanggal di minggu ini
        // Sederhananya kita cek completionStatus untuk 7 hari terakhir
        final now = DateTime.now();
        List<bool> weeklyStatus = [];
        for (int i = 0; i < 7; i++) {
          final date = now.subtract(Duration(days: now.weekday - 1 - i));
          final key = DateFormat('yyyy-MM-dd').format(date);
          weeklyStatus.add(habit.completionStatus[key] ?? false);
        }

        String subtitle = habit.type == 'harian'
            ? (habit.scheduledDays.length == 7
                ? 'Setiap Hari'
                : habit.scheduledDays.map((d) => dayNames[d - 1]).join(', '))
            : (habit.targetPerWeek == 7
                ? 'Setiap Hari'
                : 'Seminggu ${habit.targetPerWeek} kali');

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
                        child: Text(habit.name,
                            style: const TextStyle(
                                fontSize: 14, // Reduced from 16
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A))),
                      ),
                      Text(subtitle,
                          style: TextStyle(
                              fontSize: 11, // Reduced from 12
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 12), // Reduced from 16
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      final bool isCompleted = weeklyStatus[index];
                      final bool isScheduled = habit.type == 'harian' &&
                          habit.scheduledDays.contains(index + 1);
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

  Widget _buildWeeklyCircle(
      int index, bool isDone, bool isScheduled, HabitModel h) {
    return Column(
      children: [
        Container(
          width: 32, // Reduced from 36
          height: 32, // Reduced from 36
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
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.transparent),
                size: 18),
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
  List<Widget> _buildMonthlyView(List<HabitModel> habits) {
    return [
      const SizedBox(height: 16),
      ...habits.map((habit) {
        String subtitle = habit.type == 'harian'
            ? (habit.scheduledDays.length == 7
                ? 'Setiap Hari'
                : habit.scheduledDays.map((d) => dayNames[d - 1]).join(', '))
            : (habit.targetPerWeek == 7
                ? 'Setiap Hari'
                : 'Seminggu ${habit.targetPerWeek} kali');

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
                            Text(habit.name,
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
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: List.generate(30, (index) {
                      final now = DateTime.now();
                      final date = DateTime(now.year, now.month, index + 1);
                      final key = DateFormat('yyyy-MM-dd').format(date);
                      final isDone = habit.completionStatus[key] ?? false;
                      final isSched = habit.type == 'harian' &&
                          habit.scheduledDays.contains(((index + 1) % 7) == 0
                              ? 7
                              : (index + 1) % 7); // Simplified logic

                      return Container(
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
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check,
                            color: isDone
                                ? Colors.white
                                : (isSched
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.transparent),
                            size: 14,
                          ),
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
