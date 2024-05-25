# Use Python 3.11 as the base image
FROM python:3.11

# Install necessary system dependencies
RUN apt-get update && \
    apt-get install -y build-essential wget && \
    rm -rf /var/lib/apt/lists/*

# Download and install TA-Lib
RUN wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
    tar -xzvf ta-lib-0.4.0-src.tar.gz && \
    cd ta-lib && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    cd .. && \
    rm -rf ta-lib ta-lib-0.4.0-src.tar.gz

# Set working directory
WORKDIR /

# Copy requirements.txt file into the container
COPY linux_requirements.txt .

# Install wheel package
RUN pip install wheel
RUN pip install -U setuptools

# Install Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r linux_requirements.txt

# Copy the current directory contents into the container at the root directory
COPY . .

# Expose port 8000 to the outside world
EXPOSE 8000

# Command to run the application using uvicorn
CMD ["python3", "-u", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]