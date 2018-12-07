import os
import csv

# Path to collect data from the Resources folder
PybankCSV = os.path.join('Resources', 'budget_data.csv')


# Read in the CSV file
with open(PybankCSV, 'r') as csvfile:

    # Split the data on commas
    csvreader = csv.reader(csvfile, delimiter=',')

    header = next(csvreader)
    
    total = 0
    count_months = 0
    avg_change = 0
    x = 0
    
    diff_list = []
    dict_dates = {}

    for row in csvreader:
        count_months = count_months + 1
        total = total + int(row[1])
        if x == 0:
            x = int(row[1])
        else:
            diff = int(row[1]) - x
            diff_list.append(diff)
            dict_dates.update({diff:row[0]})
            x = int(row[1]) 
    
    greatest = max(diff_list)
    least = min(diff_list)
    
    avg_change = sum(diff_list) / (count_months - 1)



    print("-----------------------------------")    
    print("Financial Analysis")
    print("-----------------------------------")
    print("Total Months: " + str(count_months))        
    print("Total: $" + str(total))        
    print("Average Change: $" + str(avg_change))
    print("Greatest Increase in Profits: " + dict_dates.get(greatest) + " $(" + str(greatest) + ")")
    print("Greatest Decrease in Profits: " + dict_dates.get(least) + " $(" + str(least) + ")")

    f = open("file.txt", "w")

    text = f"""
    
    ----------------------------------
    Financial Analysis
    Total Months: {str(count_months)}        
    Total: ${total}        
    Average Change: ${avg_change}
    Greatest Increase in Profits: {dict_dates.get(greatest)} $({str(greatest)})
    Greatest Decrease in Profits: {dict_dates.get(least)} $({str(least)})
    """
    f.write(text)
    f.close