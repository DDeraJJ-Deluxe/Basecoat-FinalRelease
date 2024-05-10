import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

//Basic Calendar using package table_calendar
class _CalendarState extends State<Calendar> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, String> _notes = {};

  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();

  }

  //Checks if there are notes for the day,  if so it will load them.
  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {

      String? notesJson = prefs.getString('saved_notes');
      if (notesJson != null) {
        _notes = Map<String, String>.from(jsonDecode(notesJson));
      }
    });
  }

  //Saves notes
  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_notes', jsonEncode(_notes));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey.shade100,
      body: Column(
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime(1987),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _noteController.text = _notes[_selectedDay.toString().split(' ')[0]] ?? '';
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          //Display notes at the bottom left and prompt for user input.
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Miniatures Painted', style: Theme.of(context).textTheme.titleLarge),
                    TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(hintText: 'What have you worked on today?'),
                      onChanged: (value) {
                        if (_selectedDay != null) {
                          _notes[_selectedDay.toString().split(' ')[0]] = value;
                          _saveNotes();
                        }
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}


