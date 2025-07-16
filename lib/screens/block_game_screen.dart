import 'package:flutter/material.dart';
import 'dart:math';

class BlockGameScreen extends StatefulWidget {
  const BlockGameScreen({super.key});

  @override
  State<BlockGameScreen> createState() => _BlockGameScreenState();
}

class _BlockGameScreenState extends State<BlockGameScreen> {
  static const int _gridSize = 30; // Size of each block in pixels
  static const int _gameWidth = 300;
  static const int _gameHeight = 600;

  List<List<Color?>> _grid = List.generate(
    _gameHeight ~/ _gridSize,
    (_) => List.generate(_gameWidth ~/ _gridSize, (_) => null),
  );

  int _score = 0;
  bool _gameOver = false;
  Offset _currentBlockPosition = Offset.zero;
  Color _currentBlockColor = Colors.transparent;
  List<Color> _colors = [
    const Color(0xFFFF6F61),
    const Color(0xFFFFA500),
    const Color(0xFFFFD700),
    const Color(0xFFADFF2F),
    const Color(0xFF00CED1),
  ];
  late Ticker _ticker; // For animation

  // Warna Neon dan Background untuk tema Cyberpunk
  static const Color neonBlue = Color(0xFF00FFFF); // Cyan
  static const Color neonPink = Color(0xFFFF00FF); // Magenta
  static const Color neonGreen = Color(0xFF00FF00); // Lime Green
  static const Color darkBackground = Color(0xFF1A1A2E); // Dark Blue/Purple
  static const Color lightSurface = Color(0xFF2C2C4A); // Slightly lighter surface

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _startGame() {
    _score = 0;
    _gameOver = false;
    _grid = List.generate(
      _gameHeight ~/ _gridSize,
      (_) => List.generate(_gameWidth ~/ _gridSize, (_) => null),
    );
    _createNewBlock();
    _ticker = Ticker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (_gameOver) return;

    // Simulate block falling
    setState(() {
      int nextY = (_currentBlockPosition.dy + _gridSize).toInt();
      if (nextY >= _gameHeight || _isCollision(Offset(_currentBlockPosition.dx, nextY.toDouble()))) {
        _placeBlock();
        _checkAndClearRows();
        _createNewBlock();
      } else {
        _currentBlockPosition = Offset(_currentBlockPosition.dx, nextY.toDouble());
      }
    });
  }

  void _createNewBlock() {
    if (_gameOver) return;

    final random = Random();
    _currentBlockColor = _colors[random.nextInt(_colors.length)];
    _currentBlockPosition = Offset(
      (random.nextInt(_gameWidth ~/ _gridSize) * _gridSize).toDouble(),
      0,
    );

    // Check for game over condition (new block immediately collides)
    if (_isCollision(_currentBlockPosition)) {
      setState(() {
        _gameOver = true;
      });
      _ticker.stop();
      _showGameOverDialog();
    }
  }

  bool _isCollision(Offset position) {
    int gridX = (position.dx / _gridSize).floor();
    int gridY = (position.dy / _gridSize).floor();

    if (gridX < 0 || gridX >= _grid[0].length || gridY < 0 || gridY >= _grid.length) {
      return true; // Out of bounds
    }
    return _grid[gridY][gridX] != null;
  }

  void _placeBlock() {
    int gridX = (_currentBlockPosition.dx / _gridSize).floor();
    int gridY = (_currentBlockPosition.dy / _gridSize).floor();
    _grid[gridY][gridX] = _currentBlockColor;
  }

