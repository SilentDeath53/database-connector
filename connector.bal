import ballerina/config;
import ballerina/database;
import ballerina/io;
import ballerina/log;

endpoint database:Client dbClient {
    url: config:getAsString("DB_URL"),
    username: config:getAsString("DB_USERNAME"),
    password: config:getAsString("DB_PASSWORD"),
    dbOptions: { };
};

function executeQuery(string query) returns table | error {
    var result = dbClient->select(query);
    match result {
        table dataTable => return dataTable;
        error err => return err;
    }
}

function insertData(string name, int age) {
    var insertQuery = "INSERT INTO users (name, age) VALUES ('" + name + "', " + age.toString() + ")";
    var result = dbClient->update(insertQuery);
    if (result is error) {
        log:printError("Error inserting data: ", result);
    } else {
        io:println("Data inserted successfully!");
    }
}

function getData() {
    var selectQuery = "SELECT * FROM users";
    var result = executeQuery(selectQuery);
    if (result is table) {
        io:println("User Data:");
        io:println("---------------------");
        table dataTable = result;
        foreach row in dataTable {
            io:println(row.name + "\t" + row.age.toString());
        }
    } else {
        log:printError("Error retrieving data: ", result);
    }
}
