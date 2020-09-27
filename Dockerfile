FROM tomcat
WORKDIR /usr/local/tomcat/webapps/
copy target/my-app.war .
RUN rm -rf ROOT && mv my-app.war ROOT.war
ENTRYPOINT ["sh","/usr/local/tomcat/bin/startup.sh"]
