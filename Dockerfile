# Use an OpenJDK base image
FROM tomcat:latest

# Copy the JAR file into the container
COPY target/mvn-hello-world.war /usr/local/tomcat/webapps/mvn-hello-world.war


