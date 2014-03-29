
import QtQuick 2.1

import org.jemc.qml.Sockets 1.0

import "."


TCPServer {
  port: 8888
  
  property var url: 'http://127.0.0.1:%1/test'.arg(port)
  
  property var persistence: Persistence.js
  
  property var someEntity
  
  function setup() {
    persistence.store.websql.config(
      persistence,
      'yourdbname-server',
      'A database description (server)',
      5 * 1024 * 1024
    )
    
    persistence.sync.server.config(persistence)
    
    var Task = persistence.define("Task", {
      name: "TEXT",
      done: "BOOL"
    })
    
    
    Task.enableSync('/taskChanges')
    console.log('WHUP', Task.meta.fields['_lastChange'])
    
    persistence.schemaSync(function(tx) {
      console.log("")
      console.log("Schema was synced.")
      console.log("")
    })
    
    someEntity = Task
    
    listen()
    console.log('listening...')
  }
  
  function makeJSON(path) {
    persistence.transaction(function(tx) {
      var obj = persistence.sync.server.pushUpdates(persistence, tx, someEntity, 0, function(result) {
        console.log("result:", result, arguments)
      })
    })
    return '{"anything":true}'
  }
  
  onClientRead: {
    console.log('heyo', client)
    
    var firstLine = message.split('\n')[0].split(' ')
    var type = firstLine[0]
    var path = firstLine[1]
    
    if(type === "GET") {
      client.write("HTTP/1.1 200 OK\r\n\r\n%1\r\n".arg(makeJSON(path)))
      client.disconnect()
    }
    else {
      console.error("Don't know how to handle type: "+type)
      client.disconnect()
    }
  }
  
  Component.onCompleted: setup()
}
