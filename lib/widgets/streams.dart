// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';

class Stream extends StatefulWidget {
  const Stream({super.key});

  @override
  _StreamBuilder createState() => _StreamBuilder();
}

class _StreamBuilder extends State<Stream> {
  late StreamController<String> _streamController;
  final List<String> _lista = [];
  List<String> _juegos = [];
  int _seleccion = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<String>();
    _juegos = _getJuegos(_seleccion);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_juegos.isNotEmpty) {
        _streamController.sink.add(_juegos.removeAt(0));
      } else {
        timer.cancel();
      }
    });
  }

  List<String> _getJuegos(int comp) {
    switch (comp) {
      case 0:
        {
          return [
            'Assassin\'s Creed',
            'Far Cry',
            'Just Dance',
            'Prince of Persia',
            'Tom Clancy\'s franchise',
            'Watch Dogs',
            'The Crew',
            'TrackMania',
            'Trials',
            'Rayman'
          ];
        }

      case 1:
        {
          return [
            'Grand Theft Auto',
            'Red Dead',
            'Manhunt',
            'The Warriors',
            'Max Payne',
            'L.A. Noire',
            'Bully',
            'Table Tennis'
          ];
        }

      case 2:
        {
          return [
            'God of War',
            'Uncharted',
            'The Last of Us',
            'Horizon Zero Dawn',
            'Ghost of Tsushima',
            'Spider-Man'
          ];
        }

      case 3:
        {
          return ['Halo', 'Gears of War', 'Forza', 'Fable', 'Flight Simulator'];
        }

      default:
        return ['nu hay :p'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<String>(
            stream: _streamController.stream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data != null) {
                  _lista.add(snapshot.data!);
                }
                return ListView.builder(
                  itemCount: _lista.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_lista[index]),
                    );
                  },
                );
              }
            },
          ),
        ),
        FloatingActionButton(
          onPressed: () {
            _showPopupMenu(context);
          },
          child: const Icon(Icons.add),
        ),
      ],
    );
  }

  void _showPopupMenu(BuildContext context) async {
    int? selected = await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 100, 100),
      items: [
        const PopupMenuItem<int>(value: 0, child: Text('Ubisoft')),
        const PopupMenuItem<int>(value: 1, child: Text('Rockstar Games')),
        const PopupMenuItem<int>(value: 2, child: Text('Sony')),
        const PopupMenuItem<int>(value: 3, child: Text('Microsoft')),
      ],
    );
    if (selected != null) {
      setState(() {
        _seleccion = selected;
        _lista.clear();
        _juegos = _getJuegos(_seleccion);
        _timer?.cancel();
        _startTimer();
      });
    }
  }

  @override
  void dispose() {
    _streamController.close();
    _timer?.cancel();
    super.dispose();
  }
}
