import 'package:flutter/material.dart';

class DobField extends StatefulWidget {
  final DateTime? initialDate;
  final void Function(DateTime) onDateChanged;
  final String? Function(DateTime?)? validator;

  const DobField({
    super.key,
    this.initialDate,
    required this.onDateChanged,
    this.validator,
  });

  @override
  State<DobField> createState() => _DobFieldState();
}

class _DobFieldState extends State<DobField> {
  int? _selectedDay;
  int? _selectedMonth;
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDay = widget.initialDate!.day;
      _selectedMonth = widget.initialDate!.month;
      _selectedYear = widget.initialDate!.year;
    }
  }

  List<int> get _days {
    if (_selectedMonth == null || _selectedYear == null) {
      return List.generate(31, (index) => index + 1);
    }
    final daysInMonth = DateTime(_selectedYear!, _selectedMonth! + 1, 0).day;
    return List.generate(daysInMonth, (index) => index + 1);
  }

  List<int> get _months => List.generate(12, (index) => index + 1);

  List<int> get _years {
    final currentYear = DateTime.now().year;
    return List.generate(100, (index) => currentYear - index);
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4',
      'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8',
      'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12',
    ];
    return monthNames[month - 1];
  }

  void _updateDate() {
    if (_selectedDay != null && _selectedMonth != null && _selectedYear != null) {
      // Validate day in month
      final daysInMonth = DateTime(_selectedYear!, _selectedMonth! + 1, 0).day;
      if (_selectedDay! > daysInMonth) {
        _selectedDay = daysInMonth;
      }
      
      final date = DateTime(_selectedYear!, _selectedMonth!, _selectedDay!);
      widget.onDateChanged(date);
    }
  }

  bool get _isValid => _selectedDay != null && _selectedMonth != null && _selectedYear != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ngày sinh *',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Day
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<int>(
                value: _selectedDay,
                decoration: const InputDecoration(
                  labelText: 'Ngày',
                  border: OutlineInputBorder(),
                ),
                items: _days.map((day) {
                  return DropdownMenuItem(
                    value: day,
                    child: Text(day.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDay = value;
                    _updateDate();
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Chọn ngày';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            
            // Month
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<int>(
                value: _selectedMonth,
                decoration: const InputDecoration(
                  labelText: 'Tháng',
                  border: OutlineInputBorder(),
                ),
                items: _months.map((month) {
                  return DropdownMenuItem(
                    value: month,
                    child: Text(_getMonthName(month)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMonth = value;
                    _updateDate();
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Chọn tháng';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            
            // Year
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<int>(
                value: _selectedYear,
                decoration: const InputDecoration(
                  labelText: 'Năm',
                  border: OutlineInputBorder(),
                ),
                items: _years.map((year) {
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedYear = value;
                    _updateDate();
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Chọn năm';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        if (!_isValid)
          const Padding(
            padding: EdgeInsets.only(top: 8, left: 12),
            child: Text(
              'Vui lòng chọn ngày sinh',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}