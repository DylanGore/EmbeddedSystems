#!/bin/bash
# Times tables assignment (Dylan Gore - 20081224)

# Color & Formatting
COL_RST="\\e[0m"
COL_GREEN="\\e[32m"
COL_RED="\\e[31m"
SYM_CHECK="✓"
SYM_UP="↑"
SYM_DOWN="↓"

# Global variables
NUMBER=0
MODE=0
MODE_OP=none
TABLE_MODE=0
LIVES=3 # 3 Lives
USER_MODE=1
USER_PASS="invalid"
USER_NAME="invalid"
TEACHER_PASS="Password1"

# Array
declare -A QARRAY
QUIZ_QUSTION_COUNT=20

function loginMenu(){
    # Check if dialog is installed
    if [ -x "$(command -v dialog)" ]; then
        # Get user mode - i.e student/teacher
        USER_MODE=$(dialog --backtitle "Times Tables" \
            --title "User Login" \
            --menu "$(echo 'Select option')" 16 40 4 1 "Student" 2 "Teacher" \
        3>&1 1>&2 2>&3 3>&-)
        # Get name
        clear
        
        if [[ $USER_MODE == 1 ]]; then
            USER_NAME=$(dialog --backtitle "Times Tables" \
                --title "Student Login" \
                --inputbox "Username:" 8 40 \
            3>&1 1>&2 2>&3 3>&-)
            
            # Get response code
            response=$?
            if [[ $response == 1 ]]; then
                clear
                echo "You must enter you name to continue, the program will now exit."
                exitProgram
            fi
        else
            while [ $USER_PASS != $TEACHER_PASS ]; do
                USER_NAME="Teacher"
                echo "no pass"
                USER_PASS=$(dialog --backtitle "Times Tables" \
                    --title "Enter Teacher Password" \
                    --passwordbox "Password: " 8 40 \
                3>&1 1>&2 2>&3 3>&-)
                
                # Get response code
                response=$?
                # if user selects cancel
                if [[ $response == 1 ]]; then
                    loginMenu
                else
                    if [[ "$USER_PASS" != "$TEACHER_PASS" ]]; then
                        dialog --backtitle "Times Tables" --msgbox "Wrong password, try again!" 8 40
                    fi
                fi
                
                
            done
        fi
    else
        echo "You should install dialog to use this program"
        echo -e "sudo apt install dialog\\n"
        waitReset
        echo "Fallback to standard user input"
        read -rp "Enter you name: " $USER_NAME
    fi
}

# Display menu
function mainMenu(){
    clear
    if [[ $USER_MODE == 1 ]]; then
        echo -e "MODE: Student \\n"
        echo "1. Learn Tables"
        echo "2. Tables Quiz"
        echo -e "3. Quit \\n"
        read -rp "Option (1-3) ► " MODE
        
        case $MODE in
            1) operatorSelectMenu "$MODE" ;;
            2) tableQuiz ;;
            3) exitProgram ;;
            *) echo "Invalid Option"; sleep 1; mainMenu ;;
        esac
    else
        echo -e "MODE: Teacher \\n"
        echo "1. Learn Tables"
        echo "2. Tables Quiz"
        echo "3. Display Attempts"
        echo "4. Clear Attempts"
        echo -e "5. Quit \\n"
        read -rp "Option (1-5) ► " MODE
        
        case $MODE in
            1) operatorSelectMenu "$MODE" ;;
            2) tableQuiz ;;
            3) listResults ;;
            4) clearResults ;;
            5) exitProgram ;;
            *) echo "Invalid Option"; sleep 1; mainMenu ;;
        esac
    fi
    
}

# List results text files
function listResults(){
    ls -t --color *.txt
    waitReset
}

# Clear results files
function clearResults(){
    rm *.txt
    waitReset
}

