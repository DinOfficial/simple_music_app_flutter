import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:simple_music_app_flutter/model/song_model.dart';

import '../widget/player_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Song> _playList = [
    Song(
      songName: '3-second synth melody',
      artistName: 'samplelib ',
      coverImg:
          'https://images.pexels.com/photos/2170729/pexels-photo-2170729.jpeg?cs=srgb&dl=pexels-olof-nyman-366625-2170729.jpg&fm=jpg',
      songUrl: 'https://samplelib.com/lib/preview/mp3/sample-3s.mp3',
      durationSeconds: 3,
    ),
    Song(
      songName: '6-second synth melody',
      artistName: 'samplelib ',
      coverImg:
          'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/ghosts-cd-cover-template-design-588174bffe0bcb491737d700db8e77df_screen.jpg?ts=1737128722',
      songUrl: 'https://samplelib.com/lib/preview/mp3/sample-6s.mp3',
      durationSeconds: 6,
    ),
    Song(
      songName: '9-second melody ',
      artistName: 'samplelib ',
      coverImg:
          'https://www.designformusic.com/wp-content/uploads/2018/11/trailer-tension-album-cover-3d-design-1000x1000.jpg',
      songUrl: 'https://samplelib.com/lib/preview/mp3/sample-9s.mp3',
      durationSeconds: 9,
    ),
    Song(
      songName: '12-second melody ',
      artistName: 'samplelib ',
      coverImg:
          'https://www.parmarecordings.com/parmaweb/wp-content/uploads/2021/03/RR8051_The-Travelled-Road.jpg',
      songUrl: 'https://samplelib.com/lib/preview/mp3/sample-12s.mp3',
      durationSeconds: 12,
    ),
    Song(
      songName: '15 seconds of awesome music ',
      artistName: 'samplelib ',
      coverImg:
          'https://i.pinimg.com/736x/fd/57/43/fd574304815b6a49c227c6248d66050c.jpg',
      songUrl: 'https://samplelib.com/lib/preview/mp3/sample-15s.mp3',
      durationSeconds: 15,
    ),
  ];

  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  Future<void> _playSong(int index) async {
    await _audioPlayer.stop();
    _currentIndex = index;
    final song = _playList[index];
    setState(() {
      _duration = Duration.zero;
      _position = Duration.zero;
    });

    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(_playList[index].songUrl));
  }

  Future<void> _next() async {
    final int next = (_currentIndex + 1) % _playList.length;
    await _playSong(next);
  }

  Future<void> _previous() async {
    final int previous =
        (_currentIndex - 1 + _playList.length) % _playList.length;
    await _playSong(previous);
  }

  Future<void> _togglePlayer() async {
    if (_audioPlayer.source == null) {
      await _playSong(_currentIndex);
    } else if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  void _listenToPlay() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) => _next());
  }

  @override
  void initState() {
    _listenToPlay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text('Simple Music App', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            PlayerCard(
              song: _playList[_currentIndex],
              duration: _duration,
              position: _position,
              isPlaying: _isPlaying,
              onNext: _next,
              onPrevious: _previous,
              togglePlayer: _togglePlayer,
              onSeek: (seconds) {
                _audioPlayer.seek(Duration(seconds: seconds.toInt()));
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.playlist_play_sharp,
                  color: Colors.white70,
                  size: 28,
                ),
                SizedBox(width: 8),
                Text(
                  'Play List',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _playList.length,
                itemBuilder: (context, index) {
                  Song song = _playList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      song.songName,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      song.artistName,
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.play_circle,
                      color: Colors.white70,
                      size: 28,
                    ),
                    onTap: () => _playSong(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
