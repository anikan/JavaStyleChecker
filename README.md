# JavaStyleChecker
Made by Anish Kannan with help from Nick Crow and Purag Moumdjian for CSE8B Spring 2015. Still being updated for CSE11 Fall 2015 :>

Checks style for Ord's CSE 8B and CSE 11 Java assignments

I recommend using it to double check grading as opposed to relying on it.

## What it does:
* For every passed in file: 
* It first checks how much of the file is comments.
* Then checks for missing method, class, and file headers. (Currently not checking javadoc style).
* Then one letter (i,j,k) and one letter and multiple number (i1,j2234,k3) variable names when assigned or declared (Thanks to Purag Moumdjian). Also temp, variable, var, and thing. Just to making sure they're reading the writeup.
* Then lines over 80 characters.
* Then magic numbers. Makes sure that it isn't just assigning an instance variable and ignore magic nums in comments.
* Then checks indentation.
* Finally it sums up all issues from all passed in files and displays results and optionally copy pastable comments.

## Options: 
* -v: Verbose- display lines and line numbers that have issues. Results of grep and diff are distinguished using "!" and the type of error.
* -s: Show Steps- shows all of the steps, even ones that pass. 
* -c: Comments- gives copy pastable comments for the issues that you can just put into the spreadsheet.

## How to use:
1. First clone the repo to your account. Then either move "stylechecker.sh" to the students directory or know the path to the students files.
2. In shell, type "./styleChecker (options) (file1) (file2) (file3) ..."
	
I use "./styleChecker -vc *.java".

## Known issues: 
* grep doesn't like it when there aren't space characters at the front. Shouldn't be an issue unless their style is really bad.
* Want to add an option where it ignores style issues in provided code.
* Need to update to check javadoc style headers: @params and @returns.
* Perhaps convert to java/python? Bash is a bit strange at times.
* Declaring multiple variables on the same line makes it difficult to check the first one. Ex. "int x, y;", x would be ignored.
* If the student doesn't use gg=G and brings a function to the next line, it may be falsely flagged.

It's not 100% perfect, so if there are any issues aside from the ones listed above, please message me (Anish Kannan) on facebook so I can fix it. 
