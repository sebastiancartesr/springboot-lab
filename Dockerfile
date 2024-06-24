# Etapa de construcción
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app

# Copiar el archivo pom.xml y descargar las dependencias
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar el resto del código fuente y compilar la aplicación
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa de despliegue
FROM tomcat:10.1.10-jdk17
WORKDIR /usr/local/tomcat/webapps/

# Copiar el WAR generado desde la fase de compilación anterior
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.war ./ROOT.war

# Exponer el puerto 8080
EXPOSE 8080

# Iniciar Tomcat
CMD ["catalina.sh", "run"]
