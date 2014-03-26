
import QtQuick 2.1

import "./qml-persistence.js" 1.0 as Persistence


Rectangle {
  width:  400
  height: 400
  color: "black"
  
  property var persistence: Persistence.initPersistence({})
  
  Component.onCompleted: {
    console.log(Object.keys(persistence))
  }
}
