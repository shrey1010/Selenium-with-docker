FROM python:3.8

# Adding trusting keys to apt for repositories
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

# Adding Google Chrome to the repositories
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# Updating apt to see and install Google Chrome
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable

# Installing Unzip
RUN apt-get install -yqq unzip

# Download the Chrome Driver
RUN wget -O /tmp/chromedriver.zip "https://storage.googleapis.com/chrome-for-testing-public/125.0.6422.78/linux64/chromedriver-linux64.zip"

# Unzip the Chrome Driver into /usr/local/bin directory
RUN unzip /tmp/chromedriver.zip -d /tmp/
RUN mv /tmp/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver
RUN rm /tmp/chromedriver.zip && rm -rf /tmp/chromedriver-linux64


# Set display port as an environment variable
ENV DISPLAY=:99

COPY . /app
WORKDIR /app

RUN pip install --upgrade pip

RUN pip install -r requirements.txt

CMD ["python", "./app.py"]