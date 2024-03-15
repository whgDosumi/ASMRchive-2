FROM docker.io/library/python:3.12.2

# We'll work out of the /app folder
WORKDIR /app

RUN apt-get update && apt-get install -y redis

# Copy in and install requirements
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy in rest of the application
COPY . /app/

# Expose port 8000 for the webserver
EXPOSE 8000

# Run the server
ENTRYPOINT [ "/app/entrypoint.sh" ]