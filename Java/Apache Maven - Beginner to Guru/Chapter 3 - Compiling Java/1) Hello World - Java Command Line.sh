vi HelloWorld.java
ls

javac HelloWorld.java
ls

java HelloWorld

# Create Java jar Files From Command Line
jar cf myjar.jar HelloWorld.class # cf = Create File
ls

# Run class HelloWorld from myjar.jar
java -classpath myjar.jar HelloWorld

mv myjar.jar /var/tmp
unzip myjar.jar 

cd META-INF
cat MANIFEST.MF