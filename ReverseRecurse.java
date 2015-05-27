import java.util.*; 


public class ReverseRecurse{

/* Name: initArray  
 * Purpose: asks the user for a maximum number of integers expected, 
 * creates an array of integers that size, reads that many integers 
 * and returns the initialized array 
 * Parameters: none
 * Return: an int array 
*/

public int[] initArray(){
    Scanner in = new Scanner(System.in);
	System.out.printf(PA6Strings.MAX_NUM);
	int size = 0;
	int i = 0; 
	//String exit = "EDF";
	//checks to see if an int has been inputed 
	if(in.hasNextInt()){
		//stores it temporarily in temp
		int temp = in.nextInt();
	if(temp > 0){
		//size if re intialized to the next int
		size = temp;
          	System.out.printf(PA6Strings.ENTER_INTS, size);
	  }
	  
	else if (size <= 0){
		System.out.printf(PA6Strings.TOO_SMALL);
        }
	 
   }	  
	//creates a new int array 	
	int[] initialArray = new int[size];
	for( i = 0; i < size; i++){
	if (in.hasNextInt()){
		initialArray[i] = in.nextInt();
	}
	else{
		size = in.nextInt();
		//new int array to take in the actual number of ints inputed 
		int[] nextArray = new int[size];
       		nextArray[i] = nextArray[0];
		System.arraycopy(initialArray, 0, nextArray,0,size); 	
		return nextArray; 
	}

    }
	return initialArray; 

}

/* Name: printArray
 * Purpose: cycles through the passed array printing each integer
 * on the same line 
 * Parameters: an int array 
 * Return: none
*/

public void printArray (int[] array){
	if(array.length == 0){
		System.out.printf(PA6Strings.EMPTY);
	}
	for (int i = 0; i < array.length; i++){
		System.out.printf(array[i] + " "); 
	}
		System.out.println();
   }


/* Name: reverse
 * Purpose: directly manipulates the array passed in by exxhanging the 
 * low and high index values and recurse on the reamining middle/center
 * elements of the array by passing modified values of low and high in 
 * the recursive call.    
 * Parameters: orginalArray which is an int array & low and high of type int
 * Return: none
*/

public void reverse (int[] originalArray, int low, int high){
	//checks my base cases 
	if (originalArray == null){
		return; 
	}
	else if (low < high){
		int size = originalArray[low];
		originalArray[low] = originalArray[high];
		originalArray[high] = size; 
		reverse(originalArray, ++low, --high);
	}
	else{ 
		return;
	}
   }

/* Name: initArray  
 * Purpose:  copies the frst element of the original array into the last 
 * slot of a new array to hold the reverse of the passed array and copy
 * the last element of the original array into the first slot. 
 * Parameters: originalArray which is an int array type 
 * Return: an int array of the copy 
*/

public int[] reverse (int[] originalArray){
	int size = originalArray.length;
	int[] copyArray = new int[size]; 
        int[] midArray = new int[size-2]; 

	if(originalArray.length == 0 || originalArray.length == 1){
		return midArray; 
	}
	else{
		copyArray[0] = originalArray[originalArray.length-1];
		copyArray[originalArray.length-1] = originalArray[0];
	}
	System.arraycopy(originalArray, 0, midArray, 1, size);
	System.arraycopy(reverse(midArray), 1, copyArray, 0, size-2);
	
	
	return copyArray; 
    }
}
