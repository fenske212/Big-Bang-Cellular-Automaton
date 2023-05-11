// Brandon Fenske
// CSE 355 - Dr. Hani Ben Amor
// Cellular Automaton

// Randomly generated Stars represent 3 state cells and the planets represent the expansion
// to the neighboring cells. Large Stars have 7 neighbors, Medium stars have 5 neighbors. Small Stars 
// have 3. Planets are each assigned a color and when the planet count has been reached we terminate the expansion of that cell


// Create the Initial Grid
int[][] grid; 
int gridSize = 4;
int gridWidth = 200;
int gridHeight = 200;

//Big Bang Variables
boolean burnStarted = false; // gold ring
int startX, startY;         // coordinates of mouse click
int currentRadius = 0;      // keeps radius of bang
int blackRadius = -5;       //black ring follows gold


//White Star Variables
int whiteTileCount = 0;     //white star counter

//Star Variables
int[][] starColors;         //orange,blue,white,yellow
float[][] starSizes;        //sml,med,lrg
int starCount = 0;           //star counter

//Planet Variables
ArrayList<PVector> planetRects = new ArrayList<PVector>();
int[][][] planetColors; 
int currentPlanetIndex = 0;
int displayCounter = 0;
int displayDuration = 60;
int[][] maxDrawnPlanetsArray;
int framesPerPlanet = 30; // Number of frames to wait before drawing the next planet
int framesPerPlanet2 = 15; // Number of frames to wait before drawing the next planet

// Check if a grid cell is inside the gold ring
public boolean isInsideGoldRing(int centerX, int centerY, int x, int y, int radius) {
  int distance = PApplet.parseInt(sqrt(sq(x - centerX) + sq(y - centerY)));
  if (distance < radius) {
    return true;
  }
  return false;
}

// Create a gold ring
public void createGoldRing(int centerX, int centerY, int radius) {
  for (int x = centerX - radius; x <= centerX + radius; x++) {
    for (int y = centerY - radius; y <= centerY + radius; y++) {
      int distance = PApplet.parseInt(sqrt(sq(x - centerX) + sq(y - centerY)));
      if (distance == radius) {
        if (x >= 0 && x < gridWidth && y >= 0 && y < gridHeight) {
          grid[x][y] = 2; // Gold
}}}}}

// Create a black ring
public void createBlackRing(int centerX, int centerY, int radius) {
  for (int x = centerX - radius; x <= centerX + radius; x++) {
    for (int y = centerY - radius; y <= centerY + radius; y++) {
      int distance = PApplet.parseInt(sqrt(sq(x - centerX) + sq(y - centerY)));
      if (distance == radius) {
        if (x >= 0 && x < gridWidth && y >= 0 && y < gridHeight) {
          grid[x][y] = 0; // Black
}}}}}
 

//creates smaller white stars
public void whiteStars(int centerX, int centerY, int radius) {
  for (int x = centerX - radius; x <= centerX + radius; x++) {
    for (int y = centerY - radius; y <= centerY + radius; y++) {
      if (x >= 0 && x < gridWidth && y >= 0 && y < gridHeight) { // boundary check
        if (isInsideGoldRing(centerX, centerY, x, y, radius)) {
                     if (random(1) < 0.00005  && whiteTileCount < 140) { //limit the number of white tiles
            grid[x][y] = 3; // White Tile
            whiteTileCount++;
}}}}}}


public void printWhiteStars(int centerX, int centerY, int radius) {
  //print white stars
  for (int x = 0; x < gridWidth; x++) {
    for (int y = 0; y < gridHeight; y++) {
      if (grid[x][y] == 3) { 
        fill(255, 255, 255); 
        ellipse(x * gridSize, y * gridSize, gridSize, gridSize);  
}}}}

