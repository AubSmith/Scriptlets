postgres:
  container_name: postgres
  restart: always
  image: postgres:latest
  volumes:
    - ./database:/opt/postgresql/data
  ports:
    - "5432:5432



   version: "3"
   services:
     db:
       image: postgres
       environment:
         - POSTGRES_USER=postgres
         - POSTGRES_PASSWORD=postgress
         - POSTGRES_DB=postgres
       ports:
         - "5433:5432"
       volumes:
         - pgdata:/var/lib/postgresql/data
       networks:
         - suruse
   volumes: 
     pgdata: