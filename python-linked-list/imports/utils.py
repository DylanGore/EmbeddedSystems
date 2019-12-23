def wait_func(func, *args):
    """
    Adds a 'press enter to continue...' prompt after each function call for use with menu
    Parameters:
            func - the function to run before the prompt
            *args - any arguments that should be passed to the function
    """
    # logging.info(f"User called {func.__name__} from menu")
    func(*args)
    input("\nPress enter to continue...")


def input_string(prompt):
    """
    Gets a string input from the user and formats it using RegEx
    Parameters:
            prompt - the question to ask the user
            replace_spaces - if the function should replace spaces with another char
            space_char - the char to replace spaces with
            min_len - the minimum length for the string to be considered valid
    Return:
            usr_input - the formatted string
    """
    regex = r"([^a-zA-Z0-9\-\_])"  # RegEx of accepted chars
    # Display user prompt
    usr_input = str(input(f"{prompt}: "))
    usr_input = usr_input.strip()  # remove trailing and leadaing whitespace

    return usr_input
