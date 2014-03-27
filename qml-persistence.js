
.pragma library

var window = {};
var persistence = window.persistence = {};

var openDatabaseSync = null // to be redefined within the function


function createDB(storage) {
  openDatabaseSync = storage.openDatabaseSync
  
  Qt.include('persistence.js');
  
  initPersistence(persistence);
  
  Qt.include('persistence.store.sql.js');
  Qt.include('persistence.store.websql.js');
  
  return persistence;
}
