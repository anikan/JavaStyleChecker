
import java.awt.*;

public class Lion extends Critter{

	private boolean hungry = false;
	private Direction curDir = Direction.SOUTH;
	private int numTimes = 0;

		public Lion()
		{
		}

	public boolean eat()
	{
		return hungry;
	}
	public Color getColor() {
		return Color.RED;
	}
  public Attack fight(String opponent) {
	hungry = true;

	if (opponent.equals("B"))
	{
		return Attack.ROAR;
	}

    return Attack.POUNCE;
  }
	public Direction getMove() {

		if (numTimes < 5)
		{
			numTimes++;
		}

		else
		{
			numTimes = 1;
			
			if (curDir == Direction.SOUTH)
			{
				curDir = Direction.WEST;
			}
			else if (curDir == Direction.WEST)
			{
				curDir = Direction.NORTH;
			}
			if (curDir == Direction.NORTH)
			{
				curDir = Direction.EAST;
			}
			if (curDir == Direction.EAST)
			{
				curDir = Direction.SOUTH;
			}



		}

		return curDir;
	}
//llo
////////////////
	public String toString()
	{
		return "L";
	}

}
