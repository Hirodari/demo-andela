FROM python:3.10-bullseye

WORKDIR '/app'

COPY requirements.txt .

RUN pip install --upgrade pip

RUN pip install --no-cache-dir -r requirements.txt

COPY app.py supermarkt_sales.xlsx .streamlit ./

CMD ["streamlit", "run", "app.py"]
