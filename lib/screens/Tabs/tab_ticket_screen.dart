import 'package:flutter/material.dart';
import 'package:the_movie_data_base/models/seats.dart';
import 'package:the_movie_data_base/screens/pages/summary_screen_page.dart';
import 'package:the_movie_data_base/screens/widgets/movie_billboard_widget.dart';
import 'package:the_movie_data_base/screens/widgets/movie_dates_widget.dart';
import 'package:the_movie_data_base/screens/widgets/movie_seat_box.dart';
import 'package:the_movie_data_base/services/api.service.dart';

class TabTicketScreen extends StatefulWidget {
  final dynamic selectedMovie;

  const TabTicketScreen({
    Key? key,
    this.selectedMovie,
  }) : super(key: key);

  @override
  _TabTicketScreenState createState() => _TabTicketScreenState();
}

class _TabTicketScreenState extends State<TabTicketScreen> {
  dynamic _selectedMovie;
  String? _selectedTime;
  String? _selectedDate;
  List<String>? _selectedSeats;
  final Map<String, Map<String, Map<String, List<List<Seat>>>>> _movieSeatMap = {};
  final ApiService apiService = ApiService();
  late List<dynamic> allRecentData = [];
  final List<dynamic> movieData = [];
  bool _isSeatSelected = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedMovie != null) {
      _selectedMovie = widget.selectedMovie;
    }
    _fetchActualMovies();
    _initializeSeats();
  }

  Future<void> _fetchActualMovies() async {
    try {
      final movieData = await apiService.fetchPopularMovies();
      setState(() {
        allRecentData = movieData;
      });
      _initializeSeats();
    } catch (e) {
      print('Error fetching recent data: $e');
      // Manejar el error mostrando un AlertDialog o SnackBar al usuario
    }
  }

  void _initializeSeats() {
    final times = ['10:00 AM', '1:00 PM', '4:00 PM', '6:00 PM', '7:00 PM'];
    final dates = generateNextDates();

    for (var element in allRecentData) {
      String movieId = element['id'].toString();
      _movieSeatMap[movieId] = {};

      for (var date in dates) {
        String dateString = "${date['day']} ${date['month']}";
        _movieSeatMap[movieId]![dateString] = {};

        for (var time in times) {
          _movieSeatMap[movieId]![dateString]![time] = _generateSeats(); // Generar los asientos para cada película, fecha y horario
        }
      }
    }
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

  List<List<Seat>> _generateSeats() {
    // Se generan los asientos para cada sección de la sala
    List<List<Seat>> sections = [];
    List<String> sectionNames = ['A', 'B', 'C', 'D', 'E', 'F'];

    // Secciones A, B, C, D: 3 filas x 3 columnas
    for (int section = 0; section < 4; section++) {
      List<Seat> sectionSeats = [];
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          String seatId = '${sectionNames[section]}${i * 3 + j + 1}';
          sectionSeats.add(Seat(
            id: seatId,
            isHidden: false,
            isOccupied: false,
          ));
        }
      }
      sections.add(sectionSeats);
    }

    // Secciones E, F: 3 filas x 6 columnas
    for (int section = 4; section < 6; section++) {
      List<Seat> sectionSeats = [];
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 6; j++) {
          String seatId = '${sectionNames[section]}${i * 6 + j + 1}';
          sectionSeats.add(Seat(
            id: seatId,
            isHidden: false,
            isOccupied: false,
          ));
        }
      }
      sections.add(sectionSeats);
    }

    return sections;
  }

  List<List<Seat>> _getSeatsForSelectedMovieDateAndTime() {
    if (_selectedMovie == null || _selectedTime == null || _selectedDate == null) {
      return [];
    }
    final movieId = _selectedMovie['id'];
    return _movieSeatMap[movieId.toString()]?[_selectedDate.toString()]?[_selectedTime.toString()] ?? [];
  }

  void _onSeatSelected() {
    setState(() {
      if (_selectedMovie != null && _selectedDate != null && _selectedTime != null) {
        _isSeatSelected = _getSeatsForSelectedMovieDateAndTime().any(
          (section) => section.any((seat) => seat.isSelected),
        );
      } else {
        _isSeatSelected = false;
      }
    });
  }

  void _onSelectionChanged(String selectedDate, String selectedTime) {
    setState(() {
      _selectedDate = selectedDate.isEmpty ? null : selectedDate;
      _selectedTime = selectedTime.isEmpty ? null : selectedTime;
    });
    _onSeatSelected();
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = _selectedMovie != null && _selectedDate != null && _selectedTime != null && _isSeatSelected;

    return Scaffold(
  appBar: AppBar(
    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    title: Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          _selectedMovie != null ? _selectedMovie['title'] : 'Seleccionar Película',
          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ),
  body: Container(
    color: Color.fromRGBO(29, 29, 39, 1), // Agrega el color de fondo deseado
    child: Column(
      children: [
        if (_selectedMovie == null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _buildMovieSelection(),
            ),
          )
        else
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 220, // Altura fija para el contenedor de fechas
                  color: Color.fromRGBO(29, 29, 39, 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _buildTimeSelection(),
                  ),
                ),
                // Contenedor de selección de asientos
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(38, 39, 48, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    // Color diferente para identificación
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: _buildSeatSelection(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Precio total',
                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    Text(
                                      '₡ ${(_selectedSeats?.length ?? 0) * 5000}',
                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: isButtonEnabled
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SummaryScreen(
                                                selectedMovie: _selectedMovie,
                                                selectedDate: _selectedDate!,
                                                selectedTime: _selectedTime!,
                                                selectedSeats: _selectedSeats!,
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  child: const Text('Comprar Tiquetes', style: TextStyle(fontSize: 18)),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Color(0xFFE50914)),
                                    foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                      if (states.contains(MaterialState.disabled)) {
                                      return Colors.grey; // Color del texto cuando el botón está deshabilitado
                                    }
                                      return Colors.white; // Color del texto cuando el botón está habilitado
                                  }),
                                ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  ),
);
}

  Widget _buildMovieSelection() {
    return MovieBillboardWidget(
      movies: allRecentData,
      onSelectMovie: (movie) {
        setState(() {
          _selectedMovie = movie;
        });
      },
    );
  }

  Widget _buildTimeSelection() {
    return MovieDatesWidget(
      onSelectionChanged: (selectedDate, selectedTime) {
        _onSelectionChanged(selectedDate, selectedTime);
      },
    );
  }

  Widget _buildSeatSelection() {
    final seats = _getSeatsForSelectedMovieDateAndTime();
    if (seats.isEmpty) {
      return Center(
        child: Text(
          _selectedMovie == null
              ? 'Por favor, seleccione una película y un horario.'
              : 'Por favor, seleccione un horario.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return MovieSeats(
      seats: seats,
      onSeatSelected: () {
        _onSeatSelected();
        final selectedSeats = MovieSeats.getSelectedSeats(seats);
        setState(() {
          _selectedSeats = selectedSeats;
        });
        print('Selected Seats: $selectedSeats');
      },
    );
  }
}
