FROM mongo:latest

# Встановлюємо pip
RUN apt-get update && apt-get install -y python3-pip

# Встановлюємо botocore
RUN pip3 install botocore

# Запускаємо MongoDB
CMD ["mongod"]