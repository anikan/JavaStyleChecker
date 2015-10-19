# JavaStyleChecker
Made by Anish Kannan with help from Nick Crow and Purag Moumdjian for CSE8B Spring 2015. Still being updated for CSE11 Fall 2015 :>

Checks style for Ord's CSE 8B and CSE 11 Java assignments

I recommend using it to double check grading as opposed to relying on it.

## What it does:
* For every passed in file: 
* It first checks how much of the file is comments.
* Then checks for missing method, class, and file headers. (Currently not checking javadoc style).
* Then one letter (i,j,k) and one letter and multiple number (i1,j2234,k3) variable names when assigned or declared (Thanks to Purag Moumdjian).
* Then lines over 80 characters.
* Then magic numbers. Makes sure that it isn't just assigning an instance variable and ignores magic nums in comments.
* Then checks indentation.
* Finally it sums up all issues from all passed in files and displays results and optionally copy pastable comments.

## Options: 
* -v: Verbose- display lines and line numbers that have issues. Results of grep and diff are distinguished using "!" and the type of error.
* -c: Comments- gives copy pastable comments for the issues that you can just put into the spreadsheet.

## How to use:
1. First clone the repo to your account. Then either move "stylechecker.sh" to the students directory or know the path to the students files.
2. In shell, type "./styleChecker (options) (file1) (file2) (file3) ..."
	
I use "./styleChecker -vc *.java".

## Example output:
#### No options:
```
[cs11fxx@ieng6-202]:pa3:527$ ./styleChecker.sh FlippingDeadmau5.java
**********Checking FlippingDeadmau5.java*****************************************

**********Checking for comment proportions***************************
** 3.00% of FlippingDeadmau5.java is comments. 25%-50% is usually good.


**********Checking for lines over 80 characters**********************
** 2 lines over 80 chars in FlippingDeadmau5.java


**********Checking for bad variable names****************************
** 1 bad variable names in FlippingDeadmau5.java


**********Checking for missing file headers**************************
** Missing File Header in FlippingDeadmau5.java


**********Checking for missing method headers************************
** Missing method header for main in FlippingDeadmau5.java
** Missing method header for onMouseClick in FlippingDeadmau5.java

**********Checking for missing class headers*************************
** Missing class Header for FlippingDeadmau5 in FlippingDeadmau5.java

**********Checking for magic numbers*********************************
** 1 magic nums in FlippingDeadmau5.java


**********Checking for indentation***********************************
Detected 4 space indentation.
1 lines seem to have poor indentation.
-----RESULTS-----
3.00% of files are comments. 25%-50% is usually good.
2 missing method headers.
1 missing class headers.
1 missing file headers.
1 bad variable names.
2 lines over 80.
1 lines incorrectly indented.
1 magic numbers.
```

#### -vc Options:
```
[cs11fxx@ieng6-202]:pa3:528$ ./styleChecker.sh -vc FlippingDeadmau5.java
**********Checking FlippingDeadmau5.java*****************************************

**********Checking for comment proportions***************************
** 3.00% of FlippingDeadmau5.java is comments. 25%-50% is usually good.


**********Checking for lines over 80 characters**********************
!Over 80 Chars: FlippingDeadmau5.java:9:    // additional variables you might need and begin() and the event handling methods
!Over 80 Chars: FlippingDeadmau5.java:11:        new Acme.MainFrame(new FlippingDeadmau5(), args, CANVAS_WIDTH, CANVAS_HEIGHT);
** 2 lines over 80 chars in FlippingDeadmau5.java


**********Checking for bad variable names****************************
!Bad Var Name: FlippingDeadmau5.java:19:                x5 = new Deadmau5(point, canvas);
** 1 bad variable names in FlippingDeadmau5.java


**********Checking for missing file headers**************************
** Missing File Header in FlippingDeadmau5.java


**********Checking for missing method headers************************
** Missing method header for main in FlippingDeadmau5.java
** Missing method header for onMouseClick in FlippingDeadmau5.java

**********Checking for missing class headers*************************
** Missing class Header for FlippingDeadmau5 in FlippingDeadmau5.java

**********Checking for magic numbers*********************************
!Magic Num: FlippingDeadmau5.java:Line 17:            if (mau5 == 2)
** 1 magic nums in FlippingDeadmau5.java


**********Checking for indentation***********************************
Detected 4 space indentation.
1 lines seem to have poor indentation.
!Indentation: FlippingDeadmau5.java:Line 6:    private Deadmau5 mau5;
-----RESULTS-----
3.00% of files are comments. 25%-50% is usually good.
2 missing method headers.
1 missing class headers.
1 missing file headers.
1 bad variable names.
2 lines over 80.
1 lines incorrectly indented.
1 magic numbers.
-----COMMENTS-----
* You seem to be missing a file header for FlippingDeadmau5.java
* You seem to be missing a method header for main in FlippingDeadmau5.java
* You seem to be missing a method header for onMouseClick in FlippingDeadmau5.java
* You seem to be missing a class header for FlippingDeadmau5 in FlippingDeadmau5.java
* You seem to be using a magic number on line 17 in FlippingDeadmau5.java
* You seem to have variables with bad names. Try to make sure that they are descriptive of their purpose. Even loop iterator names should be descriptive. For example: "for (int i =0...)" would be bad.
* You seem to have lines going over 80 characters. I recommend using "grep .{,80} <fileName>" to check if there are bad lines.
* You seem to have lines that are improperly indented. Try using the "gg=G" command, it indents everything for you.
* Magic Numbers make modifying them later difficult. I recommend making a private static final variable to store this value instead.
```

## Known issues: 
* grep doesn't like it when there aren't space characters at the front. Shouldn't be an issue unless their style is really bad.
* Want to add an option where it ignores style issues in provided code.
* Need to update to check javadoc style headers: @params and @returns.
* Perhaps convert to java/python? Bash is a bit strange at times.
* Declaring multiple variables on the same line makes it difficult to check the first one. Ex. "int x, y;", x would be ignored.
* If the student doesn't use gg=G and brings a function to the next line, it may be falsely flagged.

It's not 100% perfect, so if there are any issues aside from the ones listed above, please message me (Anish Kannan) on facebook so I can fix it. 

