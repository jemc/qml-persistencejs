
import QtQuick 2.1
import QtQuick.LocalStorage 2.0

import "./qml-persistence.js" 1.0 as Persistence


Rectangle {
  width:  400
  height: 400
  color: "black"
  
  property var persistence: Persistence.createDB(LocalStorage)
  
  Component.onCompleted: {
    ///
    // Example code from persistence.js README
    // (https://github.com/zefhemel/persistencejs)
    
    ///
    // Setup the WebSQL database
    
    persistence.store.websql.config(
      persistence,
      'yourdbname',
      'A database description',
      5 * 1024 * 1024
    );
    
    ///
    // Create a schema
    
    var Task = persistence.define('Task', {
      name: "TEXT",
      description: "TEXT",
      done: "BOOL"
    });
    
    var Category = persistence.define('Category', {
      name: "TEXT",
      metaData: "JSON"
    });
    
    var Tag = persistence.define('Tag', {
      name: "TEXT"
    });
    
    ///
    // Sync the schema to the database
    
    persistence.schemaSync(function(tx) {
      console.log("")
      console.log("Schema was synced.")
    });
  }
}
