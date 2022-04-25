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
## License
[MIT](https://choosealicense.com/licenses/mit/)