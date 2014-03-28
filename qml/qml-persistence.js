
.pragma library
.import QtQuick.LocalStorage 2.0 as QQLS

///
// Setup shims to have compatibility with standard JS environments

var window = {};
var persistence = window.persistence = {};

var openDatabaseSync = QQLS.LocalStorage.openDatabaseSync

///
// Import and initialize

Qt.include('vendor/persistence.js');

initPersistence(persistence);

Qt.include('vendor/persistence.store.sql.js');
Qt.include('vendor/persistence.store.websql.js');

///
// This property holds the toplevel persistence object 

var js = persistence
