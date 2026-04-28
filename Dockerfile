# Use Tomcat as base image
FROM tomcat:9.0

# Remove default Tomcat apps
RUN rm -rf /opt/tomcat/webapps/*.war

# Copy WAR file into Tomcat
COPY target/roshambo.war /opt/tomcat/webapps/

# Expose port 8080
EXPOSE 8080
