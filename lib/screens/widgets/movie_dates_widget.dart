import 'package:flutter/material.dart';

class MovieDatesWidget extends StatefulWidget {
  const MovieDatesWidget({
    super.key,
    required this.onSelectionChanged,
  });

  final Function(String, String) onSelectionChanged;

  @override
  State<MovieDatesWidget> createState() => _MovieDatesWidgetState();
}

class _MovieDatesWidgetState extends State<MovieDatesWidget> {
  int _selectedDateIndex = -1; 
  int _selectedTimeIndex = -1; 

  List<Map<String, String>> listDates = [];
  List<String> listHours = [];

  @override
  void initState() {
    super.initState();
    listDates = generateNextDates();
    listHours = generateNextHours();
  }

  String getMonthString(int month) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return months[month - 1];
  }

  List<Map<String, String>> generateNextDates() {
    final now = DateTime.now();
    List<Map<String, String>> dates = [];

    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      String month = getMonthString(date.month);
      dates.add({
        'day': date.day.toString(),
        'month': month
      });
    }

    return dates;
  }

  List<String> generateNextHours() {
    List<String> hours = ['10:00 AM', '1:00 PM', '4:00 PM', '6:00 PM', '7:00 PM'];
    return hours;
  }

  void notifySelection() {
    final selectedDate = _selectedDateIndex != -1 ? listDates[_selectedDateIndex] : null;
    final selectedTime = _selectedTimeIndex != -1 ? listHours[_selectedTimeIndex] : null;

    if (selectedDate != null && selectedTime != null) {
      widget.onSelectionChanged('${selectedDate['day']} ${selectedDate['month']}', selectedTime);
    } else {
      widget.onSelectionChanged('', ''); 
    }
  }

  @override
Widget build(BuildContext context) {
   final size = MediaQuery.of(context).size.height * 0.30;

  return Expanded(
    child: Column(
      children: [
        SizedBox(
          height: size * 0.10,
          child: const Text(
              'Selecciona Fecha y Hora',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical:12.0),
          child: SizedBox(
            height: size * 0.50, 
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listDates.length,
              itemBuilder: (context, index) {
                final date = listDates[index];
                final isSelected = index == _selectedDateIndex;
              
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedDateIndex == index) {
                        _selectedDateIndex = -1; 
                      } else {
                        _selectedDateIndex = index;
                      }
                      notifySelection();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: MovieDateCard(
                      day: date['day']!,
                      month: date['month']!,
                      isSelected: isSelected,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            height: size * 0.15, 
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listHours.length,
              itemBuilder: (context, index) {
                final hour = listHours[index];
                final isSelected = index == _selectedTimeIndex;
              
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedTimeIndex == index) {
                        _selectedTimeIndex = -1;
                      } else {
                        _selectedTimeIndex = index;
                      }
                      notifySelection();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: MovieHourCard(
                      hour: hour,
                      isSelected: isSelected,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}
}

class MovieDateCard extends StatelessWidget {
  const MovieDateCard({
    super.key,
    required this.day,
    required this.month,
    required this.isSelected,
  });

  final String day;
  final String month;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorContainer = isSelected ? const Color(0xFFE50914) : Colors.black26   ;
    final colorText = isSelected ? Colors.black : Colors.grey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
      child: Container(
        width: 55, 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorContainer,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              month,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieHourCard extends StatelessWidget {
  const MovieHourCard({
    super.key,
    required this.hour,
    required this.isSelected,
  });

  final String hour;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorText = isSelected ? const Color(0xFFE50914) : Colors.grey;
    final colorBorder = isSelected ? const Color(0xFFE50914) : Colors.transparent;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black26,
        border: Border.all(
          color: colorBorder,
        ),
      ),
      child: Center(
        child: Text(
          hour,
          style: TextStyle(
            color: colorText,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
