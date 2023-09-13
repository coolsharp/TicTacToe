import 'package:flutter/material.dart';

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  late String _currentPlayer;

  late String _result;

  final List<String> _options = ['3x3', '4x4', '5x5', '6x6', '7x7', '8x8'];

  String _selectOption = '3x3';

  int _blockCounter = 3;

  List<String>? _boardList = List.generate(9, (index) => '');

  void _play(int index) {
    setState(() {
      if (!_checkWin() && '' == _boardList![index]) {
        _boardList![index] = _currentPlayer;

        if (_checkWin()) {
          _result = '승리 : $_currentPlayer';
        } else if (_checkEndGame()) {
          _result = '무승부';
        } else {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
          _result = '다음순서 : $_currentPlayer';
        }
      }
    });
  }

  bool _checkWin() {
    bool isWin = true;

    for (int row = 0; row < _blockCounter; row++) {
      isWin = true;
      for (int col = 0; col < _blockCounter; col++) {
        if (_boardList![row * _blockCounter + col] != _currentPlayer) {
          isWin = false;
          break;
        }
      }
      if (isWin) {
        return true;
      }
    }

    for (int col = 0; col < _blockCounter; col++) {
      isWin = true;
      for (int row = 0; row < _blockCounter; row++) {
        if (_boardList![row * _blockCounter + col] != _currentPlayer) {
          isWin = false;
          break;
        }
      }
      if (isWin) {
        return true;
      }
    }

    isWin = true;
    for (int i = 0; i < _blockCounter; i++) {
      if (_boardList![i * _blockCounter + i] != _currentPlayer) {
        isWin = false;
        break;
      }
    }
    if (isWin) {
      return true;
    }

    isWin = true;
    for (int i = 0; i < _blockCounter; i++) {
      if (_boardList![i * _blockCounter + (_blockCounter - 1 - i)] !=
          _currentPlayer) {
        isWin = false;
        break;
      }
    }
    if (isWin) {
      return true;
    }

    return false;
  }

  bool _checkEndGame() {
    for (int i = 0; i < _boardList!.length; i++) {
      if ('' == _boardList![i]) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    for (int i = 0; i < _boardList!.length; i++) {
      _boardList![i] = '';
    }
    setState(() {
      _currentPlayer = 'X';
      _result = 'X가 선 입니다.';
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        actions: [
          IconButton(
              onPressed: () {
                _reset();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '보드유형 : ',
                style: TextStyle(fontSize: 30),
              ),
              DropdownButton(
                  value: _selectOption,
                  style: const TextStyle(fontSize: 30, color: Colors.black),
                  icon: const Icon(Icons.arrow_drop_down),
                  items: _options.map((String item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
                  onChanged: (String? value) {
                    _selectOption = value!;
                    switch (_selectOption) {
                      case '3x3':
                        _blockCounter = 3;
                        break;
                      case '4x4':
                        _blockCounter = 4;
                        break;
                      case '5x5':
                        _blockCounter = 5;
                        break;
                      case '6x6':
                        _blockCounter = 6;
                        break;
                      case '7x7':
                        _blockCounter = 7;
                        break;
                      case '8x8':
                        _blockCounter = 8;
                        break;
                    }
                    setState(() {
                      _boardList = List.generate(
                          _blockCounter * _blockCounter, (index) => '');
                    });
                  })
            ],
          ),
          Container(
            height: 10,
          ),
          Container(
            width: screenWidth - 20,
            height: screenWidth - 20,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white),
                color: Colors.white,
                borderRadius: BorderRadius.circular(30), // 외곽선을 둥글게 만듦
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey,
                      spreadRadius: -10,
                      blurRadius: 30,
                      offset: Offset(0, 0))
                ]),
            child: GridView.builder(
                itemCount: _blockCounter * _blockCounter,
                padding: const EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _blockCounter,
                    childAspectRatio: 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0),
                itemBuilder: (context, index) {
                  int row = index ~/ _blockCounter;
                  int col = index % _blockCounter;
                  Color colLeftBorder = const Color(0xFFD8D8D8);
                  Color colBottomBorder = const Color(0xFFD8D8D8);
                  double leftBorderWidth = 2;
                  double bottomBorderWidth = 2;
                  if (col == 0) {
                    leftBorderWidth = 0;
                    colLeftBorder = Colors.transparent;
                  }
                  if (row == _blockCounter - 1) {
                    bottomBorderWidth = 0;
                    colBottomBorder = Colors.transparent;
                  }
                  return GestureDetector(
                    onTap: () {
                      _play(index);
                      print('row : $row, col : $col');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: colLeftBorder,
                              width: leftBorderWidth,
                            ),
                            bottom: BorderSide(
                              color: colBottomBorder,
                              width: bottomBorderWidth,
                            ),
                          ),
                          boxShadow: const []),
                      child: Center(
                        // child: Text(_boardList![index]),
                        child: '' != _boardList![index]
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                    'assets/${_boardList![index].toLowerCase()}.png'),
                              )
                            : Container(),
                      ),
                    ),
                  );
                }),
          ),
          Container(height: 10,),
          Text(_result,
          style: TextStyle(fontSize: 30),)
        ],
      ),
    );
  }
}