# Ask the user to choose an operator
function operatorSelectMenu(){
    case $1 in
        1) echo -e "\\nTable Mode: Learn Tables\\n";;
        2) echo -e "\\nTable Mode: Tables Quiz\\n";;
    esac
    echo "Select Arithmetic Mode:"
    echo "1. Addition +"
    echo "2. Subtraction -"
    echo "3. Multiplication ×"
    echo "4. Division ÷ "
    echo -e "5. Back \\n"
    read -rp "Option (1-5) ► " TABLE_MODE
    
    case $TABLE_MODE in
        1) MODE_OP="+" ;;
        2) MODE_OP="-" ;;
        3) MODE_OP="*" ;;
        4) MODE_OP="/" ;;
    esac
    
    case $TABLE_MODE in
        [1-4])
            if [ "$MODE" == 1 ]; then
                learnTables
            else
                tableQuiz
            fi
        ;;
        5) mainMenu ;;
        *) echo "Invalid option"; sleep 1; operatorSelectMenu ;;
    esac
}

# Get number from user
function inputNumber(){
    NUMBER=0
    until [[ $NUMBER -gt 0 && $NUMBER -le 20 ]] ; do
        # echo "Invalid option - $NUMBER is not between 0 and 20!"
        read -rp "Enter a number (1-20) ► " NUMBER
    done
}

# Check if the user has already chosen a number for a previous attempt
function checkExistingNumber(){
    # If number has not been chosen by the user (i.e. NUM == 0)
    if [ "$NUMBER" == 0 ]; then
        inputNumber
    else
        # Check number choice
        read -rp "Would you like to use $NUMBER? (y/N)? :" USR_YN
        echo "'$USR_YN'"
        case $USR_YN in
            "y"|"yes"|"Y"|"Yes"|"ye"|"Ye") clear;;
            *) inputNumber;;
        esac
    fi
}

# End the program
function exitProgram(){
    echo "Thank you, goodbye!"
    sleep 3
    exit 0
}

# Learn tables
function learnTables(){
    checkExistingNumber
    
    # Display "normal" aritmatic symbols
    if [[ $MODE_OP == "/" ]]; then
        MODE_SYMBOL="÷"
        elif [[ $MODE_OP == "*" ]]; then
        MODE_SYMBOL="×"
    else
        MODE_SYMBOL=$MODE_OP
    fi
    
    echo "Learn tables - $MODE_SYMBOL$NUMBER"
    
    LOOP_MAX=13
    # Addition, Subtraction and Multiplication
    for ((i=0; i < LOOP_MAX; i++ )){
        # Ensure only 13 questions are asked when doing addition
        if [[ $i == 0 && $TABLE_MODE == 1 ]]; then
            LOOP_MAX=$((LOOP_MAX-1))
        fi
        
        # Eliminate negative numbers if doing subtraction - depending on setting
        if [[ $i == 0 && $i < $NUMBER && $TABLE_MODE == 2 ]]; then
            i=$NUMBER
            LOOP_MAX=$((LOOP_MAX+NUMBER))
        fi
        
        # Special case for division
        if [[ $i == 0 && $i < $NUMBER && $TABLE_MODE == 4 ]]; then
            i=$NUMBER
            LOOP_MAX=$((NUMBER*LOOP_MAX))
        fi
        
        # DEBUG
        # echo "i: $i | LOOP_MAX = $LOOP_MAX "
        
        # Run 'learn tables' loop
        ANS=$(($i$MODE_OP$NUMBER))
        until [ "$ANS" == "$USR_ANS" ]; do
            read -rp "$i $MODE_SYMBOL $NUMBER = " USR_ANS
            if [ "$USR_ANS" == $ANS ]; then
                
                echo -e "$COL_GREEN Correct $SYM_CHECK $COL_RST"
            else
                if [ "$USR_ANS" -gt $ANS ]; then
                    echo -e "$COL_RED $SYM_DOWN Your answer is too high! $SYM_DOWN $COL_RST"
                else
                    echo -e "$COL_RED $SYM_UP Your answer is too Low! $SYM_UP $COL_RST"
                fi
            fi
            sleep 0.2
        done
    }
    waitReset
}

# "Press any key to continue"
function waitReset(){
    echo -e "\\n"
    read -n 1 -s -r -p "Press any key to continue"
}

# Clear any data from the array and replace with '-'
function emptyArray(){
    for ((i=1;i<="$QUIZ_QUSTION_COUNT";i++)) do
        for ((j=0;j<=7;j++)) do
            QARRAY[$i,$j]="-"
        done
    done
}

