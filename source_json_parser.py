import pandas as pd
import json


# Load the CSV file
df = pd.read_csv('source_data.csv', encoding='utf-8')

# Print the column names to check their actual format
print(df.columns)

# Select the required columns and rename them for the JSON output
df = df[['地震時間', '規模', '經度', '緯度']]
df.rename(columns={
    '地震時間': 'Time',
    '規模': 'Magnitude',
    '經度': 'Longitude',
    '緯度': 'Latitude'
}, inplace=True)

# Format the 'Time' column to match the specified format (MM-DD HH:MM)
df['Time'] = pd.to_datetime(df['Time']).dt.strftime('%m-%d %H:%M')

# Convert DataFrame to JSON
result_json = df.to_dict(orient='records')

# Save to JSON file
with open('output_data.json', 'w') as file:
    json.dump(result_json, file, indent=4)

print("JSON file has been created with the required format.")
