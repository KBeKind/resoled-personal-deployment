# Stage 1: Build the application
FROM eclipse-temurin:17-jdk-alpine as build

WORKDIR /app

# Copy Gradle wrapper and build script
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# Only download dependencies
# This layer will be cached if the gradle files are unchanged
RUN ./gradlew dependencies

# Copy source code and build the application
COPY src src
RUN ./gradlew build

# Stage 2: Create the final Docker image
FROM eclipse-temurin:17-jdk-alpine

EXPOSE 8080

COPY --from=build /app/build/libs/*.jar /app/resoled-docker.jar

ENTRYPOINT ["java","-jar","/app/resoled-docker.jar"]
