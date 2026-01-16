import 'package:flutter/material.dart';

class DateOfBirthField extends StatefulWidget {
  final DateTime? initialDate;
  final void Function(DateTime?) onChanged;

  const DateOfBirthField({super.key, this.initialDate, required this.onChanged});

  @override
  State<DateOfBirthField> createState() => _DateOfBirthFieldState();
}

class _DateOfBirthFieldState extends State<DateOfBirthField> {
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

  void _updateDate() {
    if (_selectedDay != null && _selectedMonth != null && _selectedYear != null) {
      try {
        final date = DateTime(_selectedYear!, _selectedMonth!, _selectedDay!);
        widget.onChanged(date);
      } catch (e) {
        widget.onChanged(null);
      }
    } else {
      widget.onChanged(null);
    }
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(100, (index) => currentYear - index);
    final months = List.generate(12, (index) => index + 1);

    // Calculate days based on selected month and year
    int maxDays = 31;
    if (_selectedMonth != null && _selectedYear != null) {
      maxDays = _getDaysInMonth(_selectedYear!, _selectedMonth!);
    } else if (_selectedMonth != null) {
      maxDays = _getDaysInMonth(currentYear, _selectedMonth!);
    }
    final days = List.generate(maxDays, (index) => index + 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ngày sinh', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            // Day dropdown
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<int>(
                value: _selectedDay != null && _selectedDay! <= maxDays ? _selectedDay : null,
                decoration: const InputDecoration(labelText: 'Ngày', border: OutlineInputBorder()),
                items: days.map((day) {
                  return DropdownMenuItem(value: day, child: Text(day.toString().padLeft(2, '0')));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDay = value;
                    _updateDate();
                  });
                },
                validator: (value) {
                  if (value == null) return 'Chọn ngày';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),

            // Month dropdown
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<int>(
                value: _selectedMonth,
                decoration: const InputDecoration(labelText: 'Tháng', border: OutlineInputBorder()),
                items: months.map((month) {
                  return DropdownMenuItem(
                    value: month,
                    child: Text(month.toString().padLeft(2, '0')),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMonth = value;
                    // Reset day if invalid for new month
                    if (_selectedDay != null && _selectedYear != null) {
                      final maxDaysInMonth = _getDaysInMonth(_selectedYear!, value!);
                      if (_selectedDay! > maxDaysInMonth) {
                        _selectedDay = maxDaysInMonth;
                      }
                    }
                    _updateDate();
                  });
                },
                validator: (value) {
                  if (value == null) return 'Chọn tháng';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),

            // Year dropdown
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<int>(
                value: _selectedYear,
                decoration: const InputDecoration(labelText: 'Năm', border: OutlineInputBorder()),
                items: years.map((year) {
                  return DropdownMenuItem(value: year, child: Text(year.toString()));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedYear = value;
                    // Reset day if invalid for new year (leap year handling)
                    if (_selectedDay != null && _selectedMonth != null) {
                      final maxDaysInMonth = _getDaysInMonth(value!, _selectedMonth!);
                      if (_selectedDay! > maxDaysInMonth) {
                        _selectedDay = maxDaysInMonth;
                      }
                    }
                    _updateDate();
                  });
                },
                validator: (value) {
                  if (value == null) return 'Chọn năm';
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