public void printStars(int centerX, int centerY, int radius) {
  for (int x = 0; x < gridWidth; x++) {
    for (int y = 0; y < gridHeight; y++) {
      if (grid[x][y] == 1) { // Star
        int starColor = starColors[x][y]; // Use the star color directly
        int starRadius = 0;
        noStroke();
        // ellipseMode(RADIUS);        
        float sizePicker = starSizes[x][y]; // Size of Stars
        if (sizePicker < 0.45f) {
          starRadius = gridSize * 6;
        } else if (sizePicker < 0.9f) {
          starRadius = gridSize * 9;
        } else {
          starRadius = gridSize * 12;
        }

        push();
        fill(starColor); // Use the star color
        ellipse(x * gridSize, y * gridSize, starRadius, starRadius);
        pop();
        int starSize = 1; // by default
        if (starSizes[x][y] >= 0.45f && starSizes[x][y] < 0.9f) {
          starSize = 2;
        } else if (starSizes[x][y] >= 0.9f) {
          starSize = 3;
        }

        Planets(x, y, starSize); // print the planets with the stars
      } else if (grid[x][y] == 2) { // Gold
        fill(255, 215, 0);
        rect(x * gridSize, y * gridSize, gridSize, gridSize);
      } else { // Empty
        noFill();
      }
    }
  }
}


public void createStars(int centerX, int centerY, int radius) {
  int[] starColorOptions = new int[]{
    color(255, 255, 0), // Yellow
    color(255, 165, 0), // Orange
    color(173, 216, 230) // Light Blue
  };

  for (int x = centerX - radius; x <= centerX + radius; x++) {
    for (int y = centerY - radius; y <= centerY + radius; y++) {
      if (x >= 0 && x < gridWidth && y >= 0 && y < gridHeight) { // boundary check
        if (isInsideGoldRing(centerX, centerY, x, y, radius)) {
          if (random(1) < 0.00001f && starCount < 18) { //STAR COUNT AND SPAWN RATE
            grid[x][y] = 1; // Star
            starColors[x][y] = starColorOptions[PApplet.parseInt(random(starColorOptions.length))]; //randomize star colors (yellow, orange, light blue)
            starSizes[x][y] = random(1); //randomize star size
            starCount++;
            println("Star created at (" + x + ", " + y + ")");

            // Set the planet colors and sizes for the star
            int starSize = starSizes[x][y] >= 0.45f && starSizes[x][y] < 0.9f ? 2 : (starSizes[x][y] >= 0.9f ? 3 : 1);
            int maxPlanets = starSize == 2 ? 10 : (starSize == 3 ? 14 : 6); // Maximum number of planets based on star size, including both sides

            planetColors[x][y] = new int[maxPlanets];
            boolean hasPlanets = random(1) < 0.4f; //planet spawn probability
             
            int planetCount = 0;
            for (int i = 0; i < maxPlanets; i++) {
              if (planetCount < maxPlanets && hasPlanets) {
                
                
                
                 if (random(1) < 0.99f) { 
                   if (i < maxPlanets / 2) { // Assign colors for left side planets
                    if (starSize == 3) { // Large star with 7 planets
                      if (i < 3) {
                        planetColors[x][y][i] = 2; // First 3 planets are brown
                      } else if (i == 3) {
                        planetColors[x][y][i] = 1; // 4th planet is green
                      } else {
                        planetColors[x][y][i] = 0; // 5th, 6th, 7th planets are blue
                      }
                    } else if (starSize == 2) { // Medium star with 5 planets
                        if (i < 3) {
                          planetColors[x][y][i] = 2; // First 3 planets are brown
                    } else if (i == 3) {
                          planetColors[x][y][i] = 1; // 4th planet is green
                    } else {
                          planetColors[x][y][i] = 0; // 5th planet is blue
                            }
                    } else if (starSize == 1){// Small star with 3 planets
                            if (i < 1 ) {
                              planetColors[x][y][i] = 2; 
                            }
                            else{
                          planetColors[x][y][i] = 1; // All planets are brown
                            }   
                          }      
                     }else { // Assign colors for right side planets using the same colors as left side
                          planetColors[x][y][i] = planetColors[x][y][i - maxPlanets / 2];
                            }
                          planetCount++;
                  println("Planet created for star at (" + x + ", " + y + ")");
                } else {
                  planetColors[x][y][i] = -1;
                }
              } else {
                planetColors[x][y][i] = -1;
}}}}}}}}



