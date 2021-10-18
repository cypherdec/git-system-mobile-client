class Client { //client class

  int clientID;
  String firstName;
  String lastName;
  String tele;
  String email;
  String password;
  String gender;
  DateTime dob;
  String coach;

  Client(this.clientID, this.firstName, this.lastName, this.gender, this.tele, this.dob, this.email, this.password, this.coach );
}

Client toClient(var row){  //converts data from sql query to client object
  Client client =  new Client(
      row[0],
      row[1],
      row[2],
      row[3],
      row[4],
      row[5],
      row[6],
      row[7],
      row[8]
  );

  return client;
}