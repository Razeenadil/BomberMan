By Muhammad Adil
UCID: 30069315

Project Part 1:

This program is a simplified bomberman. The user chooses the size of the board and also chooses the 
player name. Once the game starts the user can view the top scores of all the past players, including their play time and player name. The user can also play the game. Once the game starts the user drops a bomb in desired position. If lives run out or bombs run out or an eixt key is found(*) the game is over and the user info(name,score,time) is logged to the log file(leaderBoard.log).

Symbols in Game:
* is the exit key
$ is the double bomb range key
# is the +2 points key //BONUS
! is the extra life key //BONUS
+/- is positive of negative score

How to Compile and Run:
To compile follow the steps:

1. type "gcc myGame.c -o myGame -lm" in the command line. This is will compile the
program. HAVE TO ADD "-lm" OR PROGRAM WON'T COMPILE BECAUSE POWER FUNCTION FROM MATH LIBRARY IS USED.

To run the program follow these steps:
1. move onto this step after the program is compiled
2. To start the game enter "./myGame X M N". Where X is the player name(max 10 characters Ex."Larry"). And where M and N are rows and cols respectively 
(note both M and N must be greater than or equal to 10. Also max value for N is 20)

**Note I completed the project and added 2 extra power ups. ! increments life by 1 if found. # increments 
score by 2 if found. Also I dont have a max row size but I do have a max column size(20). I set it to 20 
because, on my screen after 20 columns the float array didnt display properly. In the log file, first row is player names, second row is score, and third row is time played 
(this format is followed when displaying top scores to user).