public void Planets(int x, int y, int starSize) {
  planetRects.clear(); // Clear the planetRects ArrayList for each star
  int[] colors = new int[3];
  colors[0] = color(0, 0, 255); // Blue
  colors[1] = color(0, 128, 0); // Green
  colors[2] = color(139, 69, 19); // Brown

  int starWidth, starHeight;
  if (starSize == 2) { //medium
    starWidth = gridSize * 9;
    starHeight = gridSize * 9;
  } else if (starSize == 3) { //large 
    starWidth = gridSize * 12;
    starHeight = gridSize * 12;
  } else { //small
    starWidth = gridSize * 6;
    starHeight = gridSize * 6;
  }

int middleX, middleY; // Declare variables before if-else block

  if (starSize == 2) {
    middleX = x * gridSize + starWidth / 2 - gridSize / 2 - 4 * gridSize;
    middleY = y * gridSize + starHeight / 2 - gridSize / 2 - 4 * gridSize;
  } else if (starSize == 3) {
    middleX = x * gridSize + starWidth / 2 - gridSize / 2 - 5 * gridSize;
    middleY = y * gridSize + starHeight / 2 - gridSize / 2 - 5 * gridSize;
  } else {
    middleX = x * gridSize + starWidth / 2 - gridSize / 2 - 3 * gridSize;
    middleY = y * gridSize + starHeight / 2 - gridSize / 2 - 2 * gridSize;
  }

  if (planetColors[x][y] == null || planetColors[x][y].length == 0) {
    return; // If planetColors is null or has no elements, do not proceed with drawing planets
  }

  int planetCount;
  if (starSize == 1) { //small star
    planetCount = 3;
  } else if (starSize == 2) { //medium star
    planetCount = 5;
  } else { //large star
    planetCount = 7;
  }

  // Store planet rectangles in the planetRects ArrayList
  if (planetRects.size() == 0) {
    for (int direction = -1; direction <= 1; direction += 2) { // -1 for left, 1 for right
      int offsetX = (starWidth / 2 + gridSize * 2) * direction; // First planet one tile farther from the edge of the star
      int offsetY = 0;
//print planets

if (maxDrawnPlanetsArray[x][y] < planetColors[x][y].length) {
    maxDrawnPlanetsArray[x][y] = (frameCount / framesPerPlanet) % (planetColors[x][y].length + 1);
  }
  if (maxDrawnPlanetsArray[x][y] < planetColors[x][y].length) {
    maxDrawnPlanetsArray[x][y] = (frameCount / framesPerPlanet) % (planetColors[x][y].length + 1);
  }
  
      for (int i = 0; i < planetCount && i < maxDrawnPlanetsArray[x][y]; i++) {
        int planetX = middleX + offsetX;
        int planetY = middleY + offsetY;
        planetRects.add(new PVector(planetX, planetY));
        offsetX += gridSize * (i + (starSize == 1 ? 1 : 3) + (starSize == 1 ? i + 1 : 0)) * direction;
      }
    }
  }
  
  

  for (int i = 0; i < maxDrawnPlanetsArray[x][y] && i < planetColors[x][y].length; i++) {
    PVector planet = planetRects.get(i);
    int planetColorIndex = planetColors[x][y][i];
    if (planetColorIndex != -1) { // If there is a planet in this grid cell
      fill(colors[planetColorIndex]);
      ellipse(planet.x, planet.y, gridSize, gridSize);
    }
  }
}

///////////// MAIN //////////////
public void setup() { 
  size(200 * 4, 200 * 4); //set grid size
  grid = new int[gridWidth][gridHeight];  
  maxDrawnPlanetsArray = new int[gridWidth][gridHeight];

  starColors = new int[gridWidth][gridHeight]; 
  starSizes = new float[gridWidth][gridHeight];
  
    for (int x = 0; x < gridWidth; x++) {
        for (int y = 0; y < gridHeight; y++) {

            grid[x][y] = 0; //set a black grid

        }
    }
  planetColors = new int[gridWidth][gridHeight][];

}

// Detect mouse click to start the burn
public void mousePressed() {
  if (!burnStarted) {
    startX = mouseX / gridSize;
    startY = mouseY / gridSize;
    burnStarted = true;
}}

// Big Bang Appearence
public void draw() {
  background(0, 0, 33); // Set background to midnight blue

  if (burnStarted) {
    if (currentRadius < gridWidth || currentRadius < gridHeight) { 
      createGoldRing(startX, startY, currentRadius);
      currentRadius++;

      if (blackRadius >= 0) {
        createBlackRing(startX, startY, blackRadius); //makes the gold ring have more of a ring appearance
        whiteStars(startX, startY, blackRadius); //generate white stars
        createStars(startX, startY, blackRadius); //generate stars
      }
      blackRadius++;
    }
  }

  printWhiteStars(startX, startY, blackRadius); //print white stars
  printStars(startX, startY, blackRadius); //print stars
}
