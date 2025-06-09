{
  "rules": {
    ".read": false,
    ".write": false,

    "nodes": {
      "$roomId": {
        ".read": "auth != null",  // Cualquier usuario autenticado puede leer la sala

        // Solo se permite escribir si el usuario está autenticado y es parte de la sala
        ".write": "auth != null && (
          !data.exists() ||  // Permite crear la sala
          data.child('players').hasChild(auth.uid)  // O si ya es jugador de la sala
        )",

        "createdAt": {
          ".validate": "newData.isNumber()"
        },

        "show": {
          ".validate": "newData.isBoolean()"
        },
          
        "impostor": {
          ".validate": "newData.isString()" 
        },          
          
        "currentQuestion": {
          "id": {
              ".validate": "newData.isNumber()"
            },
            "originalQuestion": {
              ".validate": "newData.isString()  && newData.val().length <= 300"
            },
            "impostorQuestion": {
              ".validate": "newData.isString() && newData.val().length <= 300"
        		},
        },
          

        "players": {
          "$uid": {
            ".read": "auth != null",
            ".write": "!data.exists() || (auth != null && root.child('nodes').child($roomId).child('players').hasChild(auth.uid))",

            "name": {
              ".validate": "newData.isString() && newData.val().length <= 20"
            },
            "isHost": {
              ".validate": "newData.isBoolean()"  // No evitar que se modifique, pero sí que sea booleano
            },
            "answer": {
              ".validate": "newData.isString() && newData.val().length <= 150"
            },
            "vote": {
              ".validate": "newData.isString() && newData.val().length <= 150" 
            }
          }
        },
      }
    }
  }
}
