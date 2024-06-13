FROM adoptopenjdk/openjdk11:alpine-jre
ARG artifact=target/sample-0.0.1-SNAPSHOT.jar
WORKDIR /opt/app
COPY ${artifact} app.jar
ENTRYPOINT ["java","-jar","app.jar"]