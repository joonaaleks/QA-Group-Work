FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget unzip curl gnupg \
    libx11-6 \
    libxfixes3 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxshmfence1 \
    libnss3 \
    libnspr4 \
    libglib2.0-0 \
    libgbm1 \
    libdrm2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libasound2 \
    libcairo2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    fonts-liberation \
    xvfb \
    && rm -rf /var/lib/apt/lists/*


# Install matching Chrome-for-Testing
RUN wget -q https://storage.googleapis.com/chrome-for-testing-public/142.0.7444.175/linux64/chrome-linux64.zip \
    && unzip chrome-linux64.zip \
    && mv chrome-linux64 /opt/chrome \
    && ln -s /opt/chrome/chrome /usr/bin/google-chrome \
    && rm chrome-linux64.zip

RUN wget -q https://storage.googleapis.com/chrome-for-testing-public/142.0.7444.175/linux64/chromedriver-linux64.zip \
    && unzip chromedriver-linux64.zip \
    && mv chromedriver-linux64/chromedriver /usr/local/bin/chromedriver \
    && chmod +x /usr/local/bin/chromedriver \
    && rm -rf chromedriver-linux64*


# Add Chrome to PATH
ENV PATH="/opt/chrome/chrome-linux64:${PATH}"

# Install Python libs
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files (your structure)
COPY . /robot
WORKDIR /robot

# Run Robot tests on container start
CMD ["sh", "run-tests.sh"]
