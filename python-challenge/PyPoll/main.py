import os
import csv

# Path to collect data from the Resources folder
PypollCSV = os.path.join('Resources', 'election_data.csv')


# Read in the CSV file
with open(PypollCSV, 'r') as csvfile:

    # Split the data on commas
    csvreader = csv.reader(csvfile, delimiter=',')

    header = next(csvreader)
    
    count_votes = 0
    khan_votes = 0
    correy_votes = 0
    li_votes = 0
    otooley_votes = 0

    for row in csvreader:
        count_votes = count_votes + 1
        if row[2] == "Khan":
            khan_votes = khan_votes + 1
        elif row[2] == "Correy":
            correy_votes = correy_votes + 1
        elif row[2] == "Li":
            li_votes = li_votes + 1
        elif row[2] == "O'Tooley":
            otooley_votes = otooley_votes + 1
    
    
    khan_percentage = khan_votes / count_votes
    correy_percentage = correy_votes / count_votes
    li_percentage = li_votes / count_votes
    otooley_percentage = otooley_votes / count_votes

    winner_percentage = max(khan_percentage, correy_percentage, li_percentage, otooley_percentage)
    
    if winner_percentage == khan_percentage:
        winner = "Khan"
    elif winner_percentage == correy_percentage:
        winner = "Correy"
    elif winner_percentage == li_percentage:
        winner = "Li"
    elif winner_percentage == otooley_percentage:
        winner = "O'Tooley"
    

    khan_percentage_format = str("{0:.0f}%".format(khan_percentage * 100))
    correy_percentage_format = str("{0:.0f}%".format(correy_percentage * 100))
    li_percentage_format = str("{0:.0f}%".format(li_percentage * 100))
    otooley_percentage_format = str("{0:.0f}%".format(otooley_percentage * 100))

    print("-----------------------------------")
    print("Election Results")
    print("-----------------------------------")
    print("Total Votes: " + str(count_votes))
    print("-----------------------------------")
    print("Khan: " + khan_percentage_format + " (" + str(khan_votes) + ")")
    print("Correy: " + correy_percentage_format + " (" + str(correy_votes) + ")")
    print("Li: " + li_percentage_format + " (" + str(li_votes) + ")")
    print("O'Tooley: " + otooley_percentage_format + " (" + str(otooley_votes) + ")")
    print("-----------------------------------")
    print("Winner: " + str(winner))

    f = open("file.txt", "w")


    text = f"""
    

    -----------------------------------
    Election Results
    -----------------------------------
    Total Votes: ({count_votes})
    -----------------------------------
    Khan: {khan_percentage_format} ({str(khan_votes)})
    Correy: {correy_percentage_format} ({str(correy_votes)})
    Li: {li_percentage_format} ({str(li_votes)})
    O'Tooley: {otooley_percentage_format} ({str(otooley_votes)})
    -----------------------------------
    Winner: {str(winner)}
    """
    f.write(text)
    f.close