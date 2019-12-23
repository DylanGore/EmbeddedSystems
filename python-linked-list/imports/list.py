class Node:
    def __init__(self, metadata):
        self.metadata = metadata
        self.nextval = None


class LinkedList:
    def __init__(self):
        self.headval = None

    def traverse(self):
        node = self.headval        # start from the head node
        while node != None:
            print(node.metadata)     # access the node value
            node = node.next   # move on to the next node

    def InsertAtBeginning(self, newMetadata):
        NewNode = Node(newMetadata)  # create a new node
        # Update the new nodes next val to existing node
        NewNode.nextval = self.headval
        self.headval = NewNode

    def InsertAtEnd(self, newdata):
        NewNode = Node(newdata)   # create new node
        if self.headval is None:  # is list empty
            self.headval = NewNode
            return
        last = self.headval       # link is not empty
        while(last.nextval):      # loop until end of list
            last = last.nextval   # increment to next node
        last.nextval = NewNode    # set address to new node

    def InsertInMiddle(self, middle_node, newdata):
        if middle_node is None:
            print("The mentioned node is not found")
            return

        NewNode = Node(newdata)         # create new node
        NewNode.nextval = middle_node.nextval
        middle_node.nextval = NewNode

    def RemoveNode(self, Target):
        HeadVal = self.head        # set to start of the list
        if (HeadVal is not None):  # list is not empty
            if (HeadVal.data == Target):
                self.head = HeadVal.next
                HeadVal = None
                return

        while (HeadVal is not None):
            if HeadVal.data == Target:
                break
            prev = HeadVal
            HeadVal = HeadVal.next

        if (HeadVal == None):
            return

        prev.next = HeadVal.next
        HeadVal = None

    def printlist(self):
        """
        Print the list
        """
        printval = self.headval
        while printval is not None:
            print(printval.metadata)
            printval = printval.nextval
