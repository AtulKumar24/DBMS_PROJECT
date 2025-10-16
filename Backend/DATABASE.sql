-- Active: 1753246698389@@127.0.0.1@3306
CREATE DATABASE DBMS_PROJECT;
USE DBMS_PROJECT;

CREATE TABLE Policyholders(
policyholder_id INT primary key,
name VARCHAR(100) NOT NULL,
dob DATE NOT NULL,
contact bigint
);
CREATE TABLE Policy(
policy_id INT primary key,
policyholder_id INT,
premium DECIMAL(10,2),
policy_type varchar(100),
Foreign key (policyholder_id) references Policyholders(policyholder_id)
);
CREATE TABLE Claims (
    claim_id INT PRIMARY KEY,
    policy_id INT,
    claim_date DATE,
    claim_amount DECIMAL(10,2),
    status VARCHAR(20),
    FOREIGN KEY (policy_id) REFERENCES Policies(policy_id)
);
CREATE TABLE Agents (
    agent_id INT PRIMARY KEY,
    agent_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15)
);


