FROM eclipse-temurin:17.0.11_9-jre
EXPOSE 8180
ARG JAR_FILE=target/*.jar
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]