/*
Muhammad Adil
UCID: 30069315
Project Part1 (bomberman)
This is the bomberman game. User picks a gamed board size. They can choose where to drop the bomb. Score gets loged to a file.
User can also view all top scores
*/

//importing libraries
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h> 
#include <ctype.h>

//this function generates a random number. Geneates either a positive or negative depending on the paramteres
//paramters: float min,float max,bool pos
//returns the random number generated 
float randomNum(float min,float max,bool pos){

    if(pos ==  true){
        float number = (max - min) * ((((float) rand()) / (float) RAND_MAX)) + min;
        return number;
    }else{
        float number = (max - min) * ((((float) rand()) / (float) RAND_MAX)) + min;
        if(number == 0){
            number = number + 0.5;
            return number;
        }else{
            return number;
        }
    }
}

//this function generates 2 random numbers on the board for the exit coordinates
//paramters: int row, int col
//returns 2 random numbers
int exitKey(int row, int col){
    //useing bitwise airthmatics
    int exitX = rand() & (row-1);
    int exitY = rand() & (col-1);
    return exitX, exitY;
}

//this function populates the board and displays it to the user(marker board)
//paramters: int row, int col,float *gameBoard
//doesnt return anything
void initalizeGame(float *gameBoard, int row, int col){
    //decaling variables
    int i,j;
    int negCounter = 0;
    int specialCounter = 0;
    int bonusCounter = 0;
    float upper = 18.00;
    float lower = -18.00;
    float negRatio,specialRatio;
    int power = 60;    //powerup key is set to 60
    int extraScore = 55; //lose a bomb (for bonus)
    int exit = 65;   //exit key is set to 65
    int extraLife = 50; //extra life key is set to 50
    int totalSize = row*col;
    srand(time(0)); //used to get random numbers everytime
    int exitX = exitKey(row,col);
    int exitY = exitKey(row,col);


    //for loop to loop thru 2d array depending on size of array(rows,cols)
    for(i = 0; i < row; i++){      
        for(j = 0; j < col; j++){
            bool pos = false;
            if(i == exitX && j == exitY){       //assign exit key to coordinates
                specialCounter = specialCounter + 1;
                *(gameBoard + i*col + j) = exit;
            }else{  
                *(gameBoard + i*col + j) = randomNum(upper,lower,pos);
                if(*(gameBoard + i*col + j) < 0 && *(gameBoard + i*col + j) >= -15.00){ //if number is negative
                    negCounter = negCounter + 1;
                    negRatio = ((float)negCounter/(float)(totalSize))*100;
                    if(negRatio >= 40.00){  //checking negative ratio
                        negCounter = negCounter - 1;
                        negRatio = ((float)negCounter/(float)(totalSize))*100;
                        pos = true;
                        lower = 0.5;
                        upper = 15.00;
                        *(gameBoard + i*col + j) = randomNum(upper,lower,pos);
                    }
                    //double range
                }else if ((*(gameBoard + i*col + j) > 15.00 && *(gameBoard + i*col + j) <= 16.00) || (*(gameBoard + i*col + j) < -15.00 && *(gameBoard + i*col + j) >= -16.00)){
                    specialCounter = specialCounter + 1;
                    float specialRatio = ((float)specialCounter/(float)(totalSize))*100;
                    if(specialRatio >= 20.00){  //checker powerup ratio
                        specialCounter = specialCounter - 1;
                        specialRatio = ((float)specialCounter/(float)(totalSize))*100;
                        pos = true;
                        lower = 0.5;
                        upper = 15.00;
                        *(gameBoard + i*col + j) = randomNum(upper,lower,pos);
                    }else{
                        *(gameBoard + i*col + j) = power;
                    }
                    //extra life
                }else if((*(gameBoard + i*col + j) > 16.00 && *(gameBoard + i*col + j) <= 17.00) || (*(gameBoard + i*col + j) < -16.00 && *(gameBoard + i*col + j) >= -17.00)){
                    bonusCounter = bonusCounter + 1;
                    float ratio = ((float)bonusCounter/(float)(totalSize))*100;
                    if(ratio >= 15.00){  //extra life
                        bonusCounter = bonusCounter - 1;
                        ratio = ((float)bonusCounter/(float)(totalSize))*100;
                        pos = true;
                        lower = 0.5;
                        upper = 15.00;
                        *(gameBoard + i*col + j) = randomNum(upper,lower,pos);
                    }else{
                        *(gameBoard + i*col + j) = extraLife;
                    }
                    //extra score
                }else if((*(gameBoard + i*col + j) > 17.00 && *(gameBoard + i*col + j) <= 18.00) || (*(gameBoard + i*col + j) < -17.00 && *(gameBoard + i*col + j) >= -18.00)){
                    bonusCounter = bonusCounter + 1;
                    float ratio = ((float)bonusCounter/(float)(totalSize))*100;
                    if(ratio >= 15.00){  //checker powerup ratio
                        bonusCounter = bonusCounter - 1;
                        ratio = ((float)bonusCounter/(float)(totalSize))*100;
                        pos = true;
                        lower = 0.5;
                        upper = 15.00;
                        *(gameBoard + i*col + j) = randomNum(upper,lower,pos);
                    }else{
                        *(gameBoard + i*col + j) = extraScore;
                    }
                }
            }

            //this displays the board for the marker
            //also check what the board is at that position and prints values accordingly
            if(*(gameBoard + i*col + j) == exit){
                printf("    *    ", *(gameBoard + i*col + j));  //exit
            }else if(*(gameBoard + i*col + j) == power){        //double bomb range
                printf("    $    ", *(gameBoard + i*col + j));
            }else if(*(gameBoard + i*col + j) == extraScore){   //bonus power up
                printf("    #    ", *(gameBoard + i*col + j));
            }else if(*(gameBoard + i*col + j) == extraLife){    //bonus power up
                printf("    !    ", *(gameBoard + i*col + j));  
            }else{
                printf("%6.2f   ", *(gameBoard + i*col + j));
            }
        }
        printf("\n");
     }
     printf("The total negative numbers are %d/%d = %.2f%% < 40.00%%\n",negCounter,totalSize,negRatio);
     printf("----------------------------------The Game has Started!!----------------------------------\n");
}

