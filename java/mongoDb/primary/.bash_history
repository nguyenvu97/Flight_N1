rs.initiate({
  _id: "rs0",
  version: 1,
  members: [
    { _id: 0, host: "mongoMaster:27017" },;     { _id: 1, host: "mongoSecondary:27017" };   ]; })
ls -l
rs.status
rs.status() rs.initiate({
  _id: "rs0",
  version: 1,
  members: [
    { _id: 0, host: "mongoMaster:27017" },;     { _id: 1, host: "mongoSecondary:27017" };   ]; })
exit
mongo
var config = {}
var config = {
  "_id": "rs0",
  "version": 1,
  "members": [
    {       "_id": 0,;       "host": "mongoMaster:27017";     },;     {       "_id": 1,;       "host": "mongoSecondary:27017";     };   ]; };
rs.initiate(config);
mongo -u root -p 
exit
mongo -u root - p 
mongo -u root -p example --authenticationDatabase Vu123456
exrt
exit
db
show db
exit
