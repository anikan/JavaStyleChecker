import java.awt.*; // for Color
import java.util.*;

/* 
 *  Name: Yunhan Wang
 *  Login: cs8bkv
 *  Date: May 11 , 2015
 *  File: MyCritter.java
 *  Sources of Help: None
 *
 *  CSE8B assignment 6.
 *  This class is create a critter named MyCritter. Its color is blue
 *  and it always hungry. The myCritter moves 6 steps in a
 *  random direction (north, south, east, or west), then chooses a 
 *  new random direction and repeats. But in the beginning if critters
 *  never ate anything they will mate and will not move. After the first
 *  mating they will move six steps randomly. When the myCritter meets "B"
 *  it will roar or pounce. It depends on the random number; when
 *  meets "L" it will pounce; when meets "0" it will will scratch; 
 *  when meets others will roar. MyCritter is a blue "B" in the game.
 */

public class MyCritter extends Critter {
	// field
	// instance variables
	private int fightCounter;
	private Color color;
	private int moveCounter;
	private int counter;
	private int direction;
	private Random random;
	private int directionNum;
	private int fight;
	private int fightNum;
	private int eatingNum;

	// constructor
	// initialize instance variables
	public MyCritter() {
		this.color = Color.BLUE;
		this.fightCounter = 0;
		this.counter = 0;
		this.moveCounter = 0;
		this.directionNum = 4;
		this.random = new Random();
		this.direction = random.nextInt(directionNum);
		this.fightNum = 3;
		this.fight = random.nextInt(fightNum);
		this.eatingNum = 0;
	}

/*
 * Name: eat
 * Purpose: Override the eat method from the super class
 * and ask the lion whether it want eat or not
 * if the lion fighted it will hungry and will eat
 * Parameters: none
 * Return: @Return true or false Type: boolean  return true to eat
 * false mean not hungry
 */
	@Override
	public boolean eat() {
		// if the lion did not fight before meeting food
		// set the fight counter to zero and return true
		// otherwise return false do not eat
		eatingNum++;
		return true;
	}

/*
 * Name: fight
 * Purpose: Override the fight method from the super class
 * The method is to return the kind of fight when
 * lion meet the opponent If the opponent is bear the lion will
 * roar otherwise will pounce.
 * Parameters: @param opponent Type: String It is the opponent
 * the lion meet with
 * Return: @Return Attack.ROAR or Attack POUNCE Type: Attack 
 * It is the kind of fight the lion will use
 */
    @Override
	public Attack fight(String opponent) {
        // if the opponent is "L" will pounce
	    if(opponent.equals("L")) {
	    	return Attack.POUNCE;
	    }
	    // if the opponent is "B" it will roar
	    // or pounce depends on the random number
	    else if(opponent.equals("B")) {
	    	if(fight == 0 || fight == 1) {
	    		return Attack.POUNCE;
	    	}
	    	else
	    	    return Attack.ROAR; //roar
	    }
	    // if the opponent is "E" it will roar
	    // or pounce or roar depends on random
	    // numbers
	    else if(opponent.equals("E")) {
	    	//if(fight == 0) return Attack.POUNCE;
	    	//else if (fight == 1) return Attack.SCRATCH;
	    	//else return Attack.POUNCE;
	    	return Attack.POUNCE;
	    }
	    // if the opponent is "0" will scratch
	    // else will roar
	    else if(opponent.equals("0")) {
	    	return Attack.SCRATCH;
	    }
	    else {
	    	return Attack.ROAR;
	    }
    }

/*
 * Name: getMove
 * Purpose: Override the getMove method from the super class
 * The method is to lead lion to first go south 5 times, then
 * go west 5 times, then go north 5 times, then go east 5 times
 * (a clockwise square pattern), then repeat. If the critter
 * never ate food they will mate and will not move. after mating,
 * they can move and eat.
 * Parameters: none
 * Return: @Return Direction.EAST Direction.SOUTH Direction.NORTH
 * Direction.WEST Type: Direction
 * It is the direction the lion will move to
 */
    @Override
	public Direction getMove() {
		// if the critter did not eat food and some food near
		// the critter increment the eatingNum mate and will
		// not move
		if(eatingNum == 0) {
			if(getNeighbor(Direction.SOUTH).equals(".")
				|| getNeighbor(Direction.NORTH).equals(".")
				|| getNeighbor(Direction.EAST).equals(".")
				|| getNeighbor(Direction.WEST).equals(".")) {
				eatingNum++;
				mate();
				return Direction.CENTER;
			}
		}
		else {
			// create these direction numbers
			int south = 0;
			int north = 1;
			int east = 2;
			int specifySteps = 6;
			// if the counter is larger or equal to the specify steps
			// reset the counter and get a new random number between 0 and 3
			if(counter >= specifySteps) {
				counter = 0;
				direction = random.nextInt(directionNum);
			}
			// if the random number is 0 go to south
			// if the number is 1 go to north
			// if the number is 2 go to east
			// else go to west
			if(direction == south) {
				counter++;
				return Direction.SOUTH;
			}
			else if(direction == north) {
				counter++;
				return Direction.NORTH;
			}
			else if(direction == east) {
				counter++;
				return Direction.EAST;
			}
			else {
				counter++;
				return Direction.WEST;
			}
		}
		return Direction.WEST;
	}


/*
 * Name: getColor
 * Purpose: Override the getColor method from the super class
 * and get the lion's color
 * Parameters: none
 * Return: @Return color Type: Color  It is the lion's color
 */
    @Override
    public Color getColor() {
    	return color;
    }

/*
 * Name: toString
 * Purpose: Override the toString method from the super class 
 * and make lion convert to string.
 * Parameters: none
 * Return: @Return "L" Type: String  return the converted lion 
 */
    @Override
	public String toString() {
		return "B";
	}
}
