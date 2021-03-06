By Muhammad Adil
UCID: 30069315

Project Part 2:

This program is a simplified bomberman. The user chooses the size of the board and also chooses the 
player name. Once the game starts the user can view the top scores of all the past players, including their play time and player name. The user can also play the game. Once the game starts the user drops a bomb in desired position. If lives run out or bombs run out or an eixt key is found(*) the game is over and the user info(name,score,time) is logged to the log file(leaderBoard.log).
The program is split into two different file (myGameP2.asm and randomNum.asm)

Symbols in Game:
* is the exit key
$ is the double bomb range key
@ is the +10 points key //BONUS
& is the extra life key //BONUS
+/- is positive of negative score

How to Compile and Run:
To compile follow the steps:

1. type make


To run the program follow these steps:
1. move onto this step after the program is compiled
2. To start the game enter "./myGameP2 X M N". Where X is the player name(Ex."Larry"). And where M and N are rows and cols respectively 
(note both M and N must be greater than or equal to 10. Also max value for N is 20)

**Note I completed the project and added 2 extra power ups. & increments life by 1 if found. @ increments 
score by 10 if found. The max M and N values are 20. I did everything up to the end of the game. My game runs
prefectly fine and all values are displayed properly. The only things I did not do is ask user for topDoc. I did 
not log scores to a file, and I also did not read the file and sort the score and display them to the user. 


