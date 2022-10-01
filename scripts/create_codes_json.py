import csv
import json

csv_file_path = "data\codes.csv"

dictionary = {}

#Open Csv file
with open(csv_file_path, encoding = 'utf-8') as csv_file_handler:
    csv_reader = csv.DictReader(csv_file_handler)
    for row in csv_reader:

        # if category not already in dictionary
        sub_codes = row["\ufeffAccount"].split('/')
        if sub_codes[0] not in dictionary:
            dictionary[sub_codes[0]] = {
                "Classification": row["Classification"],
                "Expected Sign": row["Expected Sign"],
                "Title": row["AccountControl.Account Title"],
                "Sub Codes": {}
            }

        if len(sub_codes) > 1:
            print(sub_codes[1])
            # dictionary[sub_codes[0]]["Sub Codes"].append({
            #     "Code": sub_codes[1],
            #     "Narration": row["Narration"] 
            # })

            dictionary[sub_codes[0]]["Sub Codes"][sub_codes[1]] = {
                "Narration": row["Narration"] 
            }
        # print(dictionary)




# Serializing json
json_object = json.dumps(dictionary, indent=4)
 
# Writing to sample.json
with open("data/codes.json", "w") as outfile:
    outfile.write(json_object)