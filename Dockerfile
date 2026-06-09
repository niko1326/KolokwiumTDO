# Minimalny obraz Python
FROM python:3.9-slim

# Ustawienie katalogu roboczego
WORKDIR /app

# Kopiowanie zależności najpierw dla optymalizacji cache warstw
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Kopiowanie reszty kodu aplikacji
COPY . .

# Deklaracja portu
EXPOSE 8000

# Polecenie startowe
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app.main:app"]