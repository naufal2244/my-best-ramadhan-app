import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';
import '../../models/habit_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// CREATE HABIT SCREEN
/// Halaman untuk membuat habit baru
/// Diakses ketika user tap tombol + di home screen
class CreateHabitScreen extends StatefulWidget {
  final HabitModel? habit;
  const CreateHabitScreen({super.key, this.habit});

  @override
  State<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedType = 'harian';
  List<int> _selectedDays = [];
  int _targetPerWeek = 1; // Default 1 kali sesuai request
  bool _isLoading = false;

  // Random Placeholder
  String _randomPlaceholder = 'Misal: Tilawah 5 Halaman';
  final List<String> _placeholderExamples = [
    'Misal: Tilawah 5 Halaman',
    'Misal: Tilawah 1 Juz',
    'Misal: Hafalan 1 Ayat',
    'Misal: Tadarus Setelah Subuh',
    'Misal: Muraja\'ah Hafalan',

    // SHALAT SUNNAH (Prioritas #2)
    'Misal: Shalat Duha 4 Rakaat',
    'Misal: Shalat Tahajud',
    'Misal: Shalat Witir',
    'Misal: Rawatib 12 Rakaat',

    // DZIKIR & DOA (Prioritas #3)
    'Misal: Dzikir Pagi & Petang',
    'Misal: Istighfar 100x',
    'Misal: Shalawat 100x',
    'Misal: Wirid Setelah Shalat',

    // SEDEKAH & BERBAGI (Prioritas #4)
    'Misal: Sedekah Harian',
    'Misal: Infaq Setiap Hari',
    'Misal: Bagi Takjil',

    // ILMU & PENGEMBANGAN DIRI (Prioritas #5)
    'Misal: Baca 1 Hadits',
    'Misal: Kajian Ramadhan',
    'Misal: Baca Tafsir 1 Ayat',

    // KESEHATAN (Opsional, yang relevan)
    'Misal: Jaga Sahur Tepat Waktu',
    'Misal: Olahraga Ringan',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _nameController.text = widget.habit!.name;
      _selectedType = widget.habit!.type ?? 'harian';
      if (_selectedType == 'harian') {
        _selectedDays = widget.habit!.scheduledDays.map((d) => d - 1).toList();
      } else {
        _targetPerWeek = widget.habit!.targetPerWeek ?? 1;
      }
    } else {
      // Pick a random placeholder only for NEW habits
      _randomPlaceholder = _placeholderExamples[
          DateTime.now().millisecond % _placeholderExamples.length];
    }
  }

  final dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  Future<void> _handleCreate() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedType == 'harian' && _selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih minimal satu hari untuk habit harian'),
            backgroundColor: Color(0xFFFF3B30),
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final habitProvider = context.read<HabitProvider>();

        if (widget.habit != null) {
          // Mode Edit
          await habitProvider.updateHabit(
            widget.habit!.id,
            _nameController.text.trim(),
            _selectedType == 'harian'
                ? _selectedDays.map((d) => d + 1).toList()
                : [],
            type: _selectedType,
            targetPerWeek: _selectedType == 'mingguan' ? _targetPerWeek : null,
          );
          // Notifikasi akan ditampilkan di HomeScreen
        } else {
          // Mode Baru
          await habitProvider.addHabit(
            _nameController.text.trim(),
            _selectedType == 'harian'
                ? _selectedDays.map((d) => d + 1).toList()
                : [],
            type: _selectedType,
            targetPerWeek: _selectedType == 'mingguan' ? _targetPerWeek : null,
          );
          // Notifikasi akan ditampilkan di HomeScreen
        }

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          Fluttertoast.showToast(
            msg: "Gagal membuat habit: $e",
            backgroundColor: Colors.red,
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 75, // Reduced from 90
        leading: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF1A1A1A)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            widget.habit != null ? 'Edit Amalan' : 'Tambah Amalan Baru',
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 16, // Reduced from 18
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium Header Card
                _buildHeaderCard(),

                const SizedBox(height: 32),

                // Nama Habit Input
                _buildSectionLabel('Nama Amalan'),
                const SizedBox(height: 12),
                _buildNameField(),

                const SizedBox(height: 32),

                // Tipe Habit Selector
                _buildSectionLabel('Tipe Amalan'),
                const SizedBox(height: 12),
                _buildTypeSelector(),

                const SizedBox(height: 24),

                // Konfigurasi berdasarkan Tipe
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _selectedType == 'harian'
                      ? _buildDaySelector()
                      : _buildFrequencySelector(),
                ),

                const SizedBox(height: 48),

                // Simpan Button
                _buildSaveButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF32D74B), Color(0xFF63E677)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF32D74B).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('💡', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mulai Kebiasaan Baik di Ramadhan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14, // Reduced from 16
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Tetapkan target kecil agar konsisten beribadah setiap hari.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12, // Reduced from 13
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14, // Reduced from 15
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: _randomPlaceholder,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Reduced from 15
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF32D74B), width: 2),
        ),
      ),
      validator: (v) =>
          v == null || v.isEmpty ? 'Nama tidak boleh kosong' : null,
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeOption('Harian', 'harian'),
          ),
          Expanded(
            child: _buildTypeOption('Mingguan', 'mingguan'),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(String label, String type) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13, // Reduced from 14
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF32D74B) : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dilakukan pada hari apa saja?',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 16),
        Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(7, (i) {
              final isSelected = _selectedDays.contains(i);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedDays.remove(i);
                    } else {
                      _selectedDays.add(i);
                    }
                  });
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF32D74B) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF32D74B)
                          : Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      dayNames[i],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[800],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Berapa kali dalam seminggu?',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFreqButton(Icons.remove, () {
                if (_targetPerWeek > 1) setState(() => _targetPerWeek--);
              }),
              const SizedBox(width: 32),
              Text(
                _targetPerWeek == 7 ? 'Setiap hari' : '$_targetPerWeek kali',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(width: 32),
              _buildFreqButton(Icons.add, () {
                if (_targetPerWeek < 7) setState(() => _targetPerWeek++);
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFreqButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF32D74B), size: 20),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48, // Reduced from 56
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleCreate,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF32D74B),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Simpan',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold), // Reduced from 16
              ),
      ),
    );
  }
}
