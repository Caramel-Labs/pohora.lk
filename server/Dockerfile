# Use OpenJDK image
FROM openjdk:17-jdk-alpine

# Set working directory
WORKDIR /app

# Copy built JAR into container
COPY target/AgriAsistant-Server.jar app.jar
COPY .env .env

# Expose the port your app runs on
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