//this function displays the 2d array of X
//the parameters are char *playBoard, int rows, intcols
//this function doesnt return anything it just displays the array to the user
void display(char *playBoard, int row, int col){
    int i,j;
    for(i = 0; i < row; i++){
         for(j = 0; j < col; j++){
             *(playBoard + i*col + j) = 'X';
            printf("%c ",*(playBoard + i*col + j));
         }
        printf("\n");
    }
}

//this function takes in the updated playBoard score, lives, bomb and displays it
//parameters: char *playBoard, int row, int col, float score, int bomb ,int lives,float totalScore
//does function doesnt return anything
void updateDisplay(char *playBoard, int row, int col, float score, int bomb ,int lives,float totalScore){
    int i,j;
    float exitKey = 65.00;
    float powerKey = 60.00;
    printf("Total uncovered score is %.2f\n",totalScore);   //over all score
     
     for(i = 0; i < row; i++){
         for(j = 0; j < col; j++){
             //checking to see what the symbol is 
            if(*(playBoard + i*col + j) == '*'){
                printf("* ",*(playBoard + i*col + j));
            }else if(*(playBoard + i*col + j) == '$'){
                printf("$ ",*(playBoard + i*col + j));
            }else if(*(playBoard + i*col + j) == '#'){
                printf("# ",*(playBoard + i*col + j));
            }else if(*(playBoard + i*col + j) == '!'){
                printf("! ",*(playBoard + i*col + j));
            }else if(*(playBoard + i*col + j) == '+'){
                printf("+ ",*(playBoard + i*col + j));
            }else if(*(playBoard + i*col + j) == '-'){
                printf("- ",*(playBoard + i*col + j));
            }else{
                printf("X ",*(playBoard + i*col + j));
            }
        }
            printf("\n");
        }
        
        //printing statments
        printf("Lives: %d\n",lives);
        printf("Score: %.2f\n",score);
        printf("Bomb: %d\n",bomb);


}

