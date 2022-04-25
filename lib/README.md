# TicTacToe
TicTacToe is a ruby program in which two players can play tic tac toe against
each other

## Installation
TicTacToe is tested with ruby version 3.0.2
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
This is how the program is structured

```
            TicTacToe-----------------
               |                      |
               V                      V
           GameRunner       --------PlayerSetup
           |       |        |                 |
           V       |        |            ---------------------
          Game     |        |            |         |         |
           |       |        |            V         V         V
           |       |        |    HumanPlayer   RandomBot  SmartBot
           |       |        |      |               |         |
           |       |        |      |               -----------
           |       V        V      V                   |
           |      CommandLineInterface                 |
           |       |      |        |                   |
           |       |      V        V                   |
           |       |    STDOUT   STDIN                 |
           V       |                                   |
        Board<-----|-----------------------------------
           |       |
           |       |
           V       V
            Position

PlayerSetup: Module responsible for setting up players as bots or humans
GameRunner : Gets the player setup and runs the game state machine and
             interacts with user via CLI
HumanPlayer: Represents human playing the game.
RandomBot  : Bot which randomly gives the next valid move
SmartBot   : Bot which playes to win or avoid loss.
CommandLine: CLI to manage all terminal based IO
Interface
Game       : Represents game behavious as a state machine
Board      : Represents tic tac toe board
Position   : Value object to pass positions on tic tac toe board

```

How the program works can further be better understood by refering to documentation in test cases and modules and classes

Whenever you make changes, don't forget to update the test cases.


## License
[MIT](https://choosealicense.com/licenses/mit/)