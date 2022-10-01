import csv
import json

csv_file_path = "data\categories.csv"

dictionary = {}

#Open Csv file
with open(csv_file_path, encoding = 'utf-8') as csv_file_handler:
    csv_reader = csv.DictReader(csv_file_handler)
    for rows in csv_reader:

        # if category not already in dictionary
        if rows["\ufeffClasification"] not in dictionary:
            dictionary[rows["\ufeffClasification"]] = []

        # Add the narration
        dictionary[rows["\ufeffClasification"]].append(rows["Narration"])
 
# Serializing json
json_object = json.dumps(dictionary, indent=4)
 
# Writing to sample.json
with open("data/categories.json", "w") as outfile:
    outfile.write(json_object)