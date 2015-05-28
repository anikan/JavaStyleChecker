# JavaStyleChecker
Checks style for Ord's Java assignments
It's not 100% perfect, so if there are any issues please comment so I can fix it. I recommend using it to double check grading.
You can pass in multiple files at once, and it will check them individually and then sum all of the results.

What it does:
* It first checks how much of the file is comments.
* Then checks for missing method, class, and file headers.
* Then one letter (i,j,k) and one letter and number (i1,j2,k3) variable names.
* Then lines over 80 characters.
* Then magic numbers.

Known issues: 
* If there is a comment on the same line as an error, I do not count it as an error.
* Variables with one letter and multiple numbers will not be caught (i123).
* Currently not checking indentation levels.
* grep doesn't like it when there aren't space characters at the front. Shouldn't be an issue unless their style is really bad.

Options: 
-v: Verbose- display lines and line numbers that have issues (results of grep).
-s: Suggestions- (Planned) gives copy pastable suggestions for the issues that you can just put into the spreadsheet.
-f: False Positive- (Might do) causes magic numbers that exist on the same line as comments
