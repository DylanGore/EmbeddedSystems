import random
import re
import linecache
import random
from os import system, name, path, remove
from sys import exit
from asciiman import graphics

# Define global variables
total_words = 370103  # line count for words.txt
min_length = 5
max_length = 8
regex_upper = "[^A-Z]"  # exclude anything that isn't uppercase
game_mode = 1
guessed = False
guesses = []
lives = 6  # Number of hangman images
word = ''


def main():
    """
    Entry point - shows main menu
    """
    global game_mode

    # Clear Screen
    clear()

    # Print Menu
    print("\nHANGMAN GAME\n")
    print("1. Classic Hangman")
    print("2. Word Length + 1 Lives")
    print("3. Testing/Demo Mode")

    # Get user input, default to mode 1 if error
    try:
        game_mode = int(input('Choose Game Mode: '))
        if game_mode == 2:
            print("L + 1")
        elif game_mode == 3:
            print("Debug Mode")
        else:
            print("Classic")
    except:
        game_mode = 1

    # Start game
    game()


def game():
    """
    The main game loop
    """

    global lives, guessed, guesses, game_mode, word

    # Get a random word
    word = get_word()

    # L + 1 Mode
    if game_mode == 2:
        lives = len(word) + 1

    # Print the word to the screen with blanks
    display_word = define_display_word(word)

    while not guessed:
        guess = ''

        # Print the hangman graphic and life counter
        display_hangman(guess, lives, display_word)

        # Get user input
        guess = input('Your Guess > ').upper()

        # Remove anything that's not a capital letter using RegEx
        guess = re.sub(regex_upper, '', guess)

        # If the user entered nothing, stop current iteration of the loop
        if (len(guess) < 1):
            print('Invalid guess!')
            # Stop this iteration of the loop on invalid guess
            continue

        # Add the user's guess to the list of guesses and check the answer
        guesses.append(guess)
        check_answer(guess, word, display_word)

        # If the user has guessed the full word exit the loop entirely
        if guessed:
            print("You Win!")
            break

        # Exit the loop if the user has run out of lives
        if lives == 0:
            break

    print("Game over!")


def define_display_word(word):
    """
    Used to print the initial 'display word' prints the length
    of the random word in blanks
    """
    display_word = []
    for i in range(0, len(word)):
        display_word.append('_')

    return display_word


def get_word():
    """
    Gets a single random word from a list of words, it must be between a min and max length
    """
    global game_mode
    file_name = 'words.txt'  # List of words
    word = ''  # current word

    # Loop through list of words until a suitible one is found
    while len(word) < min_length or len(word) >= max_length:
        # get a random number that corresponds to a line number in words.txt
        line = random.randint(1, total_words)

        # Debug Mode - use simple list of words
        if game_mode == 3:
            file_name = 'simple-words.txt'

        # Get contents of a specific line rather than looping through each one, convert to uppercase
        word = linecache.getline(file_name, line).upper()

        # Remove any invalid chars
        word = re.sub(regex_upper, '', word)

    wFileName = 'currWord.txt'

    # Remove if file already exists
    if(path.exists(wFileName)):
        remove(wFileName)

    # Save the chosen word to a file
    wFile = open(wFileName, 'w')
    wFile.write(word)
    wFile.close()

    return word


def check_answer(usr_input, word, display_word):
    """
    Checks the user's guess against the word
    """
    global guessed, lives

    if (len(usr_input) > 1):
        # User is guessing the entire word
        if usr_input == word:
            print("Correct!")
            guessed = True
        else:
            print("Wrong!")
            # Take a life
            lives = lives - 1
    else:
        # User is guessing a single letter
        count = 0
        for i in range(len(word)):
            if str(usr_input) == word[i]:
                count = count + 1
                # If the guessed letter is in the word, replace the blank in the one printed to screen
                display_word[i] = usr_input
        # If there are no blanks left, the word must be known and the game is won
        if not '_' in display_word:
            guessed = True

        # If none of the chars matched the guess, remove a life
        if count == 0:
            # Take a life
            lives = lives - 1


def display_hangman(guess, lives, display_word):
    """
    Prints the hangman graphic to screen, displays the life counter and list of guesses
    """
    global game_mode
    global guesses

    clear()  # Clear the screen

    # Don't print the graphic in L + 1 mode as the number of lives may exceed the number of graphics
    if(game_mode != 2):
        print(graphics[lives])

    print(f'Lives: {str(lives)}')

    # Display the correct answer when running in demo/debug mode
    if game_mode == 3:
        print(f'Word: {word}')

    # Print the 'display word' to the screen
    for char in display_word:
        print(char, end=" ")
    print("\n")

    # Print the list of guesses if there is any to print
    if len(guesses) > 0:
        print("Guesses: ")
        for guess in guesses:
            print(guess, end=" ")
        print("\n")


def clear():
    """
    Clear Terminal
    """
    if name == 'nt':
        _ = system('cls')  # Windows
    else:
        _ = system('clear')  # Unix/Linux


if __name__ == '__main__':
    try:
        # Start the program
        main()
    except KeyboardInterrupt:
        # Handle keyboard exists (Ctrl + C)
        print("\n\nExiting...")
        exit()
