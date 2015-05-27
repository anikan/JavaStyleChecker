/*
 * Login: cs8bgg
 * Date: May 14, 2015
 * File: MyCritter.java
 * Sources of help: tutors and the book 
 *
 * This program creates a tiger, makes it eat if the first hunger 
 * time is called.
 */

import java.awt.*; 
import java.util.*;

public class MyCritter extends Critter{
//instance variables referenced throughout the class
private int NORTH = 0;
private int SOUTH = 1;
private int EAST = 2; 
private int WEST = 3; 
private int hunger; 
private int value; 
private int steps; 
private Random isRandom; 
private Color BLUE = new Color(0,0,255);

/* Name: Shark 
 * Purpose: initializes the instance variables  
 * Parameters: none
 * Return:none
*/
public MyCritter(int hunger){
	//member variable gets set to what is passed in 
	this.hunger = hunger; 
	isRandom = new Random(); 
	value = 0; 
	steps = 6; 
}

/* Name: eat 
 * Purpose: my critter always eats 
 * Parameters: none 
 * Return: a boolean
*/
public boolean eat(){
	//my critter always eats
	return true; 
}

/* Name: fight
 * Purpose: to implement the attack that will beat the counter critters
 * so because bear always scratches, my critter will roar which beats 
 * scratches 
 * Paramaters: opponent which is a string 
 * Return: an attack  
*/
public Attack fight(String opponent){
	//if its opponent is a Bear then the roars
	if(opponent.equals("B")){
	  return Attack.ROAR;
	} 
	//if its opponent is a lion it scratches 
	if(opponent.equals("L")){
	  return Attack.SCRATCH; 
	}
	//if its a tiger is scratches 
	if(opponent.equals("0")){
	  return Attack.SCRATCH; 
	}
	else{
	  return Attack.ROAR; 
	}
}

/* Name: getColor
 * Purpose: makes my critter blue 
 * Parameters: none 
 * Return: a color  
*/
public Color getColor(){
	return Color.YELLOW;  
}

/* Name: getMove 
 * Purpose: radnomyl moves my critter 
 * Parameters: none 
 * Return: as direction 
*/
public Direction getMove(){
	//checks to see if my critter takes 9 steps 
	if (steps % 8 == 0){
	value = isRandom.nextInt(4);
	steps = 0;
	} 
	//if 0 then increments and moves north
	if (value == NORTH){
	   steps++;
	   return Direction.NORTH; 
	}
	//if 1 then increments steps and moves south 
	else if(value == SOUTH){
	   steps++;
	   return Direction.SOUTH;
	}
	//if 3 then increments steps and moves west
	else if(value == WEST){
	   steps++; 
	   return Direction.WEST;
	}
	else{
	   steps++; 
	   return Direction.EAST; 
	}	
	}


/* Name: toString 
 * Purpose: returns the string S
 * Parameters: none 
 * Return: returns a string  
*/
public String toString(){
	return "0";
	}
	}
