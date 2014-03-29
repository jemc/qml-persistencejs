
import QtQuick 2.1

import "qml"


Rectangle {
  width:  400
  height: 400
  color: "black"
  
  property var server: PersistenceServer { }
  
  property var persistence: Persistence.js
  
  property var tried: false
  MouseArea { anchors.fill: parent; onClicked: tried ? Qt.quit() : trySync() }
  
  
  function trySync() {
    tried = true
    
    persistence.store.websql.config(
      persistence,
      'yourdbname',
      'A database description',
      5 * 1024 * 1024
    )
    
    var Task = persistence.define("Task", {
      name: "TEXT",
      done: "BOOL"
    })
    
    try {
      Task.enableSync('/taskChanges')
      
      Task.syncAll(
        server.url,
        function() {
          console.log('Conflict!')
        },
        function() {
          console.log('Yep!')
        },
        function(result) {
          console.log('Nope!')
          // console.log(result.responseText)
          // console.log(JSON.stringify(result))
          // console.log(Object.keys(result))
          // console.log(Object.getOwnPropertyNames(result))
          // console.log(result.onreadystatechange(function(result) {
          //   console.log(JSON.stringify(result))
          // }))
        }
      )
    } catch(e) {
      console.error(e.message)
      console.error('')
      console.error(e.stack)
    }
    
    // Qt.quit()
  }
  
  
  function noop() {
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
    )
    
    ///
    // Create a schema
    
    var Task = persistence.define('Task', {
      name: "TEXT",
      description: "TEXT",
      done: "BOOL"
    })
    
    var Category = persistence.define('Category', {
      name: "TEXT",
      metaData: "JSON"
    })
    
    var Tag = persistence.define('Tag', {
      name: "TEXT"
    })
    
    ///
    // Sync the schema to the database
    
    persistence.schemaSync(function(tx) {
      console.log("")
      console.log("Schema was synced.")
      console.log("")
    })
    
    ///
    // Destroy all records under the schema - so that new objects will be alone
    
    persistence.transaction(function(tx) {
      Task    .all().destroyAll(tx)
      Category.all().destroyAll(tx)
      Tag     .all().destroyAll(tx)
    })
    
    ///
    // Create some new objects under the schema
    
    var c = new Category({name: "Main category"})
    persistence.add(c)
    for ( var i = 0; i < 5; i++) {
      var t = new Task()
      t.name = 'Task ' + i
      t.done = i % 2 == 0
      t.category = c
      persistence.add(t)
    }
    
    ///
    // Flush the changes to the database
    
    persistence.transaction(function(tx) {
      persistence.flush(tx, function() {
        console.log("")
        console.log("Done flushing!")
        console.log("")
      })
    })
    
    ///
    // Dump the data as JSON
    
    persistence.transaction(function(tx) {
      persistence.dump(tx, [Task, Category], function(dump) {
        console.log(JSON.stringify(dump, null, '  '))
      })
    })
    
  }
}