//this function read file and stores the values in a array. It then sorts those arrays and displays the top scores the user wants
//paramter: FILE *logFile, int n
//doesnt return anything 
void displayTopScore(FILE *logFile, int n){
    char input,swaper;
    int counter = 0;
    char nameArray[500][10];
    float scoreArray[500];
    int timeArray[500];
    int newT,i,j,k,swap;
    char name[10];
    float newScore,temp;
    char playerNames[10];
    FILE *fP;
    fP = fopen("leaderBoard.log", "r");

    if(fP == NULL){ //if user attempts to get top scores without playing
        printf("There are no top scores recorded. Play the game first!\n");
        return; //return back to main
    }

    //loop thru all rows of file
    do{
        fscanf(fP, "%s %f %d", &name,&newScore,&newT);  //read every line 
        for(i = 0; i < 10; i++){    //storing each charcter name in an nameArray
            nameArray[counter][i] = name[i];
        }
        //storing values in array
        scoreArray[counter] = newScore;
        timeArray[counter] = newT;
        counter++;
    }while(!feof(fP));
    fclose(fP);

    //bubble sorting algorithm
    for(i = 0 ; i < (counter) - 2; i++){
        for(j = 0; j < (counter) - i - 2; j++){
            if(scoreArray[j]<scoreArray[j+1]){
                //sorting array of scores
                temp = scoreArray[j];
                scoreArray[j] = scoreArray[j+1];
                scoreArray[j+1] = temp;  

                //sorting array of time depending on score array
                swap = timeArray[j];
                timeArray[j] = timeArray[j+1];
                timeArray[j+1] = swap;

                //sorting names dependin on the score
                for(int l = 0; l < 10; l++){
                    playerNames[l] = nameArray[j][l];
                    nameArray[j][l] = nameArray[j+1][l];
                    nameArray[j+1][l] = playerNames[l];
                }
            }
        }
    }

    printf("How many top scores do you want(between 1 - %d)?(Enter 0 to exit program)\n",(counter-1));
    scanf("%d",&n);
    while(n > (counter - 1)){
        printf("Value given is too large. Try again(Enter 0 to exit program)\n");
        printf("How many top socre do you want?");
        scanf("%d",&n);
    }

    if(n == 0){ //checking if the user wants to exit
        printf("Exiting Program");
        exit(0);
    }

    //printing number of top scores user wants
    for(int i = 0; i < n; i++){
        printf("%s ",nameArray[i]);
        printf("%.2f ",scoreArray[i]);
        printf("%d\n",timeArray[i]);
    }
}

//when the game is played this functions logs the score to the log file at the end of the game or if they quit mid game. Also calls displayTopScores
//paramters: char *playerName,float *totalScore,int t, FILE *logFile
//doesnt return anything
void exitingGame(char *playerName,float *totalScore,int t, FILE *logFile){
    int n;

    printf("%s has a score of %.2f. ",playerName,*totalScore);
    printf("The time played is %d seconds\n", t);
    logFile = fopen("leaderBoard.log", "r");

    if(logFile == NULL){    //if file doesnt exist
        logFile = fopen("leaderBoard.log", "mode");
        logFile = fopen("leaderBoard.log", "a");
        fprintf(logFile, "%s %.2f %d\n", playerName,*totalScore,t);

    }else{  //if file exists
        logFile = fopen("leaderBoard.log", "a");
        fprintf(logFile, "%s %.2f %d\n", playerName,*totalScore,t);
    }
    fclose(logFile);
    displayTopScore(logFile,n);
}

