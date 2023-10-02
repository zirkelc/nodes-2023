Create AWS EC2 instance with Neo4j Enterprise v.4.4.11

```
./stack/create-stack.sh
```

Delete AWS EC2 instance

```
./stack/delete-stack.sh
> Enter stack name: nodes-2023-neo4j-v4-4-11
```

Neo4j Custom Code

<https://github.com/neo4j-examples/neo4j-procedure-template/tree/4.4"&gt;https://github.com/neo4j-examples/neo4j-procedure-template/tree/4.4>

Build

```
mvn clean package
```

### Install Plugin

1. Plugin JAR von lokalen Computer auf den Server [hochloaden](README.md#file-upload--download)

   ```sh
   # scp -i <ssh-key.pem> <source file> <targe folder>
   scp -i nebula-ssh-key.pem extension.jar ec2-user@ec2-34-253-89-33.eu-west-1.compute.amazonaws.com:.
   ```

2. In den Server [einloggen](README.md#ssh-access)(nur noch von diesem Projekt aus möglich)

   ```sh
   # ssh -i <ss-key.pem> <user>@<public-ip-address-or-dns>
   ssh -i nebula-ssh-key.pem ec2-user@ec2-34-253-89-33.eu-west-1.compute.amazonaws.com
   ```

3. Plugin JAR in den Ordner `/var/lib/neo4j/plugins` verschieben:

   ```sh
   # sudo mv <source-files> <target-folder>
   sudo mv neo4j-flyweight-extension-1.0.21.jar /var/lib/neo4j/plugins
   ```

4. Besitzer und Gruppe des Plugin JAR zu `neo4j` ändern:

   ```sh
   # sudo chown -R <owner>:<group> <files>
   sudo chown -R neo4j:neo4j /var/lib/neo4j/plugins/neo4j-flyweight-extension-1.0.21.jar
   ```

5. Berechtigung des Plugin JAR zu `+x` (executable) ändern:

   ```sh
   # sudo chmod +x <files>
   sudo chmod +x /var/lib/neo4j/plugins/neo4j-flyweight-extension-1.0.21.jar
   ```

6. Datei-Eigenschaften der Plugin JAR überprüfen:

   ```sh
   # ls -l [folder]
   ls -l /var/lib/neo4j/plugins
   ```

Whitelist plugin

```
sudo nano /etc/neo4j/neo4j.conf
```

Allow

```
# Example allow listing
dbms.security.procedures.allowlist=apoc.coll.*,apoc.load.json,example.*
```

<https://neo4j.com/docs/operations-manual/current/security/securing-extensions/"&gt;https://neo4j.com/docs/operations-manual/current/security/securing-extensions>

1. Neo4j Service [neustarten](README.md#neo4j-service-starten--stoppen):

   ```sh
   sudo systemctl restart neo4j
   ```

# 

# SHOW PROCEDURES

> 