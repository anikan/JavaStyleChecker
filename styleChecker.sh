#!/bin/bash
#styleChecker: A tool to help check style in programs, according to Ord's specs
#Made by Anish Kannan
#Thanks to Nick Crow (Nack) for regex help
#Thanks to Purag Moumdjian for help testing and with a solution for bad variable names.
#TODO Handle @param 

OPTIND=1         # Reset in case getopts has been used previously in the shell.

totalLinesOver80=0
totalMagicNums=0
totalBadVarNames=0
totalNumLines=0
totalNumComments=0
totalMissingFileHeaders=0
totalMissingMethodHeaders=0
totalMissingClassHeaders=0
totalBadIndentedLines=0

verbose=0
showSteps=0
showComments=0
comments=""

show_help()
{
    echo "Usage: [OPTION] FILE..."
    echo "Checks style for FILE(s). Ord-style"
    echo "-v, --verbose     print the results of each grep to find which lines have issues."
    echo "-c, --comments    Prints copy-pastable comments about the errors."
    echo "-s, --show        show all of the steps along the way. (Deprecated)"
}

while getopts "h?vcs" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    v)  verbose=1
        ;;
    c)  showComments=1
        ;;
    s)  showSteps=1
        ;;
    esac
done

shift $((OPTIND-1))

