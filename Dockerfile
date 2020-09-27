FROM tomcat
WORKDIR /webapps
copy target/my-app-1.0-SNAPSHOT.jar .
RUN rm -rf ROOT && mv my-app-1.0-SNAPSHOT.jar ROOT.war
ENTRYPOINT ["sh","/usr/local/tomcat/bin/startup.sh"]
