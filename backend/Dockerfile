FROM python:3.11-slim
RUN apt update && apt install -y curl
WORKDIR /app
COPY app.py .
CMD ["python", "app.py"]
