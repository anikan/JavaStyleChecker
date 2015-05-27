#!/bin/bash
#styleChecker: A tool to help check style in programs, according to Ord's specs
#TODO Check mix of tabs and spaces.

OPTIND=1         # Reset in case getopts has been used previously in the shell.

totalLinesOver80=0
totalMagicNums=0
totalBadVarNames=0
verbose=0
totalNumLines=0
totalNumComments=0
totalMissingFileHeaders=0
totalMissingMethodHeaders=0
totalMissingClassHeaders=0

show_help()
{
    echo "Usage: [-v] FILE..."
    echo "Checks style for FILE(s). Ord-style"
    echo "-v, --verbose     print the results of each grep to find which lines have issues."
}

while getopts "h?v" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    v)  verbose=1
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
    echo "Checking $fileName"
 
    #####################COMMENT PROPORTIONS###############
    echo "Checking for comment proportions."
    #Handle // comments
    localNumLines=$(wc -l < $fileName)
    localNumComments=$(grep -E -c "\/\/" $fileName)
    
    #For later to keep track of which lines are comments
    doubleSlashCommentLines=$(grep -n "\/\/" $fileName | cut -f1 -d ":")
    read -a doubleSlashCommentArray <<< $doubleSlashCommentLines

    #Looping through line nums to put into the array.
    DSArraySize=$((${#doubleSlashCommentArray[@]} - 1)) 
    for index in `seq 0 $DSArraySize`
    do
        #To check whether a line is a comment, just check the value at line number.
        commentArray[$commentArrayIndex]=1
    done


    #Handle /* */ comments
    startCommentLines=$(grep -n "\/\*" $fileName | cut -f1 -d ":")
    endCommentLines=$(grep -n "\*\/" $fileName | cut -f1 -d ":")

    #Putting these in an array.
    read -a startCommentArray <<< $startCommentLines
    read -a endCommentArray <<< $endCommentLines

    arraySize=$((${#startCommentArray[@]} - 1)) 
   
    #Actually checking the lengths of multiline comments.
    index=0
    for index in `seq 0 $arraySize`
    do
        localNumComments=$((${endCommentArray[$index]} - ${startCommentArray[$index]} + $localNumComments))
    
        #For later, to keep track of which lines are comments.
        for commentArrayIndex in `seq ${startCommentArray[$index]} ${endCommentArray[$index]}`
        do
            commentArray[$commentArrayIndex]=1
        done
    done
        
    proportion=$(bc <<< "scale=2; $localNumComments / $localNumLines * 100")
    
    echo "** $proportion% of $fileName is comments. 25%-50% is usually good."
    echo
    totalNumLines=$(($localNumLines + $totalNumLines))
    totalNumComments=$(($localNumComments + $totalNumComments))
      
    ##########################LONG LINES###################
    echo "Checking for lines over 80 chars..."
    if (($verbose == 1)); then
        grep -E -nH '.\{81\}' $fileName
    fi

    localLinesOver80=$(grep -E -c '.\{81\}' "$fileName")
    totalLinesOver80=$(($localLinesOver80 + $totalLinesOver80))
    if (($localLinesOver80 != 0)); then
        echo
        echo "**$localLinesOver80 lines over 80 chars in $fileName"
        echo
    fi
    #######################BAD VARIABLE NAMES##############
    #Catches when the variable is assigned. 
    #Catches single letter vars with numbers, ex. i1
    echo "Checking for 1 letter variable names."

    if (($verbose == 1)); then
        grep -E -nH "[;\s]?([a-zA-Z])[\s\d]?=" $fileName 
    fi
    localBadVarNames=$(grep -E -c "[;\s]?([a-zA-Z])[\s\d]?=" $fileName)
    totalBadVarNames=$(($localBadVarNames + $totalBadVarNames))
    if (($localBadVarNames != 0)); then
        echo "** $localBadVarNames single-letter names in $fileName"
        echo
    fi

    ############FILE HEADERS################
    #Unintelligent, looking for the word "login" lines after "/*"
    #Case-insensitive.
    #Thank you stack overflow
    echo "Checking for missing file headers..."
    localMissingFileHeaders=$(grep -Pzic "(?s)(\/\*|\/\/).*\n.*login" $fileName)
    if (($localMissingFileHeaders == 0)); then
        echo "** Missing File Header in $fileName"
        echo
        totalMissingFileHeaders=$((1+$totalMissingFileHeaders))
    fi

    ############METHOD/CLASS HEADERS################
    #First looks for access modifiers then checks for names of classes.
    #Case-insensitive.
    
    #First get the lines with an access modifier: These are classes,
    #instance variables, and methods.
    linesWithAccessModifier=$(grep -Eon "public|private" $fileName | cut -f1 -d ":")
    read -a accessModifierLinesArray <<< $linesWithAccessModifier

    lastLineIndexToCheck=$((${#accessModifierLinesArray[@]} - 1))

    methodIndex=0
    classIndex=0
    instanceVarIndex=0
    #Get all the names we will search for. Looking for open parens
    for lineNumIndex in `seq 0 $lastLineIndexToCheck`
    do
        result=$(sed "${accessModifierLinesArray[$lineNumIndex]}!d" $fileName | grep -Po "\S+(?=\()")

        #If the word is a valid method then put it in methodNames
        if [[ ! -z "$result" ]]; then
            methodNames[$methodIndex]=$result
            methodIndex=$(($methodIndex + 1))

        #If the word is not a method then check if it is a class
        else
            result=$(sed "${accessModifierLinesArray[$lineNumIndex]}!d" $fileName | grep -Eo "class\s+\S+" | cut -f2 -d " ")

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
    done
    
    echo "Checking for missing method headers..."
    lastMethodIndexToCheck=$((${#methodNames[@]} - 1))
    
    #Grep the names of methods to see if there is an appropriate comment.
    for methodName in `seq 0 $lastMethodIndexToCheck`
    do
        result=$(grep -Eic "Name:\s*${methodNames[$methodName]}" $fileName)

        if ((result == 0)); then
            echo "**Missing method header for ${methodNames[$methodName]} in $fileName"
            totalMissingMethodHeaders=$((1+$totalMissingMethodHeaders))
        fi
    done
    echo
    
    lastClassIndexToCheck=$((${#classNames[@]} - 1))
    
    echo "Checking for missing class headers..."
    #Grep the names of classes to see if there is an appropriate comment.
    for className in `seq 0 $lastClassIndexToCheck`
    do
        result=$(grep -Eic "Name:\s*${classNames[$className]}" $fileName)

        if ((result == 0)); then
            echo "**Missing class Header for ${classNames[$className]} in $fileName"
            totalMissingClassHeaders=$((1+$totalMissingClassHeaders))
        fi
    done
    echo
    #################MAGIC NUMBERS#########################
    echo "Checking for magic numbers..."
    
    magicNumLines=$(grep -Pon '[\s,\+\-\/\*]([2-9]\d*)|(1\d+)' $fileName | cut -f1 -d ":")
    read -a magicNumsArray <<< $magicNumLines

    lastNumIndexToCheck=$((${#magicNumsArray[@]} - 1))
    lastInstanceVarIndex=$((${#instanceVarLines[@]} - 1))

    #From these magic numbers, remove those that are actually instance variables.
    for numLine in `seq 0 $lastNumIndexToCheck`
    do
        #Inefficient, but checking if one of the magic numbers is an instance variable.
        #If so then it isn't a magic number. Note: ignoring static and final.
        #public instance variables are also ok.
        isBad=1
        for numInstanceVar in `seq 0 $lastInstanceVarIndex`
        do
            if [[ ${commentArray[${magicNumsArray[$numLine]}]} -eq 1 ]]; then
                isBad=0 
                
            else
                if [[ ${magicNumsArray[$numLine]} -eq ${instanceVarLines[$numInstanceVar]} ]]; then
                    isBad=0
                fi
            fi
        done
        
        if (($isBad == 1)); then
            localMagicNums=$(($localMagicNums + 1))

            if (($verbose == 1)); then
                echo -n "Line ${magicNumsArray[$numLine]}:"
                sed "${magicNumsArray[$numLine]}!d" $fileName
            fi
        fi
    done
    
    totalMagicNums=$(($localMagicNums + $totalMagicNums))
    
    if [[ !$localMagicNums -eq 0 ]]; then
        echo "**$localMagicNums magic nums in $fileName"
        echo
    fi
done

proportion=$(bc <<< "scale=2; $totalNumComments / $totalNumLines * 100")

echo "-----RESULTS-----"
echo "$proportion% of files are comments. 25%-50% is usually good."
echo "$totalMissingMethodHeaders missing method headers."
echo "$totalMissingClassHeaders missing class headers."
echo "$totalMissingFileHeaders missing file headers."
echo "$totalBadVarNames bad variable names."
echo "$totalLinesOver80 lines over 80."
echo "$totalMagicNums magic numbers."

