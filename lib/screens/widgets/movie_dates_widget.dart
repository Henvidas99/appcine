import 'package:flutter/material.dart';

class MovieDatesWidget extends StatefulWidget {
  const MovieDatesWidget({
    Key? key,
    required this.onSelectionChanged,
  }) : super(key: key);

  final Function(String, String) onSelectionChanged;

  @override
  State<MovieDatesWidget> createState() => _MovieDatesWidgetState();
}

class _MovieDatesWidgetState extends State<MovieDatesWidget> {
  int _selectedDateIndex = -1; // Inicializar con -1 para que ninguna fecha esté seleccionada
  int _selectedTimeIndex = -1; // Inicializar con -1 para que ninguna hora esté seleccionada

  List<Map<String, String>> listDates = [];
  List<String> listHours = [];

  @override
  void initState() {
    super.initState();
    // Filtrar fechas y horas únicas
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
      widget.onSelectionChanged('', ''); // No hay selección
    }
  }

  @override
Widget build(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        'Selecciona Fecha y Hora',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      Container(
        height: 100, // Altura fija para la selección de fechas
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
                    _selectedDateIndex = -1; // Deseleccionar si ya está seleccionado
                  } else {
                    _selectedDateIndex = index;
                  }
                  notifySelection();
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
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
      Container(
        height: 50, // Altura fija para la selección de horas
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
                    _selectedTimeIndex = -1; // Deseleccionar si ya está seleccionado
                  } else {
                    _selectedTimeIndex = index;
                  }
                  notifySelection();
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: MovieHourCard(
                  hour: hour,
                  isSelected: isSelected,
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
}

class MovieDateCard extends StatelessWidget {
  const MovieDateCard({
    Key? key,
    required this.day,
    required this.month,
    required this.isSelected,
  }) : super(key: key);

  final String day;
  final String month;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorContainer = isSelected ? Color(0xFFE50914) : Colors.black12    ;
    final colorText = isSelected ? Colors.black : Colors.grey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: 55, // Ajustar el ancho para hacerlo alargado
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
              margin: const EdgeInsets.only(top: 8.0),
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
    Key? key,
    required this.hour,
    required this.isSelected,
  }) : super(key: key);

  final String hour;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorText = isSelected ? Color(0xFFE50914) : Colors.grey;
    final colorBorder = isSelected ? Color(0xFFE50914) : Colors.transparent;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black12,
        border: Border.all(
          color: colorBorder,
        ),
      ),
      child: Center(
        child: Text(
          hour,
          style: TextStyle(
            color: colorText,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

/*
  @override
  Widget build(BuildContext context) {
    final colorText = isSelected ? Colors.orange : Colors.grey;
    final colorBorder = isSelected ? Colors.orange : Colors.transparent;

    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF006BF3) : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: const Color(0xFF006BF3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black12,
                border: Border.all(
                  color: colorBorder,
                ),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  '${date.day} ${date.month}',
                  style: TextStyle(
                    color: colorText,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black12,
                border: Border.all(
                  color: colorBorder,
                ),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  date.hour,
                  style: TextStyle(
                    color: colorText,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/