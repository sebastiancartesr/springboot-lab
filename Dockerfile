# Utilizar la imagen oficial de Maven para compilar la aplicación
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app

# Copiar el archivo pom.xml y descargar las dependencias
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar el resto del código fuente y compilar la aplicación
COPY src ./src
RUN mvn clean package -DskipTests

# Utilizar la imagen oficial de OpenJDK para correr la aplicación
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copiar el JAR generado desde la fase de compilación anterior
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

# Definir el comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
