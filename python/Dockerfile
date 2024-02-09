FROM python:3.12.2

# This is where the appliction will live in the container
WORKDIR /app

# Copy the appdata into the container
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Run the run.py script when the container launches
CMD ["python", "run.py"]