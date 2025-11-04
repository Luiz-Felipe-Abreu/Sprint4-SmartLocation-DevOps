# ---------- Build stage ----------
FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /app
COPY . .
# Build without tests for faster container build; change to 'build' to run tests
RUN chmod +x ./gradlew && ./gradlew clean bootJar --no-daemon

# ---------- Runtime stage ----------
FROM eclipse-temurin:17-jre-alpine AS runtime

# Create non-root user
RUN addgroup -S app && adduser -S app -G app
USER app

WORKDIR /app
EXPOSE 8080

# Copy the fat jar from build stage
COPY --from=build /app/build/libs/*SNAPSHOT.jar /app/app.jar

ENTRYPOINT ["java","-jar","/app/app.jar"]
