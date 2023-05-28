# Using official python runtime base image
FROM python

# Set the application directory
WORKDIR /app

# Copy requirements.txt and install dependencies
COPY requirements.txt .

# Virtual environment (venv) is created and activated before installing the dependencies. 
# This ensures that pip is executed within the virtual environment, avoiding any potential conflicts.
RUN python -m venv venv
RUN /bin/bash -c "source venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt --no-cache-dir"

# Copy our code from the current folder to /app inside the container
COPY . .

# Make port 80 available for links and/or publish
EXPOSE 80

# Define our command to be run when launching the container
CMD ["python", "app.py"]
# ENTRYPOINT python app.py



