-- Test table creation

/*
create table tbltest (testing text);
*/

CREATE TABLE [IF NOT EXISTS] os_login (
    user_id serial PRIMARY KEY,
	username VARCHAR ( 50 ) UNIQUE NOT NULL,
        last_login TIMESTAMP 
);

INSERT INTO os_login(user_id, username, last_login)
VALUES (1, 'distributionuser', current_timestamp);