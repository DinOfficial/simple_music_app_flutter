import 'package:flutter/material.dart';
import 'package:simple_music_app_flutter/model/song_model.dart';

class PlayerCard extends StatefulWidget {
  final Song song;
  final Duration duration;
  final Duration position;
  final bool isPlaying;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback togglePlayer;
  final Function(double) onSeek;

  const PlayerCard({super.key, required this.song, required this.duration, required this.position, required this.isPlaying, required this.onNext, required this.onPrevious, required this.togglePlayer, required this.onSeek,
  });

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  String _formateDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds.remainder(60);
    return "$minutes: ${seconds.toString().padLeft(2, "0")}";
  }
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: 210,
            child: Image.network(
              widget.song.coverImg,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: 210,
            decoration: BoxDecoration(color: Colors.black54),
          ),
          Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            height: 210,
            child: Column(
              children: [
                Text(
                  widget.song.songName,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  overflow:TextOverflow.ellipsis,
                ),
                Text(
                  widget.song.artistName,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  overflow:TextOverflow.ellipsis,
                ),
                Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.white38,
                  value: widget.position.inSeconds.toDouble(),
                  min: 0,
                  max: widget.duration.inSeconds.toDouble() + 1.0,
                  onChanged: (value) {
                    widget.onSeek(value);
                  },
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        '${_formateDuration(widget.position)} / ${_formateDuration(widget.duration)}',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: widget.onPrevious,
                          icon: Icon(
                            Icons.skip_previous_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: widget.togglePlayer ,
                          icon: Icon(
                            widget.isPlaying
                                ? Icons.pause_circle
                                : Icons.play_circle,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: widget.onNext,
                          icon: Icon(
                            Icons.skip_next_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
