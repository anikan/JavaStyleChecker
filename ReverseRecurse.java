import java.awt.*;
import java.util.*;
import java.io.*;
/* 
 *  Name: Yunhan Wang
 *  Login: cs8bkv
 *  Date: May 11 , 2015
 *  File: ReverseRecurse.java
 *  Sources of Help: None
 *
 *  CSE8B assignment 6.
 *  This class is to initialize an array, print array and reverse 
 *  the elements in the array via two different recursive methods
 *  (One method modifies the original array and the other method 
 *  returns a new array with the elements reversed preserving the 
 *  original array. This class can read values from keyboard into 
 *  an array whose size is specified by the user(the user may enter 
 *  fewer integers than the size specified, but not more). InitArray()
 *  will ask the user for a maximum number of integers expected, create 
 *  an array of the integers that size, read at most that many integers 
 *  from the keyboard using a scanner object(ignore extra input beyond 
 *  the size of the array. Keep asking the the user for a positive integer
 *  greater than 0 until a valid value is entered. if the user indicates 
 *  EOF or input any non-integers will exit. if after seting the size
 *  return the array which has been resized.
 */

public class ReverseRecurse {
	// field
	int size;
	int[] array;

	//counstructor
	public ReverseRecurse() {

	}

/*
 * Name: initArray
 * Purpose: read values from keyboard into an array whose 
 * size is specified by the user(the user may enter 
 * fewer integers than the size specified, but not more).
 * Parameters: none
 * Return: @Return array Type: int[] return the array which
 * has been initialized
 */
	public int[] initArray() {
		// use a scanner to read what the user input
		Scanner input = new Scanner(System.in);
		int position = 0;
		// the variable is to check whether the 
		// size is valid or not
		boolean isMaxSizeValid = false;
		System.out.println(PA6Strings.MAX_NUM);
		
		// while the next input is integers
		while (input.hasNextInt()) {
			// get the next input integer and check
			// whether the value is greater than 0
			// if the value is greater than 0 it is
			// the valid array size and stop
			int val = input.nextInt();
			if (val > 0) {
				size = val;
				isMaxSizeValid = true;
				break;
			} 
			// else should let the user input the size again
			// until the user input a integer and it is greater
			// than zero
			else {
				System.out.println(PA6Strings.TOO_SMALL);
				System.out.println(PA6Strings.MAX_NUM);
			}
		}
		
		// if the size has not been seted exit the program
		// else initialize the array and its size is the size
		if (!isMaxSizeValid) {
			//eof
			System.exit(1);
		} else {
                        System.out.printf(PA6Strings.ENTER_INTS, size);
			array = new int[size];
            
                        // while the next input is integers
			while (input.hasNextInt()) {
				// if the count is greater than size -1 stop
				// get the input integer and add it into the
				// array increment the count
				if (position <= size - 1) {
					int val = input.nextInt();
					array[position] = val;
					position++;
				} else {
					int wasted = input.nextInt();
					position++;
				}
				
			}

			//if eof or counter > size -1
			if (position < size) {
				//eof
				// resize the array which size is count
				// copy the array to the resizedarray and
				// return the resizedarray
				int[] resizedArray = new int[position];
				System.arraycopy(array,0,resizedArray,0,position);
				return resizedArray;
			}
		}
		// return the array
		return array;
	}

/*
 * Name: printArray
 * Purpose: print the array one by one in a line 
 * Parameters: @Param array Type: int[] it is the array
 * which will be printed
 * Return: none
 */
	public void printArray(int[] array) {
		// if empty array print "empty array!"
		if(array == null || array.length == 0) {
			System.out.println(PA6Strings.EMPTY);
		}
		// else print the array's element in one line 
		// and then print a new blank line
		else {
			for(int i = 0; i < array.length; i++) {
			    System.out.print(array[i]);
			    if (i != array.length - 1) {
			    	System.out.print(" ");
			    }
			    else {
			    	System.out.println("\n");
			    }
			}
                }
	}

/*
 * Name: reverse
 * Purpose: directly manipulate the array passed in by exchanging 
 * the low and high index values and recurse on the remaining 
 * middle/center elements of the array by passing modified
 * values of low and high in the recursive call.
 * Parameters: @Param originalArray Type: int[] it is the array 
 * should be reversed
 *             @Param low Type: int it is the element's position
 *             @Param high Type: int it is the element's position
 * Return: none
 */
    public void reverse(int[] originalArray, int low, int high) {
		// if it is an empty line exit the program
		if(originalArray == null || originalArray.length == 0) {
			return;
		}
		// base
		// if low greater than high stop and exit
		if (low > high) {
			return;
		}
                // the variable is to save the element
		int temp = originalArray[low];
		// switch two elements(reverse)
		originalArray[low] = originalArray[high];
		originalArray[high] = temp;
		low++;
		high--;
		// recall the reverse method
		reverse(originalArray, low, high);
	}

/*
 * Name: reverse
 * Purpose: copy the originalArray and reverse the copy array 
 * Parameters: @Param originalArray Type: int[] it is the array 
 * should be copied
 * Return: @Return copyArray Type: int[] it is the array which has
 * been reversed
 */
	public int[] reverse(int[] originalArray) {
		// if it is an empty array exit the program
		if(originalArray == null || originalArray.length == 0) {
			return null;
		}
		//base
		// if the array's size is one no need to reverse
		if (originalArray.length == 1) {
			return originalArray;
		}
		// get the originalArray and create
		// an array which size is same as original
		int length = originalArray.length;
		int[] copyArray = new int[length];
                // add the end of the elements into the beginning of the copyarray
		copyArray[0] = originalArray[length - 1];
		// add the beginning element into the end of the copyarray
		copyArray[length - 1] = originalArray[0];
        
                // if the size is two it is already been reversed
		if (length == 2) {
                        return copyArray;
                }
                // create an array to contain the middle of the original array
		int[] middles = new int[originalArray.length - 2];
		// copy the middle of the original array into the middles
		System.arraycopy(originalArray, 1, middles, 0, length - 2);
		// reverse the middles
		int[] reversedMiddles = reverse(middles);
                // copy the reversedMiddles into the copy array
		System.arraycopy(reversedMiddles, 0, copyArray, 1, length - 2);
                // return copy array
		return copyArray;		
	
	}
}
