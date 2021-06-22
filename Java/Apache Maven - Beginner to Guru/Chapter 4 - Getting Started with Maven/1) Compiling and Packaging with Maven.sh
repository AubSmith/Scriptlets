mvn --version

mvn clean

mvn package
cd target/
unzip hello-world-0.0.1-SNAPSHOT.jar

cd ..

mvn clean

mkdir -p src/main/java/
mv HelloWorld.java src/main/java/

mvn clean package
cd target/
ls

cd -