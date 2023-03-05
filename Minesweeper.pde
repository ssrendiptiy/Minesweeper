import de.bezier.guido.*;
public final static int NUM_ROW = 10;
public final static int NUM_COL = 10;
public final static int NUM_BOM = (NUM_ROW * NUM_COL)/5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>();//ArrayList of just the minesweeper buttons that are mined
public int countFlag = 0;
public int countTrueFlag = 0;
void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROW][NUM_COL];
  for (int a = 0; a < NUM_ROW; a++) {
    for (int b = 0; b < NUM_COL; b++) {
      buttons[a][b] = new MSButton(a, b);
    }
  }


  setMines();
}
public void setMines()
{
  while (mines.size() < NUM_BOM) {
    int r = (int)(Math.random()*NUM_ROW);
    int c = (int)(Math.random()*NUM_COL);
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true){
    displayWinningMessage();
    noLoop();
  }
}
public boolean isWon()
{
  if(countFlag == countTrueFlag){
    if(countFlag == NUM_BOM){
      return true;
    }
  }
  return false;
}
public void displayLosingMessage()
{
  for (int i = 0; i < NUM_ROW; i++) {
    for (int j = 0; j < NUM_COL; j++) {
      if (mines.contains(buttons[i][j])) {
        buttons[i][j].clicked = true;
      }
    }
  }  
  buttons[NUM_ROW/2][NUM_COL/2 - 5].setLabel("Y"); 
  buttons[NUM_ROW/2][NUM_COL/2 - 4].setLabel("O"); 
  buttons[NUM_ROW/2][NUM_COL/2 - 3].setLabel("U"); 
  buttons[NUM_ROW/2][NUM_COL/2 - 1].setLabel(" "); 
  buttons[NUM_ROW/2][NUM_COL/2].setLabel("L"); 
  buttons[NUM_ROW/2][NUM_COL/2 + 1].setLabel("O"); 
  buttons[NUM_ROW/2][NUM_COL/2 + 2].setLabel("S");
  buttons[NUM_ROW/2][NUM_COL/2 + 3].setLabel("E");
}
public void displayWinningMessage()
{
  for (int i = 0; i < NUM_ROW; i++) {
    for (int j = 0; j < NUM_COL; j++) {
      if (mines.contains(buttons[i][j])) {
        buttons[i][j].clicked = true;
      }
    }
  }  
  buttons[NUM_ROW/2][NUM_COL/2 - 5].setLabel("Y"); 
  buttons[NUM_ROW/2][NUM_COL/2 - 4].setLabel("O"); 
  buttons[NUM_ROW/2][NUM_COL/2 - 3].setLabel("U"); 
  buttons[NUM_ROW/2][NUM_COL/2 - 1].setLabel(" "); 
  buttons[NUM_ROW/2][NUM_COL/2].setLabel("W"); 
  buttons[NUM_ROW/2][NUM_COL/2 + 1].setLabel("I"); 
  buttons[NUM_ROW/2][NUM_COL/2 + 2].setLabel("N");
}
public boolean isValid(int r, int c)
{
  if (r < NUM_ROW && r >= 0 && c < NUM_COL && c >= 0) {
    return true;
  } else {
    return false;
  }
}
public int countMines(int row, int col)
{
  int count = 0;
  for (int r = row-1; r<=row+1; r++)
    for (int c = col-1; c<=col+1; c++)
      if (isValid(r, c) && mines.contains(buttons[r][c]))
        count++;
  if (mines.contains(buttons[row][col]))
    count--;
  return count;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COL;
    height = 400/NUM_ROW;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    if (mouseButton == RIGHT) {
      if (!flagged && !clicked) {
        flagged = true;
        clicked = true;
        countFlag += 1;
          if(mines.contains(buttons[myRow][myCol])){
            countTrueFlag += 1;
          }
      } else if (flagged) {
        flagged = false;
        clicked = false;
        countFlag -= 1;
          if(mines.contains(buttons[myRow][myCol])){
            countTrueFlag -= 1;         
          }
      }
    } else if (mines.contains(this)) {
      if (!flagged)
        displayLosingMessage();
        noLoop();
    } else if (countMines(myRow, myCol) > 0) {
      clicked = true;
      setLabel(countMines(myRow, myCol));
    } else { 
      for (int r = myRow-1; r<=myRow+1; r++) {
        for (int c = myCol-1; c<=myCol+1; c++) {
          if (isValid(r, c) == true && buttons[r][c].clicked == false && !mines.contains(buttons[r][c])) {
            buttons[r][c].clicked = true;
            buttons[r][c].mousePressed();
          }
        }
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