//this function checks the board where the bomb is dropped and updates the score. Also updates the playBoard 
//paramters:float *gameBoard, char *playBoard, int xCoor, int yCoor, int row, int col, int *bomb, int *lives, float score,float *totalScore, int *powerUpCounter,char *playerName,bool *exiting
//this function doesnt return anything
void checker(float *gameBoard, char *playBoard, int xCoor, int yCoor, int row, int col, int *bomb, int *lives, float score,float *totalScore, int *powerUpCounter,char *playerName,bool *exiting){
    int i,j,k,sR,sC,eR,eC,l,m;
    int exitKey = 65;
    int powerKey = 60;
    int extraScore = 55;
    int extraLife = 50;
    int range = 1;

    for(i = 0; i < row; i++){
        for(j = 0; j < col; j++){
            if((i == xCoor && j == yCoor)){ //at current position
                int rangeLoop = pow(2,*powerUpCounter);
                *powerUpCounter = 0;
                *bomb = *bomb - 1;
                for(k = 0; k < rangeLoop; k++){ //for the bomb radius
                    //finding start point
                    sR = xCoor - (range+k);
                    sC = yCoor - (range+k);
                    //finding end point
                    eR = xCoor + (range+k);
                    eC = yCoor + (range+k);

                    //cheking to see if starting row is in bound
                    if(sR < 0){
                        sR = 0;
                    }else{
                        sR = sR;
                    }

                    //cheking to see if starting col is in bound
                    if(sC < 0){
                        sC = 0;
                    }else{
                        sC = sC;
                    }

                    //cheking to see if ending row is in bound
                    if(eR > row - 1){
                        eR = row - 1; 
                    }else{
                        eR = eR;
                    }

                    //cheking to see if ending col is in bound
                    if(eC > col - 1){
                        eC = col - 1;
                    }else{
                        eC = eC;
                    }
                    //looping thru the newly found boundires 
                    for(l = sR; l <= eR; l++){
                        for(m = sC; m <= eC; m++){
                            if(*(gameBoard + l*col + m) == exitKey){    //exitKEy found
                                *(playBoard + l*col + m) = '*';
                                score = score;
                                *exiting = true;
                                printf("Exit Key Found!! Good Job!!\n");
                            }else if(*(gameBoard + l*col + m) == powerKey){ //powerUp founds
                                if(*(playBoard + l*col + m) != '$'){    //checks to see if powerup is already uncovered
                                    *powerUpCounter = *powerUpCounter + 1;  
                                }
                                *(playBoard + l*col + m) = '$';     //setting positon to $
                            }else if(*(gameBoard + l*col + m) == extraScore){
                                if(*(playBoard + l*col + m) != '#'){
                                    printf("Extra two points!!\n");
                                    score = score + 2;
                                }
                                *(playBoard + l*col + m) = '#';     //setting positon to #
                            }else if(*(gameBoard + l*col + m) == extraLife){
                                if(*(playBoard + l*col + m) != '!'){
                                    printf("You found an extra life!!\n");
                                    *lives = *lives + 1;
                                }
                                *(playBoard + l*col + m) = '!';     //setting positon to !
                            }else{  //anything else found
                                if(*(playBoard + l*col + m) == '+' || *(playBoard + l*col + m) == '-'){    //checking to see if position is already uncovered
                                    score = score;
                                }else{ 
                                    score = score + *(gameBoard + l*col + m); 
                                }
                                if(*(gameBoard + l*col + m) > 0){   //checking to see if its positive or negative
                                    *(playBoard + l*col + m) = '+';
                                }else{
                                    *(playBoard + l*col + m) = '-';
                                }
                            }
                        }
                    }
                }
            }
        }    
    }
    
    //checking the totalsore and lives depending on score. also checks is bomb == 0.
    printf("Bomb range is 2^%d\n",*powerUpCounter);
    *totalScore = *totalScore + score;
    if(*bomb == 0){
        printf("Looks like you're out of bombs!!\n");
        *exiting = true;
    }else if(*totalScore <= 0){
        printf("Looks like you lost a life!!\n");
        *lives = *lives - 1;
        if(*lives == 0){
            printf("Looks like you're out of lives!!\n");
            score = score;
            *exiting = true;
        }else{
            *totalScore = 0;
        }
    }
    updateDisplay(playBoard,row,col,score,*bomb,*lives,*totalScore);    //calling updateDisplay 
}

