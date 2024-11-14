import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X', result = '';
  bool gameOver = false, isSwitch = false;
  int turn = 0;
  Game game = Game();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF00061a),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                children: [
                  const SizedBox(height: 20),
                  SwitchListTile.adaptive(
                      title: const Text('Turn on/off two player',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          textAlign: TextAlign.center),
                      value: isSwitch,
                      onChanged: (newVal) => setState(() => isSwitch = newVal)),
                  const SizedBox(height: 20),
                  Text(
                      gameOver || result == "It's Draw"
                          ? 'Game Over!'
                          : "It's $activePlayer turn",
                      style: const TextStyle(color: Colors.black, fontSize: 40),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 40),
                  Expanded(
                    child: GridView.count(
                      padding: const EdgeInsets.all(15),
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 1.0,
                      crossAxisCount: 3,
                      children: List.generate(
                          9,
                          (index) => InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: gameOver ? null : () => onTap(index),
                              child: Container(
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 143, 45, 45),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                  child: Text(
                                    Player.playerX.contains(index)
                                        ? 'X'
                                        : Player.playerO.contains(index)
                                            ? 'O'
                                            : "",
                                    style: TextStyle(
                                        color: Player.playerX.contains(index)
                                            ? Colors.blue
                                            : Colors.red,
                                        fontSize: 50),
                                  ),
                                ),
                              ))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 75),
                    child: ElevatedButton.icon(
                        onPressed: () => setState(() {
                              Player.playerX = [];
                              Player.playerO = [];
                              activePlayer = 'X';
                              result = '';
                              gameOver = false;
                              turn = 0;
                            }),
                        icon: const Icon(Icons.replay,
                            color: Color.fromARGB(255, 255, 255, 255)),
                        label: const Text('Repeat the game',
                            style: TextStyle(color: Colors.white)),
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 143, 45, 45)))),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SwitchListTile.adaptive(
                            title: const Text('Turn on/off two player',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                textAlign: TextAlign.center),
                            value: isSwitch,
                            onChanged: (newVal) =>
                                setState(() => isSwitch = newVal)),
                        Text("It's $activePlayer turn",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 40),
                            textAlign: TextAlign.center),
                        ElevatedButton.icon(
                            onPressed: () => setState(() {
                                  Player.playerX = [];
                                  Player.playerO = [];
                                  activePlayer = 'X';
                                  result = '';
                                  gameOver = false;
                                  turn = 0;
                                }),
                            icon: const Icon(Icons.replay, color: Colors.white),
                            label: const Text('Repeat the game',
                                style: TextStyle(color: Colors.white)),
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color(0xFF4169e8)))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      padding: const EdgeInsets.all(15),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 1.0,
                      crossAxisCount: 3,
                      children: List.generate(
                        9,
                        (index) => InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: gameOver ? null : () => onTap(index),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFF001456),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                Player.playerX.contains(index)
                                    ? 'X'
                                    : Player.playerO.contains(index)
                                        ? 'O'
                                        : "",
                                style: TextStyle(
                                    color: Player.playerX.contains(index)
                                        ? Colors.blue
                                        : Colors.red,
                                    fontSize: 50),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();
    }

    if (!isSwitch && !gameOver && turn != 9) {
      await game.autoPlay(activePlayer);
      updateState();
    }
  }

  void updateState() {
    setState(() => activePlayer = activePlayer == 'X' ? 'O' : 'X');
    turn++;
    String winnerPlay = game.cheekWiner();
    if (winnerPlay != '') {
      gameOver = true;
      AwesomeDialog(
              context: context,
              animType: AnimType.bottomSlide,
              dialogType: DialogType.success,
              body: Center(
                  child: Text(result = "Player '$winnerPlay' is Winner",
                      style: const TextStyle(fontStyle: FontStyle.italic))),
              btnOkOnPress: () {},
              btnCancelOnPress: () => setState(() {
                    Player.playerX = [];
                    Player.playerO = [];
                    activePlayer = 'X';
                    result = '';
                    gameOver = false;
                    turn = 0;
                  }),
              btnCancelText: 'Repeat the game')
          .show();
    } else if (!gameOver && turn == 9) {
      AwesomeDialog(
              context: context,
              animType: AnimType.scale,
              dialogType: DialogType.warning,
              body: Center(
                  child: Text(result = "It's Draw",
                      style: const TextStyle(fontStyle: FontStyle.italic))),
              btnOkOnPress: () {},
              btnCancelOnPress: () => setState(() {
                    Player.playerX = [];
                    Player.playerO = [];
                    activePlayer = 'X';
                    result = '';
                    gameOver = false;
                    turn = 0;
                  }),
              btnCancelText: 'Repeat the game')
          .show();
    }
  }
}
