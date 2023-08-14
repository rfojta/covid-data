#!env python3
import requests
import os

URL = 'https://covid19.who.int/WHO-COVID-19-global-table-data.csv'
response = requests.get(URL)
if response.status_code == 200:
    filename = os.path.basename(URL)
    open(filename, 'wb').write(response.content)
    print("Data downloaded successfully")
else:
    print("Failed to download data")
