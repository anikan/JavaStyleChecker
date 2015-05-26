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
    echo "Checks style for FILE(s). Ord-style\n"
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
    echo "Checking $fileName\n"
 
    #####################COMMENT PROPORTIONS###############
    echo "Checking for comment proportions."
    #Handle // comments
    localNumLines=$(wc -l < $fileName)
    localNumComments=$(grep -E -c "\/\/" $fileName)

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
    done
        
    proportion=$(bc <<< "scale=2; $localNumComments / $localNumLines * 100")
    
    echo "$proportion% of $fileName is comments. 25%-50% is usually good."

    totalNumLines=$(($localNumLines + $totalNumLines))
    totalNumComments=$(($localNumComments + $totalNumComments))
      
    ##########################LONG LINES###################
    echo "Checking for lines over 80 chars..."
    if (($verbose == 1)); then
        grep -E -nH '.\{81\}' $fileName
    fi

    localLinesOver80=$(grep -E -c '.\{81\}' "$fileName")
    totalLinesOver80=$(($localLinesOver80 + $totalLinesOver80))
    echo "$localLinesOver80 lines over 80 chars in $fileName\n"

    #################MAGIC NUMBERS#########################
    echo "Checking for magic numbers...\n"
    if (($verbose == 1)); then
        grep -E -nH '([\s,+-]([2-9]\d{0,})|(1\d{1,}))(?<!(public|private))' $fileName
    fi
    
    localMagicNums=$(grep -E -c '[2-9]\d{0,}' $fileName )
    totalMagicNums=$(($localMagicNums + $totalMagicNums))
    echo "$localMagicNums magic nums in $fileName\n"

    #######################BAD VARIABLE NAMES##############
    #Catches when the variable is assigned. 
    #Catches single letter vars with numbers, ex. i1
    echo "Checking for 1 letter variable names."

    if (($verbose == 1)); then
        grep -E -nH "[;\s]?([a-zA-Z])[\s\d]?=" $fileName 
    fi
    localBadVarNames=$(grep -E -c "[;\s]?([a-zA-Z])[\s\d]?=" $fileName)
    totalBadVarNames=$(($localBadVarNames + $totalBadVarNames))
    echo "$localBadVarNames single-letter names in $fileName\n"

    ############FILE HEADERS################
    #Unintelligent, looking for the word "login" lines after "/*"
    #Case-insensitive.
    #Thank you stack overflow
    localMissingFileHeaders=$(grep -Pzic "(?s)(\/\*|\/\/).*\n.*login" $fileName)
    if (($localMissingFileHeaders == 0)); then
        echo "Missing File Header in $fileName"
        totalMissingFileHeaders=$((1+$totalMissingFileHeaders))
    fi

    ############METHOD HEADERS################
    #Unintelligent, looking for the word "filename" lines after "/*"
    #Case-insensitive.
    #Thank you stack overflow
    #localMissingFileHeaders=$(grep -Pzic "(?s)(\/\*|\/\/).*\n.*Filename" $fileName)
    #echo $localMissingFileHeaders
    #if (($localMissingFileHeaders == 0)); then
    #    echo "Missing File Header in $fileName"
    #    totalMissingFileHeaders=$((1+$totalMissingFileHeaders))
    #fi
    
    ############CLASS HEADERS################
    #First looks for access modifiers then checks for names of classes.
    #Case-insensitive.

    #First get the lines with an access modifier: These are classes and instance variables.
    linesWithAccessModifier=$(grep -Eon "public|private" $fileName | cut -f1 -d ":")
    read -a accessModifierLinesArray <<< $linesWithAccessModifier

    echo "length: ${#accessModifierLinesArray[@]}"

    wordIndex=0
    #Get all the names we will search for.
    for lineNumIndex in `seq 0 ${#accessModifierLinesArray[@]}`
    do
        result=$(sed "${accessModifierLinesArray[$lineNumIndex]}!d" $fileName | grep -Eo "class\s+\S+" | cut -f2 -d " ")
        echo "Result: $result"

        #If the word is a valid class then put it in classNames
        if [[ -z "$result"]]; then
            classNames[$wordIndex]=result
            wordIndex=$(($wordIndex + 1))
        fi
    done

    echo "First: ${classNames[0]}"


    #Grep these names to see if there is an appropriate comment.
    for name in `seq 0 ${#classNames[@]}`
    do
        result=$(grep -Eic "Name:\s*${classNames[$name]}" $fileName)

        if ((result == 0)); then
            echo "Missing class Header for ${classNames[$name]} in $fileName"
            totalMissingClassHeaders=$((1+$totalMissingClassHeaders))
        fi
    done
done

proportion=$(bc <<< "scale=2; $totalNumComments / $totalNumLines * 100")

echo "-----RESULTS-----"
echo "$totalLinesOver80 lines over 80."
echo "$totalMagicNums magic numbers."
echo "$totalBadVarNames bad variable names."
echo "$proportion% of files are comments. 25%-50% is usually good."
echo "$totalMissingFileHeaders missing file headers."
echo "$totalMissingMethodHeaders missing method headers."
echo "$totalMissingClassHeaders missing class headers."

