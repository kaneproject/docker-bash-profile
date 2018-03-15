# Pull docker images (for non-internet periods)
function pullAllDockerImages(){
    docker pull mongo:3.7.2-jessie
    docker pull kaneproject/docker-asciidoctor-revealjs:latest
    docker pull kaneproject/docker-git:2.15.0-r1
    docker pull mhart/alpine-node:7.4.0
    docker pull elasticsearch:5.6.8-alpine
    docker pull kaneproject/wildfly:v8
    docker pull kaneproject/wildfly:v9
    docker pull kaneproject/wildfly:v10
    docker pull playniuniu/weblogic-domain:12.2.1.2
    docker pull maven:3.5.0-jdk-8-alpine
    docker pull sath89/oracle-12c:latest
    docker pull kaneproject/ansible:2.4.3.0
}
# Destroy all persistent data
function clearAll(){
   docker volume rm mongodb-data
   docker volume rm maven-data 
   docker volume rm oracle-data
   docker volume rm git-global
}
# Add local certs to volume (we can use it to commit to github ;))
function addCertsToGitVM(){
  docker run -v git-global:/data --name helper busybox true
  docker cp $HOME/.ssh helper:/data
  docker rm helper
  docker rmi busybox
}
# MongoDB Functions
function mongod() {
    docker run --rm -p 27017:27017  -v mongodb-data:/data/db -w /data/db mongo:3.7.2-jessie mongod "$@"
}
function mongo() {
    docker run --rm -it --network=host -v "${PWD}":/mnt -w /mnt mongo:3.7.2-jessie mongo $@
}
function mongoimport() {
    docker run --rm -it --network=host -v "${PWD}":/mnt -w /mnt mongo:3.7.2-jessie mongoimport $@
}
# Asciidoctor Functions
function asciidoctor() {
    docker run --rm -it -v "${PWD}":/documents kaneproject/docker-asciidoctor-revealjs:latest asciidoctor "$@"
}
function asciidoctor-pdf() {
    docker run --rm -it -v "${PWD}":/documents kaneproject/docker-asciidoctor-revealjs:latest asciidoctor-pdf "$@"
}
function revealjs() {
    docker run --rm -it -v "${PWD}":/documents kaneproject/docker-asciidoctor-revealjs:latest "$@"
}
# Git with ssh client
function git() {
    docker run --rm -it -v "${PWD}":/mnt -v git-global:/root -w /mnt kaneproject/docker-git:2.15.0-r1 "$@"
}
# Basic node functions 
function npm() {
    docker run --rm -it -v "${PWD}":/mnt -w /mnt mhart/alpine-node:7.4.0 npm $@
}
function node() {
    docker run --rm -it -v "${PWD}":/mnt -w /mnt mhart/alpine-node:7.4.0 node $@
}
# Elasticsearch function
function elasticsearch() {
    docker run --rm -it -p 9200:9200 elasticsearch:5.6.8-alpine
}
# Jboss Functions
function jboss-as-8-standalone(){	
	docker run --rm -it -p 8080:8080 -p 9990:9990 kaneproject/wildfly:v8 /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
}
function jboss-as-8-domain(){	
	docker run --rm -it -p 8080:8080 -p 9990:9990 kaneproject/wildfly:v8 /opt/jboss/wildfly/bin/domain.sh -b 0.0.0.0 -bmanagement 0.0.0.0
}
function jboss-as-9-standalone(){	
	docker run --rm -it -p 8080:8080 -p 9990:9990 kaneproject/wildfly:v9 /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
}
function jboss-as-9-domain(){	
	docker run --rm -it -p 8080:8080 -p 9990:9990 kaneproject/wildfly:v9 /opt/jboss/wildfly/bin/domain.sh -b 0.0.0.0 -bmanagement 0.0.0.0
}
function jboss-as-10-standalone(){	
	docker run --rm -it -p 8080:8080 -p 9990:9990 kaneproject/wildfly:v10 /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
}
function jboss-as-10-domain(){	
	docker run --rm -it -p 8080:8080 -p 9990:9990 kaneproject/wildfly:v10 /opt/jboss/wildfly/bin/domain.sh -b 0.0.0.0 -bmanagement 0.0.0.0
}
# Weblogic function
function weblogic-12c(){
	docker run --rm -it -p 8001:8001 -p 7001:7001 -p 5556:5556 playniuniu/weblogic-domain:12.2.1.2
} 
# Maven function. We can deal with parent directories using the most parent directory and launch with mvn -C <child dir> instruction
function mvn(){
    docker run -it -rm -v maven-data:/root/.m2 -v "$PWD":/usr/src/mymaven -w /usr/src/mymaven maven:3.5.0-jdk-8-alpine mvn "$@"
}
# Oracle 12c express (ready to connect!)
function oracle12c() {
    echo "DATABASE CONNECTION"
    echo "-------------------"
    echo "hostname: localhost"
    echo "port: 1521"
    echo "sid: xe"
    echo "service name: xe.oracle.docker"
    echo "username: system"
    echo "password: oracle"
    echo "-------------------"
    echo "PASSWORD SYS & SYSTEM: oracle"
    echo "Oracle Aplication EXpress Web Management Console"
    echo "URL: http://localhost:8080/apex"
    echo "workspace: INTERNAL"
    echo "user: ADMIN"
    echo "password: 0Racle$"
    echo "-------------------"
    echo "Oracle Enterprise Management console"
    echo "http://localhost:8080/em"
    echo "user: sys"
    echo "password: oracle"
    echo "URL project: https://hub.docker.com/r/sath89/oracle-12c/"
    echo "Launch!"
    docker run --rm -it -p 1521:1521 -p 8080:8080  -v oracle-data:/u01/app/oracle sath89/oracle-12c
}
# Ansible functions (not tested yet)
function ansible-playbook(){
    docker run -it --rm -v "$PWD":/mnt -w /mnt kaneproject/ansible:2.4.3.0 ansible-playbook "$@"
}
function ansible-galaxy(){
    docker run -it --rm -v "$PWD":/mnt -w /mnt kaneproject/ansible:2.4.3.0 ansible-galaxy "$@"
}
