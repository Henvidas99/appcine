import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_movie_data_base/models/seats.dart';
import 'package:the_movie_data_base/screens/pages/summary_screen_page.dart';
import 'package:the_movie_data_base/screens/widgets/movie_billboard_widget.dart';
import 'package:the_movie_data_base/screens/widgets/movie_dates_widget.dart';
import 'package:the_movie_data_base/screens/widgets/movie_seat_box.dart';
import 'package:the_movie_data_base/services/api.service.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_data_base/provider/seat_selection_provider.dart';
import 'package:the_movie_data_base/provider/movies_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class TabTicketScreen extends StatefulWidget {
  final dynamic selectedMovie;
  final bool band;

  const TabTicketScreen({
    super.key,
    this.selectedMovie,
    this.band = false
  });

  @override
  // ignore: library_private_types_in_public_api
  _TabTicketScreenState createState() => _TabTicketScreenState();
}

class _TabTicketScreenState extends State<TabTicketScreen> {
  dynamic _selectedMovie;
  String? _selectedTime;
  String? _selectedDate;
  final ApiService apiService = ApiService();
  late List<dynamic> allRecentData = [];
  DateTime? lastPressed;

  @override
  void initState() {
    super.initState();
    if (widget.selectedMovie != null) {
      _selectedMovie = widget.selectedMovie;
    }
    BackButtonInterceptor.add(interceptor);
  }

  @override
  void dispose() {
    super.dispose();
    BackButtonInterceptor.remove(interceptor);
  }

  bool interceptor(bool btnEvent, RouteInfo info){
    if (BackButtonInterceptor.getCurrentNavigatorRouteName(context) != '/') {
      return false;
     }
    else if ( _selectedMovie != null) {
     setState(() {
          _selectedMovie = null;
      });
    return true;
    }  
    else{
      final now = DateTime.now();
      if(lastPressed == null || now.difference(lastPressed!) > const Duration(seconds: 3)){
        lastPressed = now;
      final snackBar = SnackBar(    
          backgroundColor: Colors.blueGrey,
          margin: const EdgeInsets.only(bottom: 60.0, left: 40, right: 40),
          content: Container(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              ),
              child: const Center(
                child: Text(
                  'Presiona nuevamente para salir',
                   style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
              ),
              ),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            );
            // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return true;
      }
     }
          return false;
     
  }

  void _initializeSeats() {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    allRecentData = moviesProvider.recentMoviesData;

    final seatSelectionProvider = Provider.of<SeatSelectionProvider>(context, listen: false);
    final times = ['10:00 AM', '1:00 PM', '4:00 PM', '6:00 PM', '7:00 PM'];
    final dates = generateNextDates();

    for (var element in allRecentData) {
      String movieId = element['id'].toString();
      for (var date in dates) {
        String dateString = "${date['day']} ${date['month']}";
        for (var time in times) {
          seatSelectionProvider.initializeSeats(movieId, dateString, time, _generateSeats());
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

  List<Seat> _generateSeats() {
    List<Seat> seats = [];
    List<String> sectionNames = ['A', 'B', 'C', 'D', 'E', 'F'];

    for (int section = 0; section < 4; section++) {
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          String seatId = '${sectionNames[section]}${i * 3 + j + 1}';
          seats.add(Seat(
            id: seatId,
            isHidden: false,
            isOccupied: false,
          ));
        }
      }
    }

    for (int section = 4; section < 6; section++) {
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 6; j++) {
          String seatId = '${sectionNames[section]}${i * 6 + j + 1}';
          seats.add(Seat(
            id: seatId,
            isHidden: false,
            isOccupied: false,
          ));
        }
      }
    }

    return seats;
  }

  List<Seat> _getSeatsForSelectedMovieDateAndTime() {
    if (_selectedMovie == null || _selectedTime == null || _selectedDate == null) {
      return [];
    }
    final movieId = _selectedMovie['id'];
    final seatSelectionProvider = Provider.of<SeatSelectionProvider>(context, listen: false);
    return seatSelectionProvider.getSeats(movieId.toString(), _selectedDate!, _selectedTime!);
  }