if (($# < 1)); then
    show_help
    exit 0
fi

#Loop through files.
for fileName in "$@"
do
    localLinesOver80=0
    localMagicNums=0
    localBadVarNames=0
    localNumLines=0
    localNumComments=0
    localMissingFileHeaders=0
    localMissingMethodHeaders=0
    localMissingClassHeaders=0
    localBadIndentedLines=0

    echo "Checking $fileName"
 
    #####################COMMENT PROPORTIONS###############
    if (($showSteps == 1)); then
        echo "Checking for comment proportions."
    fi

    #Handle // comments
    localNumLines=$(wc -l < $fileName)
    localNumComments=$(grep -E -c "\/\/" $fileName)
    
    #For later to keep track of which lines are comments
    doubleSlashCommentLines=$(grep -n "\/\/" $fileName | cut -f1 -d ":")
    
    #Initializing it for each file.
    unset commentArray
    unset doubleSlashCommentArray
    read -a doubleSlashCommentArray <<< $doubleSlashCommentLines

    #Looping through line nums to put into the array.
    DSArraySize=$((${#doubleSlashCommentArray[@]} - 1)) 
    for commentArrayIndex in `seq 0 $DSArraySize`
    do
        #To check whether a line is a comment, just check the value at line number.
        #A double slash comment is 1
        commentArray[${doubleSlashCommentArray[$commentArrayIndex]}]=1
    done


    #Handle /* */ comments
    startCommentLines=$(grep -n "\/\*" $fileName | cut -f1 -d ":")
    endCommentLines=$(grep -n "\*\/" $fileName | cut -f1 -d ":")

    #Initializing for each file.
    unset startCommentArray
    unset endCommentArray

    #Putting these in an array.
    read -a startCommentArray <<< $startCommentLines
    read -a endCommentArray <<< $endCommentLines

    arraySize=$((${#startCommentArray[@]} - 1)) 
   
    #Actually checking the lengths of multiline comments.
    index=0
    for index in `seq 0 $arraySize`
    do
        localNumComments=$((${endCommentArray[$index]} - ${startCommentArray[$index]} + $localNumComments))
    
        #For later, to keep track of which lines are comments. A "/* */" comment
        #is 2.
        for commentArrayIndex in `seq ${startCommentArray[$index]} ${endCommentArray[$index]}`
        do
            commentArray[$commentArrayIndex]=2
        done
    done
        
    proportion=$(bc <<< "scale=2; $localNumComments / $localNumLines * 100")
    
    echo "** $proportion% of $fileName is comments. 25%-50% is usually good."
    echo
    totalNumLines=$(($localNumLines + $totalNumLines))
    totalNumComments=$(($localNumComments + $totalNumComments))
   
    ##########################LONG LINES###################
    if (($showSteps == 1)); then
        echo "Checking for lines over 80 chars..."
    fi

    if (($verbose == 1)); then
        grep -EnH '.{81}' $fileName | perl -ne 'print "!Over 80 Chars: $_"' 
    fi

    localLinesOver80=$(grep -Ec '.{81}' "$fileName")
    totalLinesOver80=$(($localLinesOver80 + $totalLinesOver80))
    if (($localLinesOver80 != 0)); then
        echo "** $localLinesOver80 lines over 80 chars in $fileName"
        echo

    fi
    #######################BAD VARIABLE NAMES##############
    #Catches when the variable is assigned. 
    #Catches single letter vars with numbers, ex. i1
    #Updated: 5/28/15 21:11 (Purag Moumdjian)
    if (($showSteps == 1)); then
        echo "Checking for bad variable names."
    fi

    if (($verbose == 1)); then
        grep -PinH "[\s,;(]([a-z][0-9]*)\s*[;=]" $fileName | perl -ne 'print "!Bad Var Name: $_"' 
    fi
    #Looking for single letter names with numbers after.
    localBadVarNames=$(grep -Pci "[\s,;(]([a-z][0-9]*)\s*[;=]" $fileName)
    totalBadVarNames=$(($localBadVarNames + $totalBadVarNames))
    
    if (($localBadVarNames != 0)); then
        echo "** $localBadVarNames bad variable names in $fileName"
        echo
    fi

    ############FILE HEADERS################
    #Unintelligent, looking for the word "login" lines after "/*"
    #Case-insensitive.
    #Thank you stack overflow
    if (($showSteps == 1)); then
        echo "Checking for missing file headers..."
    fi

    localMissingFileHeaders=$(grep -Pzic "login" $fileName)
    if (($localMissingFileHeaders == 0)); then
        echo "** Missing File Header in $fileName"
        echo
        totalMissingFileHeaders=$((1+$totalMissingFileHeaders))
        
        if [[ $showComments == 1 ]]; then
            comments="${comments}* You seem to be missing a file header for $fileName\n"
        fi
    fi

    ############METHOD/CLASS HEADERS################
    #First looks for access modifiers then checks for names of classes.
    #Case-insensitive.
    
    #First get the lines with an access modifier: These are classes,
    #instance variables, and methods.
    linesWithAccessModifier=$(grep -Eon "public|private" $fileName | cut -f1 -d ":")

    #Initializing for each file.
    unset accessModifierLinesArray
    read -a accessModifierLinesArray <<< $linesWithAccessModifier

    lastLineIndexToCheck=$((${#accessModifierLinesArray[@]} - 1))

    #Initializing for each file
    methodIndex=0
    classIndex=0
    instanceVarIndex=0
    #Arrays to be used. Unset for each file.

    #Stores names of methods.
    unset methodNames

    #Stores return types of methods
    unset methodReturnTypes

    #Stores variables for methods.
    unset methodVariables

    # Stores names of classes.
    unset classNames

    #Stores lines of instance variables.
    unset instanceVarLines

    #Get all the names we will search for. Could be class name, instance variable, or method.
    for lineNumIndex in `seq 0 $lastLineIndexToCheck`
    do
        #First removing instance var objects with same line declaration and initialization.
        instanceVarCheck=$(sed "${accessModifierLinesArray[$lineNumIndex]}!d" $fileName | grep -Eo "=")
        #If there is an "=", this must be an instance variable.
        if [[ ! -z "$instanceVarCheck" ]]; then
            instanceVarLines[$instanceVarIndex]=${accessModifierLinesArray[$lineNumIndex]}
            instanceVarIndex=$(($instanceVarIndex + 1))

        else
           
            #Check for method names
            result=$(sed "${accessModifierLinesArray[$lineNumIndex]}!d" $fileName | grep -Po "\S+\s*(?=\()")

            #If the word is a valid method then put it in methodNames. Then get params and return type.
            if [[ ! -z "$result" ]]; then
                methodNames[$methodIndex]=$result
		
                #Get return type.
         #       returnResult=$(sed "${accessModifierLinesArray[$lineNumIndex]}!d" $fileName | grep -Po "\w+(?=\s+\w*\s*\()")

		#methodReturnTypes[$methodIndex]=$returnResult

		#Get parameters as a single string and remove the open parens. Will be split later.                
		
         #       returnVars=$(sed "${accessModifierLinesArray[$lineNumIndex]}!d" $fileName | grep -Po "\(.*(?=\))" | cut -f2 -d "("))
		#methodVars[$methodIndex]=$returnVars

		methodIndex=$(($methodIndex + 1))

            #If the word is not a method then check if it is a class
            else
                result=$(sed "${accessModifierLinesArray[$lineNumIndex]}!d" $fileName | grep -Po "class\s+[^{\s]+" | cut -f2 -d " ")

                #If the word is a valid class then put it in classNames
                if [[ ! -z "$result" ]]; then
                    classNames[$classIndex]=$result
                    classIndex=$(($classIndex + 1))

                #Must be an instance variable. Store the line number to check for magic vars.
                else
                    instanceVarLines[$instanceVarIndex]=${accessModifierLinesArray[$lineNumIndex]}
                    instanceVarIndex=$(($instanceVarIndex + 1))

                fi
            fi
        fi
    done
    
    if (($showSteps == 1)); then
        echo "Checking for missing method headers..."
    fi
    lastMethodIndexToCheck=$((${#methodNames[@]} - 1))
    
    #Try to find matching comment for a method by finding the first "/**" before it.
    for methodNameIndex in `seq 0 $lastMethodIndexToCheck`
    do
	    #Basically, this regex finds the javadoc comment that is not before another class.
        result=$(grep -Pizo "\/\*\*[^\/]*\/[^\/\(]*${methodNames[$methodNameIndex]}" $fileName)

        #If a comment wasn't found then handle missing header.
        if [[ -z $result ]]; then
            echo "** Missing method header for ${methodNames[$methodNameIndex]} in $fileName"
            totalMissingMethodHeaders=$((1+$totalMissingMethodHeaders))
        
            if [[ $showComments == 1 ]]; then
                comments="${comments}* You seem to be missing a method header for ${methodNames[$methodNameIndex]} in $fileName\n"
            fi

        #Else check it's params and returns.
        #else
	    #First process parameters into an array.
	    #unset paramsArray
    	#    read -a accessModifierLinesArray <<< $linesWithAccessModifier


	    #Check return.
	    


        fi
    done
 
    lastClassIndexToCheck=$((${#classNames[@]} - 1))
    
    if (($showSteps == 1)); then
        echo "Checking for missing class headers..."
    fi

    #Grep the names of classes to see if there is an appropriate comment.
    for className in `seq 0 $lastClassIndexToCheck`
    do
        result=$(grep -Pizo "\/\*\*[^\/]*\/[^\/\(]*${classNames[$className]}" $fileName)

        if [[ -z $result ]]; then
            echo "** Missing class Header for ${classNames[$className]} in $fileName"
            totalMissingClassHeaders=$((1+$totalMissingClassHeaders))
        
            if [[ $showComments == 1 ]]; then
                comments="${comments}* You seem to be missing a class header for ${classNames[$className]} in $fileName\n"
            fi
        fi
    done

    #################MAGIC NUMBERS#########################
    if (($showSteps == 1)); then
        echo "Checking for magic numbers..."
    fi
    
    #initializing it for each file.
    unset magicNumsArray

    magicNumLines=$(grep -Pon '[\s,\+\-\/\*=\%\(\[<>](([2-9]\d*)|(1\d+))' $fileName | cut -f1 -d ":")
   
    read -a magicNumsArray <<< $magicNumLines

    lastNumIndexToCheck=$((${#magicNumsArray[@]} - 1))
    lastInstanceVarIndex=$((${#instanceVarLines[@]} - 1))

    #From these magic numbers, remove those that are actually instance variables or in comments.
    numLine=0
    while [ $numLine -le $lastNumIndexToCheck ]
    do

        #First check if the magic number appeared in a "//" comment. If the type is 1.
        isBad=1
        if [[ ${commentArray[${magicNumsArray[$numLine]}]} -eq 1 ]]; then
            #We know there is a comment on the line, want to check if it starts before the number.
            #Eg: "int potato = 0 //64 is my favorite number" should be ok.
            checkCommentInLine=$(sed "${magicNumsArray[$numLine]}!d" $fileName | awk -F "//" '{print $1}')

            #Need to remove extraneous matches that are due to commented out portions.
            numsToBeIgnored=$(sed "${magicNumsArray[$numLine]}!d" $fileName | awk -F "//" '{print $2}')
            
            #Note there is a space here before numsToBeIgnored in case the magic num is right after the "//".
            commentIgnoreResult=$( echo " $numsToBeIgnored" | grep -Po '[\s,\+\-\/\*=\%\(\[<>](([2-9]\d*)|(1\d+))' | wc -l)

            #If there are commented magic numbers, then increment numLine to skip those.
            if [[ $commentIgnoreResult != 0 ]]; then
                numLine=$(($numLine+ $commentIgnoreResult))

                #We've already removed magic nums after the comment. Any other
                #matches are actual magic numbers. Setting type to already checked //.
                commentArray[${magicNumsArray[$numLine]}]=3
            fi

            #Still need to check if this number is magic.
            commentResult=$( echo " $checkCommentInLine" | grep -Pon '[\s,\+\-\/\*=\%\(\[<>](([2-9]\d*)|(1\d+))' | cut -f1 -d ":")

            #If the grep didn't find the number, then it was after the "//"
            if [[ -z $commentResult ]]; then
                isBad=0 
            fi

        #If the magic number appeared in a "/* */" comment.
        else
            if [[ ${commentArray[${magicNumsArray[$numLine]}]} -eq 2 ]]; then
                isBad=0
            fi
        fi
                
        #If it is still bad, then check it's an instance variable.
        #If so then it isn't a magic number. Note: ignoring static and final.
        #public instance variables are also ok.
        if [[ $isBad -eq 1 ]]; then
            for numInstanceVar in `seq 0 $lastInstanceVarIndex`
            do
                if [[ ${magicNumsArray[$numLine]} -eq ${instanceVarLines[$numInstanceVar]} ]]; then
                    isBad=0
                fi
            done
        fi
        
        if (($isBad == 1)); then
            localMagicNums=$(($localMagicNums + 1))

            if (($verbose == 1)); then
                echo -n "!Magic Num: $fileName:Line ${magicNumsArray[$numLine]}:"
                sed "${magicNumsArray[$numLine]}!d" $fileName
            fi
            
            if [[ $showComments == 1 ]]; then
                comments=("${comments}* You seem to be using a magic number on line ${magicNumsArray[$numLine]} in $fileName\n")
            fi
        fi

        #Increment for loop.
        numLine=$(($numLine + 1))
    done
    
    totalMagicNums=$(($localMagicNums + $totalMagicNums))
    
    if [[ !$localMagicNums -eq 0 ]]; then
        echo "** $localMagicNums magic nums in $fileName"
        echo
    fi
    
    ############INDENTATION################
    #Thanks to Nack for this method of implementation.
    #Essentially makes copies of the file, gg=G's them after setting 
    #indentation and finds the closest one to the input code.
    if (($showSteps == 1)); then
        echo "Checking for indentation..."
    fi
    
    #Copies of file.
    cp $fileName "TEMP_2SpaceCopy"
    cp $fileName "TEMP_3SpaceCopy"
    cp $fileName "TEMP_4SpaceCopy"
    
    #Autoindenting with different indentation levels.
    vim -es -c 'set expandtab|set softtabstop=2|set tabstop=2|set shiftwidth=2|retab|normal gg=G' -c 'wq' TEMP_2SpaceCopy
    vim -es -c 'set expandtab|set softtabstop=3|set tabstop=3|set shiftwidth=3|retab|normal gg=G' -c 'wq' TEMP_3SpaceCopy
    vim -es -c 'set expandtab|set softtabstop=4|set tabstop=4|set shiftwidth=4|retab|normal gg=G' -c 'wq' TEMP_4SpaceCopy

    #Trying to find which level matches input code closest. Grepping for '<' for number of different lines.
    #-I is ignore. '^\s*$' is a regex to ignore blank lines.
    diff2Space=$(diff -I '^\s*$' $fileName TEMP_2SpaceCopy | grep '<' | wc -l)
    diff3Space=$(diff -I '^\s*$' $fileName TEMP_3SpaceCopy | grep '<' | wc -l)
    diff4Space=$(diff -I '^\s*$' $fileName TEMP_4SpaceCopy | grep '<' | wc -l)

    #Two spaces.
    if (( $diff2Space < $diff3Space )) && (( $diff2Space < $diff4Space )) ; then
        echo "Detected 2 space indentation."
        if [[ $diff2Space != 0 ]]; then
            echo "$diff2Space lines seem to have poor indentation."
            totalBadIndentedLines=$(($totalBadIndentedLines + $diff2Space))
            
            if (($verbose == 1)); then
                diff -I '^\s*$' --unchanged-line-format="" --old-line-format="" --new-line-format="!Indentation: $fileName:Line %dn:%L" $fileName TEMP_2SpaceCopy
            fi
        else
            echo
        fi
    #Three spaces.
    else 
        if (( $diff3Space < $diff2Space )) && (( $diff3Space < $diff4Space )) ; then
            echo "Detected 3 space indentation."
            if [[ $diff3Space != 0 ]]; then
                echo "$diff3Space lines seem to have poor indentation."
                totalBadIndentedLines=$(($totalBadIndentedLines + $diff3Space))
            
                if (($verbose == 1)); then
                    diff -I '^\s*$' --unchanged-line-format="" --old-line-format="" --new-line-format="!Indentation: $fileName:Line %dn:%L" $fileName TEMP_3SpaceCopy
                fi
            else
                echo
            fi

        else
            #Four spaces.
            if (( $diff4Space < $diff2Space )) && (( $diff4Space < $diff3Space )) ; then
                echo "Detected 4 space indentation."
                if [[ $diff4Space != 0 ]]; then
                    echo "$diff4Space lines seem to have poor indentation."
                    totalBadIndentedLines=$(($totalBadIndentedLines + $diff4Space))
            
                    if (($verbose == 1)); then
                        diff -I '^\s*$' --unchanged-line-format="" --old-line-format="" --new-line-format="!Indentation: $fileName:Line %dn:%L" $fileName TEMP_4SpaceCopy
                    fi
                else
                    echo
                fi
            #Strange number of spaces.
            else
                echo "Detected other indentation. Please investigate."
                echo "$diff4Space lines seem to have poor indentation."
                totalBadIndentedLines=$(($totalBadIndentedLines + $diff4Space))
            fi
        fi
    fi 
       
    #Get rid of the copies.
    rm "TEMP_2SpaceCopy"
    rm "TEMP_3SpaceCopy"
    rm "TEMP_4SpaceCopy"

done

proportion=$(bc <<< "scale=2; $totalNumComments / $totalNumLines * 100")

echo "-----RESULTS-----"
echo "$proportion% of files are comments. 25%-50% is usually good."
echo "$totalMissingMethodHeaders missing method headers."
echo "$totalMissingClassHeaders missing class headers."
echo "$totalMissingFileHeaders missing file headers."
echo "$totalBadVarNames bad variable names."
echo "$totalLinesOver80 lines over 80."
echo "$totalBadIndentedLines lines incorrectly indented."
echo "$totalMagicNums magic numbers."

if [[ $showComments == 1 ]]; then
    echo "-----COMMENTS-----" 
    echo -ne "$comments"
                    
    if [[ $BadVarNames != 0 ]]; then
      echo "* You seem to have variables with bad names. Try to make sure that they are descriptive of their purpose. Even loop iterator names should be descriptive. For example: \"for (int i =0...)\" would be bad."
    fi

    if [[ $totalLinesOver80 != 0 ]]; then
      echo "* You seem to have lines going over 80 characters. I recommend using \"grep .{,80} <fileName>\" to check if there are bad lines."
    fi

    if [[ $totalBadIndentedLines != 0 ]]; then
        echo "* You seem to have lines that are improperly indented. Try using the \"gg=G\" command, it indents everything for you."
    fi

    if [[ $totalMagicNums != 0 ]]; then
        echo "* Magic Numbers make modifying them later difficult. I recommend making a private static final variable to store this value instead."
    fi
fi