//this is the main fuction
//it makes calls to other functions 
//it also takes in command line arguments and does all the nessary error checking
//takes the parameters int argc and int *argv[] (# of arguments and array of arguments respectively)
int main(int argc, char *argv[]){
    int row, col, xCoor, yCoor, t,n;
    char *playerName = argv[1];
    int lives = 3;
    float score = 0; 
    row = atoi(argv[2]);
    col = atoi(argv[3]);
    int totalSize = row*col;
    int bomb = totalSize * 0.05;
    int powerUpCounter = 0;
    char userInput;
    float totalScore = 0;
    bool exiting = false;   //flag for when to break the loop and record scores
    time_t start,end;
    FILE *logFile;

    //checking the user arguments
    if(argc == 4){      //the correct number of arguments is given
        if(row < 10 || col < 10 || col > 20){   //checking to see if rows and cols is within bounds
            printf("Number of rows or columns is too less(max col is 20)...Exiting Program\n");
        }else{  //if rows and cols is in bound
            float gameBoard[row][col];  //this the board with the float values 
            char playBoard[row][col];  //this is the actual game board
            printf("The board size is %dx%d\n",row,col);
            printf("Generating game board...\n");
            initalizeGame(*gameBoard,row,col);  //initalizing the board
            display(*playBoard,row,col);    //printing board of X's
            printf("Lives: %d\n",lives);
            printf("Score: %d\n",score);
            printf("Bombs: %d\n",bomb);
            printf("To play enter 'P'. To view top scores enter 'T'. To exit program enter anything else\n");
            scanf("%c",&userInput);
            userInput = toupper(userInput);
            if(userInput == 'P' || userInput == 'T'){   //user wants to play the game
                if(userInput == 'T'){
                    displayTopScore(logFile,n);
                }
                printf("Enter an X coordinate:(between 0-%d)\n",row - 1);
                scanf("%d",&xCoor);
                printf("Enter an Y coordinate:(between 0-%d. Enter -1 to quit.)\n",col - 1);
                scanf("%d",&yCoor);
                time(&start);   //start the timer

                while(yCoor != -1){
                    if(xCoor >= 0 && xCoor <= row - 1 && yCoor >= 0 && yCoor <= col - 1){
                        checker(*gameBoard,*playBoard,xCoor,yCoor,row,col,&bomb,&lives,score,&totalScore,&powerUpCounter,playerName,&exiting);
                        if(exiting == true){    //break loop if exit key is found
                            break;
                        }
                    }else{
                        printf("Invalid Entry Try Again\n");
                    }
                    printf("Enter an X coordinate:(between 0-%d)\n",row - 1);
                    scanf("%d",&xCoor);
                    printf("Enter an Y coordinate:(between 0-%d. Enter -1 to quit.)\n",col - 1);
                    scanf("%d",&yCoor);
                }

                time(&end); //end the timer

                if(yCoor == -1){    //if user quits mid game
                    t = difftime(end,start);
                    exitingGame(playerName,&totalScore,t,logFile);
                }
                if(exiting == true){    //exitKey found
                    t = difftime(end,start);
                    exitingGame(playerName,&totalScore,t,logFile); 
                }
            }else{
                printf("...Exiting...Program...\n");
                exit(0);
            }
        }
    }else{      //incorrect number of arguments is given
        printf("Invalid number of arguments...Exiting Program\n");
    }
}