  void _onSelectionChanged(String selectedDate, String selectedTime) {
    final seatSelectionProvider = Provider.of<SeatSelectionProvider>(context, listen: false);
    seatSelectionProvider.clearSelectedSeats();
    
    setState(() {
      _selectedDate = selectedDate.isEmpty ? null : selectedDate;
      _selectedTime = selectedTime.isEmpty ? null : selectedTime;
    });
  }

  Future<void> saveSelectedSeats(List<String> seats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedSeats', seats);
  }

  @override
  Widget build(BuildContext context) {
    final seatSelectionProvider = Provider.of<SeatSelectionProvider>(context);
    final moviesProvider = Provider.of<MoviesProvider>(context);
    final size = MediaQuery.of(context).size.height;

    saveSelectedSeats(seatSelectionProvider.selectedSeats);

    allRecentData = moviesProvider.recentMoviesData;
    _initializeSeats();

    bool isButtonEnabled = _selectedMovie != null && _selectedDate != null && _selectedTime != null && seatSelectionProvider.selectedSeats.isNotEmpty;

    return Scaffold(
      appBar: AppBar(   
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        toolbarHeight: size * 0.08,
        leading: _selectedMovie != null
        ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24,),
          onPressed: () {
            if(widget.band) {
              Navigator.of(context).pop();
            } else {
              setState(() {
                _selectedMovie = null;
              });
            }
          },
        )
        : null,
        title: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          child: Text(
            _selectedMovie != null ? _selectedMovie['title'] : 'Seleccionar Película',
            style: GoogleFonts.oswald(
              textStyle: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white, ),
              ),
            ),
          ),
        ),
      ),
    body: Container(
      color: const Color.fromRGBO(29, 29, 39, 1), 
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
                    height: size * 0.30, 
                    color: const Color.fromRGBO(29, 29, 39, 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _buildTimeSelection(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: size * 0.62, 
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
                            if(_selectedDate != null && _selectedTime != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Precio total',
                                        style: TextStyle(fontSize: 12, color: Colors.white),
                                      ),
                                      Text(
                                        '₡ ${(seatSelectionProvider.selectedSeats.length) * 5000}',
                                        style: const TextStyle(fontSize: 18, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFFE50914), Color.fromARGB(255, 23, 6, 1),],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        ),
                                      borderRadius: BorderRadius.all(Radius.circular(15),
                                      ),
                                    ),
                                    child: TextButton(
                                      onPressed: isButtonEnabled
                                          ? () {
                                              Navigator.push(
                                                context,
                                                 PageTransition(
                                                  type: PageTransitionType.scale,
                                                  reverseDuration: const Duration(milliseconds: 800),
                                                  alignment: Alignment.bottomCenter,
                                                  duration: const Duration(milliseconds: 1000),
                                                  child:SummaryScreen(
                                                    selectedMovie: _selectedMovie,
                                                    selectedMovieTitle: _selectedMovie['title'],
                                                    selectedMoviePoster:  _selectedMovie['poster_path'],
                                                    selectedDate: _selectedDate!,
                                                    selectedTime: _selectedTime!,
                                                    selectedSeats: seatSelectionProvider.selectedSeats, 
                                                  ),
                                                ),
                                              );
                                            }
                                          : null,
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                        foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                          if (states.contains(MaterialState.disabled)) {
                                          return Colors.grey; // Color del texto cuando el botón está deshabilitado
                                        }
                                          return Colors.white; // Color del texto cuando el botón está habilitado
                                      }),
                                    ),
                                      child: const Text('Reservar Tiquetes', style: TextStyle(fontSize: 18)),
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
      seats: _getSeatsForSelectedMovieDateAndTime(),
    );
  }
}
