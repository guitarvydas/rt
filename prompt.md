Write HTML code for the following GUI.
A tagbox is a 1-line text input box.
A kvbox is a 5-line readonly textarea with a tagbox directly above it.
The GUI consists of 3 rows.
The first row contains 4 kvboxes. Their input boxes are initialized with text "Common Lisp", "Python", "Javascript" and "WASM", respectively.
The second row contains one kvbox with its input box initialized to text "Errors".
The third row contains three kvboxes with input box text "A", "B" and "C", respectively.
The GUI connects to one websocket called "to_gui", on "ws://localhost:8765".
When a message arrives on the websocket, all of the textareas of all kvboxes are first cleared.
Messages arriving on the websocket, are in JSON format containing key-value pairs, where keys are strings and values are strings.
For each pair in the message, if a key matches the text in a tagbox, then the value text of the corresponding readonly text area is set to the value contained in the pair.

---
---
---

Write a Python program called 'coreographer.py' that watches all of the files named in 'watch.txt' every 0.02 seconds. 
Coreographer creates and serves a websocket called "to_gui" on "ws://localhost:8765".
If any of the watched files has changed, choreographer spawns a subprocess that invokes the shell script 'rebuild.bash'. 
If 'rebuild.bash' exits with any error code, coreographer sends the error code and stderr captured from rebuild.bash into the websocket "ws://localhost:8765" as a json string with the key "Errors".
If 'rebuild.bash' exits with a success error code, all of contents of files named in 'send.txt' are collected together into a single JSON object and sent to the 'to_gui' socket.  
The format of 'send.txt' is lines of text. Each line consist of two items separated by one of more spaces. The first of each pair is a JSON object key, the second of the pair is the name of a file whose contents are to be associated with the key. The contents of the files need to be encoded so that they can be easily decoded as strings by Javascript in the receiving browser.

