from sys import exit
from colorama import init, Fore
from consolemenu import ConsoleMenu
from consolemenu.items import FunctionItem, SubmenuItem, CommandItem

# Local Imports
from imports.list import LinkedList, Node
from imports.utils import *

# Initialise Colorama
init(autoreset=True)

# Global Variables
list1 = None


def init():
    global list1
    # Insert initial data
    list1 = LinkedList()
    list1.headval = Node(metadata={"tuneName": "Fairytale of New York"})


def main():
    init()

    # Define main menu
    menu = ConsoleMenu(
        title="Music Library Manager",
        subtitle="Main Menu",
    )
    # Define add menu
    addMenu = ConsoleMenu(
        title="Music Library Manager",
        subtitle="Where would you like to add a new track?",
        exit_option_text="Back"
    )

    # Define main menu options
    opt_display = FunctionItem(
        "Display Music Library", wait_func, [displayLibrary])
    opt_add = SubmenuItem("Add a new track", addMenu)

    # Define add menu options
    opt_add_start = FunctionItem(
        "At the beginning of the list", wait_func, [addTune])

    # Add options to the main menu
    menu.append_item(opt_add)
    menu.append_item(opt_display)

    # Add options to the add menu
    addMenu.append_item(opt_add_start)

    # Display the menu and wait for user input
    menu.show()

    # Print when user runs the 'Exit' option
    print("Exiting...")


def displayLibrary():
    list1.printlist()


def addTune():
    tuneId = input_string("Tune ID")
    tuneName = input_string("Tune Name")
    tuneGroup = input_string("Tune Group")
    tuneGenre = input_string("Tune Genre")
    dateEntry = input_string("Date of Entry")
    chartPosition = input_string("Chart Position")
    price = input_string("Price")

    newTune = {
        "tuneId": tuneId,
        "tuneName": tuneName,
        "tuneGroup": tuneGroup,
        "tuneGenre": tuneGenre,
        "dateEntry": dateEntry,
        "chartPosition": chartPosition,
        "price": price
    }

    list1.InsertAtBeginning(newTune)


# Run main function when script is called directly
if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("Exiting...")
        exit()
