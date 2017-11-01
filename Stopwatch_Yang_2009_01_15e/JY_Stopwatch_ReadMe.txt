Stopwatch
by Justin Yang

Instructions
A large display, networked stopwatch.

There are four text files that are used for programmability and need to be in the root directory of the application.  "pieceDuration.txt" contains the duration of the piece, "swClientIPs.txt" contain the ip address and port numbers of all of the clients (the ports should always be 7777), "markers.txt" which contain up to 19 programmable markers corresponding to keyboard key triggers, and "networkLatency.txt" contains a single float that is the number of milliseconds delay from the master to client. 

"pieceDuration.txt" needs to simply contain one number which is the number of milliseconds in the piece.

"swClientIPs.txt" contains a tab delineated list with:
 ip address <TAB> port number (7777) 
of all the client ips.

There are programmable markers controlled by the keyboard.  Spacebar and '1' takes you to 0:00.  '2'-'0' and 'q'-'p' are programmable markers.  "markers.txt" should contain a list of all the markers in milliseconds.  The markers do not necessarily need to be in chronological order.

"networkLatency.txt" is for client use and should contain the number of milliseconds it takes to send a message from the master to this particular client.  Unless you have ways to measure network latency, the easiest thing would be to adjust this number until master and client sync tightly after a marker cue is given.

'a' on the keyboard is for pause, and 's' is to unpause.

If the end of the piece is reached, you must press '1' or the spacebar to restart the piece before going to a marker.

Programming the 'Kuchen'
Create a tab delineated list of:
startTime(milliseconds) <TAB> endTime <TAB> colorNumber

Color numbers are 0-7:
0-red
1-green
2-blue
3-yellow
4-orange
5-purple
6-pink
7-black

and save as a .txt file named "kuchenTimingColor.txt"

If you do not want kuchen then do not include the .txt file in the directory.