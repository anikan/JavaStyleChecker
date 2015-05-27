// Name: Michael Flatebo
// Login: cs8bbd
// Date: May 14, 2015
// File: ReverseRecurse.java
// Sources of Help: NA
//
// This Class allows the user to create an array of integer inputs and has
// two methods to reverse the array recursively. One method changes the
// oringinal array while the other returns a new reversed array.

import java.util.Scanner;

public class ReverseRecurse {

// Name: initArray()
// Purpose: This method allows the user to create an array of desired 
// lenth. Then the user can fill the array with integers of their chosing.
// If they exit the method before filling the array then the array is shrunk
// to the number of inputs.
// Parameters: None
// Return: int[] returns the int array created by the user. 

	public int[] initArray() {
		// creates new scanner to take user input
		Scanner in = new Scanner( System.in );
		int size = 0;
		// asks for array size unitl user inputs a positive number
		do
		{
			System.out.println( PA6Strings.MAX_NUM );
			if ( in.hasNextInt() ) {
				size = in.nextInt();
				if ( size < 0 ){
					System.out.println(PA6Strings.TOO_SMALL);
				}
			}	
			else 
				System.exit(1);
				
		}while ( size < 0);
		// creates an array the size specified by user
		System.out.printf(PA6Strings.ENTER_INTS, size);	
		int[] firstArray = new int[size];
		int i;
		// fills that array with integers provided by the user
		for ( i = 0; i < firstArray.length; i++){
			int value;
			if ( in.hasNextInt() ){
				value = in.nextInt();
				firstArray[i] = value;
			}
			else
				break;	
				
		}
		// trims the size of the array to the number of actual inputs
		int[] finalArray = new int[i];
		System.arraycopy( firstArray, 0, finalArray, 0, i);
		return finalArray;	

	}

// Name: printArray
// Purpose: Prints the inputed integer array with spaces between each
// integer
// Parameter: int[] array, array of integers desired to be printed out
// Return: None

	public void printArray ( int[] array ) {
		if ( array.length == 0 )
			System.out.println( PA6Strings.EMPTY );
		else{
			for ( int i = 0; i < array.length; i++ )
				System.out.print( array[i] + " " );
		}
		System.out.println();
	}

// Name: reverse
// Purpose: This method reverses the array given to it using the highest 
// index and lowest index.
// Parameters: int[] originalArray; the array that should be reversed, 
// int low; the lower index that will be sent to the high index
// int high; the index of the high value that will be sent to the low index
// Return: void

	public void reverse( int[] originalArray, int low, int high ) {

		if ( originalArray == null )
			return;
		if ( low == high || low > high )
			return;
		else {
			int storage = originalArray[low];
			originalArray[low] = originalArray[high];
			originalArray[high] = storage;
			low++;
			high--;
			reverse( originalArray, low, high );
		}

		
	}

// Name: reverse
// Purpose: reverses the array inputed by continually reversing smaller
// and smaller arrays and replacing it back into the original
// Parameter: int[] originalArray; the array that should be reversed. 
// Return: int []; returns the reversed array
	public int[] reverse ( int[] originalArray ) {
		// returns the null array 
		if ( originalArray == null )
			return originalArray;
		// base case when there is no integers to reverse
		else if ( originalArray.length == 0)
			return originalArray;
		// base case when there is only one integer to reverse
		else if ( originalArray.length == 1)
			return originalArray;
		// recursive step for arrays with more than 1 integers
		else
		 {
			int [] toReturn = new int[originalArray.length];
			// sends the first to the end of the new array
			toReturn[0] = originalArray[originalArray.length-1];
			// sends the last to the begginning of the new array
			toReturn[toReturn.length-1] = originalArray[0];
			int middleLength = originalArray.length-2;
			// creates a new array with only the middle elements of the
			// original array
			int [] middleArray = new int[middleLength];
			System.arraycopy(originalArray, 1, middleArray, 0, middleLength);
			// Recursively copies the flipped array into the other array
			System.arraycopy(reverse( middleArray ), 0, toReturn, 1, 
				middleLength);
			return toReturn;			


		}
		


	}
}
