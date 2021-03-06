# TicTacToe
TicTacToe is a ruby program in which two players can play tic tac toe against
each other

## Installation
with bundler and ruby already installed
```bash
bundle install
```

## Usage
TicTacToe is tested with ruby version 3.0.2\
Assuming your ruby version is compatible

```bash
ruby play_tic_tac_toe.rb
```

## Contributing
- Be sure to add test cases for whatever changes you make
- Your PR should include basic details of change you made
in the README.md file with the git tag name as the header
Refer to v1.0.0 and v1.1.0 sections below to know what is expected

## v1.0.0
- Minimum MVP in which 2 playes can play with each other

This is how things are sturctured
```
            TicTacToe
               |
               V
           GameRunner
           |       |
           V       |
          Game     |
           |       |
           |       V
           |      CommandLineInterface
           |       |      |        |
           |       |      V        V
           |       |    STDOUT   STDIN
           V       |
        Board      |
           |       |
           |       |
           V       V
            Position

PlayerSetup: Module responsible for setting up players as bots or humans
GameRunner : Gets the player setup and runs the game state machine and
             interacts with user via CLI
CommandLine: CLI to manage all terminal based IO
Interface
Game       : Represents game behavious as a state machine
Board      : Represents tic tac toe board
Position   : Value object to pass positions on tic tac toe board

```
## v1.1.0
- Added player setup so that end users can decide to play against
each other or vs bot
- Added RandomBot as a first bot you can play against

```
This is how things are structured
            TicTacToe-----------------
               |                      |
               V                      V
           GameRunner       --------PlayerSetup
           |       |        |            |
           |       |        |            |
           |       |        |            |
           |       |---->---|------------|
           |       |        |            V
           V       |        |        -----------
          Game     |        |        |         |
           |       |        |        V         V
           |       |        |    HumanPlayer   RandomBot
           |       |        |      |               |
           |       |        |      |               |
           |       V        V      V               |
           |      CommandLineInterface             |
           |       |      |        |               |
           |       |      V        V               |
           |       |    STDOUT   STDIN             |
           V       |                               |
        Board<-----|-------------------------------
           |       |
           |       |
           V       V
            Position

PlayerSetup: Module responsible for setting up players as bots or humans
GameRunner : Gets the player setup and runs the game state machine and
             interacts with user via CLI
HumanPlayer: Represents human playing the game.
RandomBot  : Bot which randomly gives the next valid move
CommandLine: CLI to manage all terminal based IO
Interface
Game       : Represents game behavious as a state machine
Board      : Represents tic tac toe board
Position   : Value object to pass positions on tic tac toe board
```

## v1.1.1
- Added smart bot

This is how things are structured
```
   TicTacToe-----------------
      |                      |
      V                      V
   GameRunner       --------PlayerSetup
   |       |        |            |
   |       |        |            |
   |       |        |            |
   |       |---->---|------------|
   |       |        |            V
   V       |        |        --------------------------
  Game     |        |        |         |              |
   |       |        |        V         V              V
   |       |        |    HumanPlayer   RandomBot    SmartBot
   |       |        |      |               |        |      |
   |       |        |      |               |        |      |
   |       V        V      V               |---<-----      |
   |      CommandLineInterface             V               V
   |       |      |        |               |----<-------- Path
   |       |      V        V               |               |
   |       |    STDOUT   STDIN             |               |
   V       |                               |               V
Board<-----|-------------------------------               Move
   |       |                                               |
   |       |                                               |
   V       V                                               |
   Position<----------------------------------------------

PlayerSetup: Module responsible for setting up players as bots or humans
GameRunner : Gets the player setup and runs the game state machine and
             interacts with user via CLI
HumanPlayer: Represents human playing the game.
RandomBot  : Bot which randomly gives the next valid move
SmartBot   : A somewhat smart bot which judges the game one step ahead.
             Starts at a corner if it is the first one playing.
Move       : Represents a position along with a symbol
Path       : Represents a path the game can move into. Holds the moves to
             reach that path, how the board looks like and verdict if
             path is concluding into win or draw
CommandLine: CLI to manage all terminal based IO
Interface
Game       : Represents game behavious as a state machine
Board      : Represents tic tac toe board
Position   : Value object to pass positions on tic tac toe board

```

## v1.1.2
- Added phone dial style way of accepting user input
- in this format this is how tic tac toe board looks like.\
  User can enter below number to place a symbol over there
```
   1 | 2 | 3
   ----------
   4 | 5 | 6
   ----------
   7 | 8 | 9
 ```
## License
[MIT](https://choosealicense.com/licenses/mit/)