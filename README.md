# JavaStyleChecker
Made by Anish Kannan with help from Nick Crow and Purag Moumdjian for CSE8B Spring 2015. 

Checks style for Ord's Java assignments
It's not 100% perfect, so if there are any issues please comment so I can fix it. I recommend using it to double check grading.
You can pass in multiple files at once, and it will check them individually and then sum all of the results. Use the -v option
to see what lines issues are found.

What it does:
* It first checks how much of the file is comments.
* Then checks for missing method, class, and file headers.
* Then one letter (i,j,k) and one letter and multiple number (i1,j2234,k3) variable names (Thanks to Purag Moumdjian). Also temp.
* Then lines over 80 characters.
* Then magic numbers. Makes sure that it isn't just assigning an instance variable and ignore magic nums in comments.
* Then checks indentation.

Known issues: 
* grep doesn't like it when there aren't space characters at the front. Shouldn't be an issue unless their style is really bad.

Options: 
* -v: Verbose- display lines and line numbers that have issues (results of grep and diff.).
* -s: Show Step- shows all of the steps, even ones that pass. 
* -c: Comments- (Planned) gives copy pastable comments for the issues that you can just put into the spreadsheet.
