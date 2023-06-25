FROM ubuntu:latest

WORKDIR /app

COPY assignment_04.sh

RUN apt-get update && apt-get install -y wget

RUN chmod +x assignment_04.sh

CMD ["./assignment_04.sh"]
