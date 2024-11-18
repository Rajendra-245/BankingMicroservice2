DevOps for Banking Microservices
This project demonstrates the implementation of DevOps practices for a banking microservice. It covers Git repository management, build automation with Maven, server provisioning using Ansible, and containerization with Docker.

Prerequisites
Ensure the following are installed:

Git
Docker and Docker Compose
Maven
Ansible
Java 11 or higher
Apache Tomcat (via Docker)
Project Structure
BankingMicroservice/
├── src/
│   ├── main/
│   │   └── java/com/bank/App.java
│   ├── test/
│       └── java/com/bank/AppTest.java
├── Dockerfile
├── docker-compose.yml
├── playbook/
│   ├── install_java_apache.yml
│   ├── setup_docker.yml
├── pom.xml
├── .gitignore
├── README.md
Instructions
1. Git Repository Setup
Clone the repository:

git clone https://github.com/<your-username>/BankingMicroservice.git
cd BankingMicroservice
Create branches for developers:

git branch dev1
git branch dev2
Switch to a branch, make changes, and push:

git checkout dev1
git add .
git commit -m "Feature by Developer 1"
git push origin dev1
Merge branches into main:

git checkout main
git merge dev1
git merge dev2
git push origin main
2. Maven Build Automation
Build the project:

mvn clean package
Run unit tests:

mvn test
Generate the .jar file:

The .jar file will be created in the target/ directory.
3. Ansible Playbook Execution
Prepare production servers:

Install Java and Apache:
ansible-playbook playbook/install_java_apache.yml
Setup Docker and Docker Compose:
ansible-playbook playbook/setup_docker.yml
Start the Apache service on the client server:

sudo systemctl start apache2
4. Docker Deployment
Build the Docker image:

docker build -t banking-microservice:1.0 .
Run the Docker Compose file:

docker-compose up -d
Verify the container:

docker ps
5. Accessing the Application
Tomcat Default Page:

Open http://<client-public-ip>:80 in your browser.
Microservice Endpoint:

Access http://<ansible-controller-public-ip>:8000/hello.
Test with curl:

curl http://<public-ip>:8000/hello
6. Cleanup
To stop and remove the running Docker containers:

docker-compose down
Output Validation
Maven Build: Check the target/ folder for the .jar file.
Docker Deployment: Verify the application logs:
docker logs <container-id>
