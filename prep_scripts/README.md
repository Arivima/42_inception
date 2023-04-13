/* REQUISITI */

- Questo progetto deve essere eseguito su una macchina virtuale.

- Tutti i file necessari per la configurazione del tuo progetto devono essere posizionati in una cartella srcs.

- È inoltre richiesto un Makefile che deve essere posizionato nella root della directory. 
  - Deve configurare l'intera applicazione (ovvero deve creare le immagini Docker utilizzando docker-compose.yml).

- Ogni immagine Docker deve avere lo stesso nome del servizio corrispondente.

- Ogni servizio deve essere eseguito in un container dedicato.

- Per motivi di prestazioni, i containers devono essere costruiti dalla penultima versione stabile di Alpine Linux o da Debian Buster.

- Scrivere i tuoi Dockerfile, uno per servizio.
  - I Dockerfile devono essere chiamati nel docker-compose.yml dal Makefile.

- Non deve essere presente alcuna password nei Dockerfile.
  - Ciò significa che bisogna creare le immagini Docker del progetto. È quindi vietato scaricare immagini Docker già pronte, 
    nonché utilizzare servizi come DockerHub (Alpine/Debian esclusi).

- L'utilizzo di network: host o --link o links: è vietato.

- I containers non devono essere avviati con un comando che esegue un ciclo infinito. 
  - Quindi stessa cosa per qualsiasi comando utilizzato come entrypoint o utilizzato negli script entrypoint.
    --> Entrypoint: è un comando specificato nell'immagine Docker che viene eseguito quando un container viene avviato. 
                    è l'ultimo comando specificato nell'istruzione Dockerfile e viene eseguito dopo l'istruzione CMD.
    
- Vietato: tail -f, bash, sleep infinity, while true. <--

- Il container NGINX deve essere l'unico punto di ingresso nella tua infrastruttura tramite la porta 443, 
  utilizzando solo il protocollo TLSv1.2 o TLSv1.3.



/* TODO LIST */

V 1) Un container Docker che contiene NGINX con solo TLSv1.2 o TLSv1.3.

 2) Un container Docker che contiene WordPress + php-fpm (deve essere installato e configurato) solo senza nginx.

V 3) Un container Docker che contiene solo MariaDB senza nginx.

4) Un volume che contiene il database di WordPress.
    --> Volume: è una funzionalità che consente ai container di accedere e memorizzare dati al di fuori del sistema dei file del container stesso. Sono utili quando si vuole condividere i dati tra i container o persistere i dati generati da un container anche dopo la sua eliminazione.

5) Un secondo volume che contiene i file del sito web di WordPress.

6) Una docker-network che stabilisce la connessione tra i containers.

7) I containers devono riavviarsi in caso di crash.

8) Nel tuo database WordPress, devono esserci due utenti, uno dei quali è l'admin. 
   - Il nome utente dell'admin non può contenere admin/Admin o administrator/Administrator (ad esempio, admin, administrator, Administrator, admin-123, ecc.).

9) I volumi saranno disponibili nella cartella /home/login/data della macchina host usando Docker. Naturalmente, devi sostituire login con il tuo.

10) Per semplificare le cose, configurare il nome di dominio in modo che punti all'indirizzo IP locale. 
    Questo nome di dominio deve essere login.42.fr. Di nuovo, devi usare il tuo login. 
    Ad esempio, se il tuo login è wil, wil.42.fr reindirizzerà all'indirizzo IP che punta al sito web di wil.

11) È obbligatorio utilizzare le variabili d'ambiente. Inoltre, è fortemente consigliato utilizzare un file .env per archiviare le variabili d'ambiente.


Comandi Docker:

sudo apt install libnss3-tools -y --> Installazione libreria network service

- Immagini attive: docker image ls
- Cancellare definitivamente: docker image prune -a
- Cancellare immagini: docker image rm -f $(docker images -q)
- Cancellare containers: docker container rm -f $(docker ps -aq)
- Costruire immagine: docker image build -t <nome-img> .
- Nome containers attivi: docker container ps —format “{{.Names}}”
- Attivare container: docker container run -d -p <porta>:<porta> <nome-cntr>

- Controllare info container: docker container inspect https_server
- Controllo containers: docker container logs <nome-cntr>
- Controllo directory containers: docker container exec -it https_server mkdir -p /etc/nginx/certs
- Stoppare e rimuovere vecchio container: docker  container stop <nome-cntr> && docker rm <nome-cntr>
- Entrare e controllare esistenza delle cartelle/file: docker container exec -it <cntr-id> sh


MARIADB:

MARIADB useful commands
  mysql -uroot // To connect on mysql CLI
  SELECT User FROM mysql.user; // To see all the users
  USE wordpress // To connect on your wordpress database
  mysqldump -u username -p databasename > filename.sql // To export the file
  mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql // To import the file
  What are the steps to create your own Maria DB image
  Create a dockerfile

Download mariadb-server && mariadb-client
To run mariaDB on your container, you have to copy your .sh and the .sql on the /var/local/bin/
Give the right to execute your mysqld (which is the daemon for mysql)
Launch your script to install mariaDB
Then do a CMD to enable the database to listen to all the IPV4 adresses.
Create a script (.sh file)

mysql_install_db initializes the MySQL data directory and creates the system tables that it contains, if they do not exist
In this script we downloaded Maria DB on the container, we have to install it and create the root user
Then we launch the commandline to give all the privileges to the root user. The function GRANT from mysqlcli (sql command line) gives access (or all access) to a user.
Create your file.sql

2 options :
You create the database, the user and you give all privileges to the user as malatini did
You export your own wordpress.sql as I did (and Lea did !!!!)
Step 1: Create your admin user on wordpress: You might don't know what it is, no prob! It means you will export your admin user from your database in order to put it in your .sql file.
Go to your wordpress website (localhost:443) and create your user by using the same username and password as your .env file.
Step 2: Export your admin user.sql You have to go on your mariaDB container and do the following command
mysqldump -u 'username' -p 'databasename' > filename.sql it will export your user on the filename.sql, please change username, databasename by what you put in your .env file
You have a file called filename.sql in your current directory
"cat filename.sql" in your container and copy past to your .sql project.
Your .sql is ready now to be imported
Step 3: relaunch your docker-compose
TADA you will be directly in your website by passing the phase of installation Wordpress without installation
Commands to check if all is working
	SHOW DATABASES; // show the databes
	use 'wordpress'; // go in the wordpress databse
	SHOW TABLES; // show all the tables from the database you selected
	SELECT wp_users.display_name FROM wp_users; // display username from wordpress database
	SELECT *  FROM wp_users; // select
