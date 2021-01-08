class Game {
  Game({
    required this.tournament,
    required this.stage,
  });

  final String tournament;
  final String stage;

  @override
  String toString() => '$tournament $stage';
}

final customGameList = [
  Game(
    tournament: 'WorldCup',
    stage: 'Groups',
  ),
  Game(
    tournament: 'WorldCup',
    stage: 'Semi-finals',
  ),
  Game(
    tournament: 'WorldCup',
    stage: 'Final',
  ),
  Game(
    tournament: 'ChampionsLeague',
    stage: 'Groups',
  ),
  Game(
    tournament: 'ChampionsLeague',
    stage: 'Semi-finals',
  ),
  Game(
    tournament: 'ChampionsLeague',
    stage: 'Final',
  ),
];
