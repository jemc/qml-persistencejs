
.pragma library
.import QtQuick.LocalStorage 2.0 as QQLS

///
// Setup shims to have compatibility with standard JS environments

var window = {};
var persistence = window.persistence = {};

var openDatabaseSync = QQLS.LocalStorage.openDatabaseSync;

///
// Import and initialize

function includeCallback(result) {
  if(result.status == 3) {
    console.error(result.exception.message);
    console.error('');
    console.error(result.exception.stack);
  }
}

Qt.include('vendor/persistence.js',              includeCallback);

initPersistence(persistence);

Qt.include('vendor/persistence.store.sql.js',    includeCallback);
Qt.include('vendor/persistence.store.websql.js', includeCallback);

Qt.include('vendor/persistence.sync.js',         includeCallback);

var require = function() { return {}; };
var exports = persistence.sync.server = {};
Qt.include('vendor/persistence.sync.server.js',  includeCallback);
var require = undefined;
var exports = undefined;

///
// This property holds the toplevel persistence object 

var js = persistence;
