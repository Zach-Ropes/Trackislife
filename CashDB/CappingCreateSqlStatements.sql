/*Capping SQl Create Tables
Copy and paste into psql while connected to database to create all of your tables*/

CREATE TABLE IF NOT EXISTS Admin
(
    Account_Password character varying(20) COLLATE pg_catalog.default NOT NULL,
    Account_Username text COLLATE pg_catalog.default NOT NULL,
    CONSTRAINT Account_Username_Pk PRIMARY KEY (Account_Username),
    CONSTRAINT Account_Username_Unique UNIQUE (Account_Username)
);

CREATE TABLE IF NOT EXISTS Survey
(
    Survey_Version serial NOT NULL,
    Survey_Name text NOT NULL,
    Date_Made date NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT Survey_Pk PRIMARY KEY (Survey_Version)
);

CREATE TABLE IF NOT EXISTS Html_Type
(
    Question_Type text COLLATE pg_catalog.default NOT NULL,
    CONSTRAINT Survey_Type_Pk PRIMARY KEY (Question_Type)
);


CREATE TABLE IF NOT EXISTS Survey_Question
(
    Survey_Version integer NOT NULL,
    Question_ID Serial NOT NULL,
    Question_Num integer NOT NULL,
    Question_Text text COLLATE pg_catalog.default NOT NULL,
    Question_Type text COLLATE pg_catalog.default NOT NULL,
    CONSTRAINT Survey_Questions_Pk PRIMARY KEY (Question_ID),
    CONSTRAINT Survey_Questions_Fk FOREIGN KEY (Survey_Version)
        REFERENCES Survey (Survey_Version),
    CONSTRAINT Survey_Questions2_Fk FOREIGN KEY (Question_Type)
        REFERENCES Html_Type (Question_Type)
);


CREATE TABLE IF NOT EXISTS Survey_Prompt
(
    Question_ID integer NOT NULL,
    Prompt_ID Serial NOT NULL,
    Prompt_Num integer NOT NULL,
    Prompt_Text character varying(100) COLLATE pg_catalog.default NOT NULL,
    CONSTRAINT Survey_Prompts_Pk PRIMARY KEY (Prompt_ID),
    CONSTRAINT Survey_Prompts_Fk FOREIGN KEY (Question_ID)
        REFERENCES Survey_Question (Question_ID)
);

CREATE TABLE IF NOT EXISTS Survey_Form
(
    Survey_ID Serial NOT NULL,
    Survey_Version integer NOT NULL,
    Date_Taken date NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT Survey_Form_Pk PRIMARY KEY (Survey_ID, Survey_Version),
    CONSTRAINT Survey_Form_Fk FOREIGN KEY (Survey_Version)
        REFERENCES Survey (Survey_Version)
);

CREATE TABLE IF NOT EXISTS Survey_Response
(
    Survey_Version integer NOT NULL,
    Survey_ID integer NOT NULL,
    Question_ID integer NOT NULL,
    Prompt_ID integer NOT NULL,
    Response_Text text COLLATE pg_catalog.default NOT NULL,
    CONSTRAINT Survey_Response_Pk PRIMARY KEY (Survey_Version, Survey_ID, Question_ID, Prompt_ID),
    CONSTRAINT Survey_Response_Fk1 FOREIGN KEY (Survey_ID, Survey_Version)
        REFERENCES Survey_Form (Survey_ID, Survey_Version),
    CONSTRAINT Survey_Responses_Fk2 FOREIGN KEY (Question_ID)
        REFERENCES Survey_Question (Question_ID),
    CONSTRAINT Survey_Responses_Fk3 FOREIGN KEY (Prompt_ID)
        REFERENCES Survey_Prompt (Prompt_ID)
);

CREATE TABLE IF NOT EXISTS Identification
(
    Survey_ID integer NOT NULL,
    Survey_Version integer NOT NULL,
    Phone_Number numeric,
    Personal_ID Serial NOT NULL,
    First_Name character varying(15) COLLATE pg_catalog.default,
    Last_Name character varying(25) COLLATE pg_catalog.default,
    Email_Address character varying COLLATE pg_catalog.default,
    CONSTRAINT Identification_Pk PRIMARY KEY (Survey_Version, Survey_ID),
    CONSTRAINT Identification_Fk1 FOREIGN KEY (Survey_Version, Survey_ID)
        REFERENCES Survey_Form (Survey_Version, Survey_ID)    
);

