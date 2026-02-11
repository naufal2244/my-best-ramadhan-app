import 'package:flutter/material.dart';

/// HABIT DETAIL SCREEN
/// Halaman detail habit yang menampilkan opsi edit dan hapus
class HabitDetailScreen extends StatelessWidget {
  final String habitName;
  final String habitId;
  final String habitType;
  final List<int>? scheduledDays;
  final int? targetPerWeek;

  const HabitDetailScreen({
    super.key,
    required this.habitName,
    required this.habitId,
    required this.habitType,
    this.scheduledDays,
    this.targetPerWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Habit',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Habit Header Info
              _buildHabitInfo(),

              const SizedBox(height: 40),

              // EDIT HABIT BUTTON
              _buildMenuButton(
                context: context,
                icon: Icons.edit_outlined,
                label: 'Edit Habit',
                subtitle: 'Ubah nama atau frekuensi habit',
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditHabitScreen(
                        habitName: habitName,
                        habitId: habitId,
                        habitType: habitType,
                        initialScheduledDays: scheduledDays,
                        initialTargetPerWeek: targetPerWeek,
                      ),
                    ),
                  );
                  if (result != null && context.mounted) {
                    Navigator.pop(
                        context, result); // Pass result back to HomeScreen
                  }
                },
              ),

              const SizedBox(height: 12),

              // HAPUS HABIT BUTTON
              _buildMenuButton(
                context: context,
                icon: Icons.delete_outline,
                label: 'Hapus Habit',
                subtitle: 'Hapus habit ini secara permanen',
                isDestructive: true,
                onTap: () => _showDeleteConfirmation(context),
              ),

              const Spacer(),

              // INFO BOX
              _buildInfoBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHabitInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('📝', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            habitName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F9EC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  habitType == 'harian' ? 'Habit Harian' : 'Habit Mingguan',
                  style: const TextStyle(
                    color: Color(0xFF32D74B),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            habitType == 'harian'
                ? (scheduledDays != null && scheduledDays!.isNotEmpty
                    ? () {
                        final daysList = scheduledDays!
                            .map((d) => [
                                  'Sen',
                                  'Sel',
                                  'Rab',
                                  'Kam',
                                  'Jum',
                                  'Sab',
                                  'Min'
                                ][d])
                            .toList();
                        if (daysList.length == 1) return daysList.first;
                        final last = daysList.removeLast();
                        return '${daysList.join(', ')} dan $last';
                      }()
                    : 'Setiap hari')
                : '$targetPerWeek kali seminggu',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:
              isDestructive ? const Color(0xFFFFF3F3) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDestructive
                    ? const Color(0xFFFF3B30).withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: isDestructive
                      ? const Color(0xFFFF3B30)
                      : const Color(0xFF32D74B),
                  size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDestructive
                            ? const Color(0xFFFF3B30)
                            : const Color(0xFF1A1A1A),
                      )),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 14,
                color:
                    isDestructive ? const Color(0xFFFF3B30) : Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFFE8F9EC),
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Color(0xFF32D74B)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Tips: Kamu bisa mengubah jadwal atau menghapus habit ini kapan saja.',
              style: TextStyle(
                  fontSize: 13, color: Color(0xFF32D74B), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Habit?'),
        content: Text('Apakah kamu yakin ingin menghapus "$habitName"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, 'delete'); // Signal delete to HomeScreen
            },
            child: const Text('Hapus',
                style: TextStyle(
                    color: Color(0xFFFF3B30), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class EditHabitScreen extends StatefulWidget {
  final String habitName;
  final String habitId;
  final String habitType;
  final List<int>? initialScheduledDays;
  final int? initialTargetPerWeek;

  const EditHabitScreen({
    super.key,
    required this.habitName,
    required this.habitId,
    required this.habitType,
    this.initialScheduledDays,
    this.initialTargetPerWeek,
  });

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  late TextEditingController _nameController;
  late String _selectedType;
  late int _targetPerWeek;
  List<int> _selectedDays = [0, 2, 4];
  bool _isLoading = false;

  final dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habitName);
    _selectedType = widget.habitType;
    _targetPerWeek = widget.initialTargetPerWeek ?? 3;
    _selectedDays = widget.initialScheduledDays != null
        ? List<int>.from(widget.initialScheduledDays!)
        : [0, 2, 4];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Edit Habit',
            style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nama Habit',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),
              const Text('Tipe Habit',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildTypeSelector(),
              const SizedBox(height: 24),
              _selectedType == 'harian'
                  ? _buildDaySelector()
                  : _buildFrequencySelector(),
              const SizedBox(height: 48),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        Expanded(child: _buildTypeOption('Harian', 'harian')),
        const SizedBox(width: 12),
        Expanded(child: _buildTypeOption('Mingguan', 'mingguan')),
      ],
    );
  }

  Widget _buildTypeOption(String label, String type) {
    final isSel = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFFE8F9EC) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: isSel ? Border.all(color: const Color(0xFF32D74B)) : null,
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSel ? const Color(0xFF32D74B) : Colors.grey[600],
              fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
            )),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Center(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: List.generate(7, (i) {
          final isSel = _selectedDays.contains(i);
          return GestureDetector(
            onTap: () => setState(
                () => isSel ? _selectedDays.remove(i) : _selectedDays.add(i)),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSel ? const Color(0xFF32D74B) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                    color: isSel ? const Color(0xFF32D74B) : Colors.grey[300]!),
              ),
              child: Center(
                  child: Text(dayNames[i],
                      style: TextStyle(
                          color: isSel ? Colors.white : Colors.grey[800],
                          fontSize: 12))),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFrequencySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () => setState(() {
                  if (_targetPerWeek > 1) _targetPerWeek--;
                }),
            icon: const Icon(Icons.remove_circle_outline)),
        const SizedBox(width: 20),
        Text('$_targetPerWeek kali',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(width: 20),
        IconButton(
            onPressed: () => setState(() {
                  if (_targetPerWeek < 7) _targetPerWeek++;
                }),
            icon: const Icon(Icons.add_circle_outline)),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          setState(() => _isLoading = true);
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.pop(context, {
              'title': _nameController.text.trim(),
              'type': _selectedType,
              'scheduledDays': _selectedType == 'harian' ? _selectedDays : null,
              'targetPerWeek':
                  _selectedType == 'mingguan' ? _targetPerWeek : null,
            });
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF32D74B),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16))),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Simpan Perubahan',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
