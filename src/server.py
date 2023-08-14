from flask import Flask
import csv
import os

app = Flask(__name__)
csv_file = os.environ.get('CSV_FILE')

def addStyle(out):
    out.append('<style>')
    out.append('''
table#data td {
    border: 1px solid
} 

table#data {
    border: 1px solid
}
    ''')
    out.append('</style>')

def addRow(out, row):
    out.append('<tr><td>')
    out.append('</td><td>'.join(row))
    out.append('</td></tr>')

def addTable(out, datareader):
    out.append("<table id='data'>")
    i = 0
    for row in datareader:
        if i == 0 or row[0] == 'Czechia':
            addRow(out, row)
        i += 1
    out.append('</table>')

@app.route('/')
def csvToTable():
    out = []
    with open(csv_file, newline='') as csvfile:
        datareader = csv.reader(csvfile, delimiter=',')
        addTable(out, datareader)  
    addStyle(out)
    return "\n".join(out)

if __name__ == '__main__':
    app.run(debug=True)