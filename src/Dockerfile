FROM python:3.11.4-bullseye

WORKDIR /app
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY *.py /app/
RUN python get_data.py
ENV CSV_FILE=WHO-COVID-19-global-table-data.csv
CMD ["python", "server.py"]