// Name: Michael Flatebo 
// Login: cs8bbd
// Date: May 14, 2015
// File: MyCritter.java
// Sources of Help: NA
//
// This class defines the ulitmate character in the critter game. It 
// defines the critters movements, fighting style, appearance, and hunger

import java.awt.*;
import java.util.Random;

public class MyCritter extends Critter {
  int direction;
  int stepCount = 0;
  public MyCritter() {
  }
  

// Name: Eat
// Purpose: Tells MyCritter if it should eat when it reaches food
// Parameters: None
// Return: Boolean: true if should eat, false if it shouldn't

  public boolean eat() {
    return true;
  }

// Name: Fight
// Purpose: Tells MyCritter which attack to use in a fight
// Parameters: 
// Return: Attack; the type of attack to use

  public Attack fight(String opponent) {
   // attacks roar if fighting a bear
    if ( opponent == "B" )
      return Attack.ROAR;
    // attacks scratch if opponent is a lion
    else if ( opponent == "L" )
      return Attack.SCRATCH;
    // attacks scratch if opponent is a tiger without an appetite
    else if ( opponent == "0" )
      return Attack.SCRATCH;
    // otherwise attacks Roar
    else 
      return Attack.ROAR;
     
      }

// Name: getColor
// Purpose: Tells the game which color to paint MyCritter
// Parameters: None
// Return: The color MyCritter will be

  public Color getColor() {
    return Color.BLUE;
  }

// Name: getMove
// Purpose: Tells the character which direction to move
// Parameters: None
// Return: Direction: Which direction to move

  public Direction getMove() {
  // Every fifth step randomly picks a new direction
   if ( stepCount%5 == 0 )
    {
    Random isRandom = new Random();
    direction = isRandom.nextInt(4);
    }
  
  // if statement for each direction possibility
  if ( direction == 1 )
    {
    stepCount += 1;
    return Direction.NORTH;
    }

  if ( direction == 0 )
    {
    stepCount += 1;
    return Direction.WEST;
    }

  if ( direction == 2 )
    {
    stepCount += 1;
    return Direction.SOUTH;
    }

  if ( direction == 3 ) 
    {
    stepCount += 1;
    return Direction.EAST;
    }
  return Direction.CENTER;
  }

// Name: ToString
// Purpose: Tells the game how to draw MyCritter
// Parameters: None
// Return: String; M for MyCritter

  public String toString() {
    return "M";
  }
  }
