import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const SpotifyExerciseApp());
}

class SpotifyExerciseApp extends StatelessWidget {
  const SpotifyExerciseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spotify Carousel Exercise',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const SpotifyHomeScreen(),
    );
  }
}

class SpotifyHomeScreen extends StatefulWidget {
  const SpotifyHomeScreen({super.key});

  @override
  State<SpotifyHomeScreen> createState() => _SpotifyHomeScreenState();
}

class _SpotifyHomeScreenState extends State<SpotifyHomeScreen> {
  int _currentIndex = 0;

  // Data Album / Song
  final List albums = [
    {
      'title': 'Midnight Memories',
      'artist': 'One Direction',
      'cover': 'https://picsum.photos/id/10/400/400',
    },
    {
      'title': 'Starboy',
      'artist': 'The Weeknd',
      'cover': 'https://picsum.photos/id/20/400/400',
    },
    {
      'title': 'Future Nostalgia',
      'artist': 'Dua Lipa',
      'cover': 'https://picsum.photos/id/30/400/400',
    },
    {
      'title': 'AM',
      'artist': 'Arctic Monkeys',
      'cover': 'https://picsum.photos/id/40/400/400',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Text(
                'Recently Played',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CarouselSlider.builder(
              itemCount: albums.length,
              options: CarouselOptions(
                height: 380,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                viewportFraction: 0.75,
                aspectRatio: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIndex) {
                final item = albums[index];
                return GestureDetector(
                  // KETIKA KARTU DIKLIK, BERPINDAH KE HALAMAN PLAYER SCREEN
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(songData: item),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFF282828),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.network(
                              item['cover']!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.music_note, size: 50)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['artist']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: albums.asMap().entries.map((entry) {
                return Container(
                  width: _currentIndex == entry.key ? 12.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? const Color(0xFF1DB954)
                        : Colors.white24,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// HALAMAN BARU: PLAYER SCREEN (TAMPILAN LAGU DIPUTAR)
// ==========================================
class PlayerScreen extends StatefulWidget {
  final Map<String, String> songData;

  const PlayerScreen({super.key, required this.songData});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool isPlaying = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 30),
          onPressed: () => Navigator.pop(context), // Kembali ke halaman utama
        ),
        title: const Text(
          'Playing from Recently Played',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cover Album Besar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.songData['cover']!,
                height: 300,
                width: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.music_note, size: 100),
              ),
            ),
            const SizedBox(height: 40),
            
            // Judul & Artis
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.songData['title']!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.songData['artist']!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.favorite, color: Color(0xFF1DB954)),
              ],
            ),
            const SizedBox(height: 20),

            // Progress Bar (Slider Durasi Lagu)
            Slider(
              value: 1.22,
              min: 0.0,
              max: 3.45,
              activeColor: Colors.white,
              inactiveColor: Colors.grey.withValues(alpha: 0.4),
              onChanged: (value) {},
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1:22', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('3:45', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Kontrol Musik (Play, Pause, Skip, dll)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.shuffle, color: Colors.grey, size: 24),
                const Icon(Icons.skip_previous, color: Colors.white, size: 36),
                // Tombol Play / Pause Interaktif
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    size: 64,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                ),
                const Icon(Icons.skip_next, color: Colors.white, size: 36),
                const Icon(Icons.repeat, color: Colors.grey, size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}