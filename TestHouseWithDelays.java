/**
 * Program to test various Shapes per CSE 8B - Inheritance
 * homework.
 *
 * Uses an ActiveObject and run() method to provide animation with delays
 * between drawing different parts of a house.
 *
 * Invoked from TestHouseWithDelaysController.java which is in turn
 * created as part of TestHouseWithDelays.html
 */

import javax.swing.*;
import java.awt.*;
import objectdraw.*;

public class TestHouseWithDelays extends ActiveObject
{
  private static final int DELAY = 500;

  private DrawingCanvas canvas;

  /**
   * The ctor that gets it all going.
   */
  public TestHouseWithDelays( DrawingCanvas canvas )
  {
    this.canvas = canvas;	// Need this to tell objects where to draw.
				// Gotten from the GUI controller object.

    start();			// Start the animation.
  }

  /**
   * The single animation thread.
   */
  public void run()
  {
    int xCenter = canvas.getWidth() / 2;
    int yCenter = canvas.getHeight() / 2;

    Rectangle house = new Rectangle( xCenter - 100, yCenter, 200, 100 );

    Point p1 = new Point( xCenter - 100, yCenter );
    Point p2 = new Point( xCenter + 100, yCenter );
    Point p3 = new Point( xCenter, yCenter - 100 );

    Triangle roof = new Triangle( p1, p2, p3 );

    Rectangle chimney = new Rectangle( xCenter + 50, yCenter - 75, 25, 75 );

    Square window = new Square( xCenter - 75, yCenter + 25, 30 );
    CSE8B_Line pane1 =
        new CSE8B_Line( new Point( xCenter - 60, yCenter + 25 ),
                        new Point( xCenter -60, yCenter + 55 ) );
    CSE8B_Line pane2 =
        new CSE8B_Line( new Point( xCenter - 75, yCenter + 40 ),
                        new Point( xCenter - 45, yCenter + 40 ) );

    Rectangle door =
        new Rectangle( new Point( xCenter -20, yCenter + 20 ), 40, 70 );

    Circle doorknob = new Circle( new Point( xCenter -10, yCenter + 55 ), 3 );


    /*
     * Start drawing these objects along with their toString() implementations.
     */
    						// house.toString()
    Text text = new Text( "Drawing the house - " + house,
                          xCenter, yCenter + 100, canvas  );
    text.move( -text.getWidth() / 2, 0 );
    pause( DELAY );

    house.draw( canvas, Color.GREEN, true );	// filled, green
    pause( DELAY );

    house.draw( canvas, null, false );		// not filled, black outline
    pause( DELAY );

    text = new Text( "Drawing the chimney - " + chimney,
                      xCenter, yCenter + 115, canvas  );
    text.move( -text.getWidth() / 2, 0 );
    pause( DELAY );

    chimney.draw( canvas, Color.RED, true );	// red chimney
    pause( DELAY );

    chimney.draw( canvas, Color.BLACK, false );	// black outline
    pause( DELAY );

    text = new Text( "Drawing the roof frame - " + roof,
                      xCenter, yCenter + 130, canvas  );
    text.move( -text.getWidth() / 2, 0 );
    pause( DELAY );

    roof.draw( canvas, null, true );		// black outline of roof
    pause( DELAY );

    text = new Text( "Drawing the left window - " + window,
                      xCenter, yCenter + 145, canvas  );
    text.move( -text.getWidth() / 2, 0 );
    pause( DELAY );

    window.draw( canvas, Color.WHITE, true );	// white window
    pause( DELAY );

    window.draw( canvas, Color.BLUE, false );	// blue trim
    pause( DELAY );

    text = new Text( "Drawing 1st window pane - " + pane1,
                      xCenter, yCenter + 160, canvas  );
    text.move( -text.getWidth() / 2, 0 );
    pause( DELAY );

    pane1.draw( canvas, Color.BLUE, false );	// blue window panes
    pause( DELAY );

    text = new Text( "Drawing 2nd window pane - " + pane2,
                      xCenter, yCenter + 175, canvas  );
    text.move( -text.getWidth() / 2, 0 );
    pause( DELAY );

    pane2.draw( canvas, Color.BLUE, false );	// blue window panes
    pause( DELAY );

    /*
     * Draw and move the right window and panes via a generic Shape
     * reference - real polymorphism.
     */

    Shape newWindow = new Square( window );	// Square's copy ctor
    newWindow.move( 115, 0 );			// Square's move()

    text = new Text( "Drawing the right window - " + newWindow,
                      xCenter, yCenter + 190, canvas  );
    text.move( -text.getWidth() / 2, 0 );
    pause( DELAY );

    newWindow.draw( canvas, Color.WHITE, true );
    pause( DELAY );
    newWindow.draw( canvas, Color.BLUE, false );
    pause( DELAY );

    // Don't bother printing the next two pane's String representation

    Shape newPane1 = new CSE8B_Line( pane1 );	// CSE8B_Line's copy ctor
    newPane1.move( 115, 0 );			// CSE8B_Line's move()
    newPane1.draw( canvas, Color.BLUE, false );
    pause( DELAY );

    Shape newPane2 = new CSE8B_Line( pane2 );	// CSE8B_Line's copy ctor
    newPane2.move( 115, 0 );			// CSE8B_Line's move()
    newPane2.draw( canvas, Color.BLUE, false );
    pause( DELAY );

    text = new Text( "Drawing the door - " + door,
                      xCenter, yCenter + 205, canvas  );
    text.move( -text.getWidth() / 2, 0 );
    pause( DELAY );

    door.draw( canvas, Color.ORANGE, true );	// orange door
    pause( DELAY );

    door.draw( canvas, Color.RED, false );	// with a red trim
    pause( DELAY );

    text = new Text( "Drawing the door knob - " + doorknob,
                      xCenter, yCenter + 220, canvas  );
    text.move( -text.getWidth() / 2, 0 );
    pause( DELAY );

    doorknob.draw( canvas, Color.RED, false );	// red doorknob
    pause( DELAY );


    text = new Text( "Filling in the roof - " + roof,
                      xCenter, yCenter + 235, canvas  );
    text.move( -text.getWidth() / 2, 0 );
    pause( DELAY );

    roof.draw( canvas, null, true );

    /*
     * Hack to draw a solid roof since objectdraw library does not have a
     * FilledPolygon class for our class Triangle to use.
     */

    while ( p3.getY() != p1.getY() )
    {
      Triangle roofFill;
      p3 = new Point( p3.getX(), p3.getY() + 1 );

      roofFill = new Triangle( p1, p2, p3 );
      roofFill.draw( canvas, Color.GREEN, true );
      pause( DELAY/10 );
    
      text.setText( "Filling in the roof - " + roofFill );
    }

    roof.draw( canvas, null, true );	// draw the black roof outline

    /*
     * Not Extra Credit.
     * Possible other things to add to test the Shapes classes:
     * Add a sun with rays coming out.
     * Add a garage.
     * Add a walkway to the front door.
     * Add a driveway. 
     *
     * Spell out "CSE 8B" using CSE8B_Line objects.
     */
  }

} // End of class 
