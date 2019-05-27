FROM tomcat:8
# Take the war and copy to webapps of tomcat

RUN apt-get update
RUN apt-get install wget net-tools
COPY target/*.war /usr/local/tomcat/webapps/