# Save quiz results to file
writeToFile()
{
    local curr_date
    local curr_time
    curr_date=$(date +"%m-%d-%Y")
    curr_time=$(date +"%T")
    local file_id=$(("$RANDOM" % 999))
    local file="$USER_NAME-$curr_date-$curr_time-$file_id.txt"
    local line=""
    touch "$file"
    >"$file"    # clear the contents of the file
    
    echo "q  a  .  b  a  r  c" >> "$file"

    for((i=0;i<"$QUIZ_QUSTION_COUNT";i++))
    do
        for((j=0;j<7;j++))
        do
            line="${line}${QARRAY[${i},${j}]}  " >> "$file"
        done
        echo "$line" >> "$file"
        line=""
    done
}

# Run tables quiz
function tableQuiz(){
    emptyArray
    checkExistingNumber
    clear
    echo -e "Tables Quiz!"
    echo "No. of Questions: $QUIZ_QUSTION_COUNT"
    echo "Starting Lives: $LIVES"
    echo "Number: $NUMBER"
    echo "Enter '999' to end early"
    waitReset

    echo
    
    Q_COUNT=0
    Q_CORRECT=0
    NUM_RIGHT=0
    for ((i=0;i<"$QUIZ_QUSTION_COUNT";i++)); do
        if [ "$LIVES" -gt 0 ]; then
            Q_COUNT=$(($Q_COUNT+1))
            R_ANS=-1
            while [ "$R_ANS" -lt 0 ]; do
                R_OP_NUM=$(( RANDOM % 4 + 1))
                R_NUM=$(( RANDOM % 13 ))
                # Special case for division
                # if [ "$R_OP_NUM" == 4 ]; then
                #     R_NUM=$(("$R_NUM" * "$NUMBER"))
                # fi
                
                while [ "$R_OP_NUM" == 4 ] && [ $(("$R_NUM"%"$NUMBER")) != 0 ] ; do
                    # R_OP_NUM=$((RANDOM % 4 + 1))
                    R_NUM=$(("$R_NUM" * "$NUMBER"))
                done
                
                case $R_OP_NUM in
                    1) R_OP="+" R_OP_SYM="+";;
                    2) R_OP="-" R_OP_SYM="-";;
                    3) R_OP="*" R_OP_SYM="×";;
                    4) R_OP="/" R_OP_SYM="÷";;
                esac
                R_ANS=$(($R_NUM$R_OP$NUMBER))
            done
            # echo -e "\\n(I: $i ANS: $R_ANS, RIGHT: $NUM_RIGHT)"
            read -rp "$Q_COUNT. $R_NUM $R_OP_SYM $NUMBER = " USR_ANS
            
            if [ "$USR_ANS" == "999" ]; then
                break
            fi

            if [ "$USR_ANS" == $R_ANS ]; then
                Q_RESULT=1
                Q_CORRECT=$(("$Q_CORRECT"+1))
                NUM_RIGHT=$(("$NUM_RIGHT"+1))
                echo -e "$COL_GREEN Correct $SYM_CHECK $COL_RST"
                
                # User gets an extra life after 3 consecutivly correct answers (max. 5)
                if [ "$NUM_RIGHT" == 3 ] && [ "$LIVES" -le 4 ]; then
                    LIVES=$(($LIVES+1))
                    echo -e "You've gained an extra life! $LIVES lives reminaing."
                    NUM_RIGHT=0
                fi
            else
                Q_RESULT=0
                LIVES=$(($LIVES-1))
                echo -e "$COL_RED Incorrect - $LIVES lives remaining $COL_RST"
            fi

            QARRAY[${i},0]=$Q_COUNT
            QARRAY[${i},1]=$R_NUM
            QARRAY[${i},2]=$R_OP
            QARRAY[${i},3]=$NUMBER
            QARRAY[${i},4]=$USR_ANS
            QARRAY[${i},5]=$R_ANS
            QARRAY[${i},6]=$Q_RESULT
        fi
    done
    
    waitReset
    
    echo -e "\\nResults:\\n"
    echo "You got $Q_CORRECT/$QUIZ_QUSTION_COUNT!"
    
    echo "Writing results..."
    writeToFile
    waitReset
}

# Call login menu first
loginMenu

# Call menu function on run
while true; do
    mainMenu
done