  void _checkAndClearRows() {
    List<int> rowsToClear = [];
    for (int r = 0; r < _grid.length; r++) {
      bool rowIsFull = true;
      for (int c = 0; c < _grid[r].length; c++) {
        if (_grid[r][c] == null) {
          rowIsFull = false;
          break;
        }
      }
      if (rowIsFull) {
        rowsToClear.add(r);
      }
    }

    if (rowsToClear.isNotEmpty) {
      setState(() {
        _score += rowsToClear.length * 10; // Score for cleared rows
        for (int r in rowsToClear.reversed) {
          _grid.removeAt(r);
          _grid.insert(0, List.generate(_gameWidth ~/ _gridSize, (_) => null)); // Add empty row at top
        }
      });
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: darkBackground, // Cyberpunk background for dialog
        title: Text('Game Over!', style: TextStyle(color: neonPink, shadows: [Shadow(color: neonPink.withOpacity(0.8), blurRadius: 10)])),
        content: Text('Skor Anda: $_score', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startGame(); // Restart game
            },
            child: Text('Main Lagi', style: TextStyle(color: neonGreen)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to home screen
            },
            child: Text('Kembali ke Home', style: TextStyle(color: neonBlue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Game Block Blast',
          style: TextStyle(
            color: neonBlue,
            shadows: [
              Shadow(
                color: neonBlue.withOpacity(0.8),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
        backgroundColor: darkBackground,
        foregroundColor: neonBlue,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [darkBackground, Color(0xFF0F0F1A)], // Darker gradient for cyberpunk feel
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/gambar1.jpg'), // Add a cyberpunk background image
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken), // Darken the image
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: _gameWidth.toDouble(),
                height: _gameHeight.toDouble(),
                decoration: BoxDecoration(
                  color: lightSurface, // Base color for neumorphic element
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    // Darker shadow for depth
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      offset: const Offset(8, 8),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                    // Lighter shadow for highlight
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      offset: const Offset(-8, -8),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                    // Neon glow effect
                    BoxShadow(
                      color: neonBlue.withOpacity(0.5),
                      blurRadius: 25,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(color: neonPink.withOpacity(0.3), width: 2), // Subtle neon border
                ),
                child: Stack(
                  children: [
                    // Render existing blocks in the grid
                    for (int r = 0; r < _grid.length; r++)
                      for (int c = 0; c < _grid[r].length; c++)
                        if (_grid[r][c] != null)
                          Positioned(
                            left: (c * _gridSize).toDouble(),
                            top: (r * _gridSize).toDouble(),
                            child: Container(
                              width: _gridSize.toDouble(),
                              height: _gridSize.toDouble(),
                              color: _grid[r][c],
                              // border: Border.all(color: Colors.black, width: 0.5), // Optional border
                            ),
                          ),
                    // Render the falling block
                    if (!_gameOver)
                      Positioned(
                        left: _currentBlockPosition.dx,
                        top: _currentBlockPosition.dy,
                        child: Container(
                          width: _gridSize.toDouble(),
                          height: _gridSize.toDouble(),
                          color: _currentBlockColor,
                          // border: Border.all(color: Colors.black, width: 0.5), // Optional border
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Score: $_score',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: neonGreen, // Neon color for score
                  shadows: [
                    Shadow(
                      color: neonGreen.withOpacity(0.8),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [neonPink, neonBlue], // Neon gradient for button
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: neonPink.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Go back to home
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Make button transparent to show gradient
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Tombol lebih bulat
                    ),
                    elevation: 0, // Remove default elevation
                  ),
                  icon: const Icon(Icons.home, size: 28),
                  label: const Text('Kembali ke Home', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Ticker for game loop
class Ticker {
  final Function(Duration elapsed) _onTick;
  bool _running = false;
  Duration _lastElapsed = Duration.zero;
  late final Stopwatch _stopwatch;

  Ticker(this._onTick) {
    _stopwatch = Stopwatch();
  }

  void start() {
    if (_running) return;
    _running = true;
    _stopwatch.start();
    _tick();
  }

  void stop() {
    _running = false;
    _stopwatch.stop();
  }

  void _tick() {
    if (!_running) return;

    final currentElapsed = _stopwatch.elapsed;
    final delta = currentElapsed - _lastElapsed;
    _lastElapsed = currentElapsed;

    // Adjust this value to control game speed (e.g., 500ms for 0.5s fall)
    const Duration tickInterval = Duration(milliseconds: 500);

    if (delta >= tickInterval) {
      _onTick(currentElapsed);
      _lastElapsed = currentElapsed; // Reset last elapsed to current for next tick
    }

    // Request next frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _tick());
  }

  void dispose() {
    stop();
  }
}