# Twitch Plays MIDI

A simple Processing/java template for collective "music" performances over Twitch.
It creates a chatbot that connects to your Twitch channel and lets users interact with **your** computer through text commands like:

*delay 90 2* - changes the controller labeled "delay" to 90% over the course of 2 seconds
*dropbass* - sends a C2 note

TwitchPlaysMIDI was created for [TwitchPlaysBees](https://vimeo.com/439416461). It controlled two VST filters in Ableton Live. The VST filters windows were on a second display with a green background and overlayed on the stream with a chroma key effect. 

* Requires [Processing](https://processing.org/) a free Java-based environment for creative coding.

* Uses [PircBot](http://www.jibble.org/pircbot.php) an IRC library for java (included in code/)

* Uses [The MidiBus](http://www.smallbutdigital.com/projects/themidibus/) a Processing library (not included)

* Uses [Ani](http://www.looksgood.de/libraries/Ani/) a Processing library that manages eased transitions between values


# Setup

*Traditionally* Twitch-plays games run on dedicated machines that are streaming the output of the game through [OBS](https://obsproject.com/) or other applications. This program listens to Twitch chat messages and interprets them as MIDI input on your computer. A Twitch chat mostly functions like an IRC channel, so your bot can both receive or send text messages. You need some familiarity with MIDI configuration to set this up.

0. Download Processing (from the link above) and the code of TwitchToMIDI (from GitHub/this page)
1. Open the project in Processing making sure that all the files are in a folder named TwitchPlaysMidi (not TwitchPlaysMidi-master).
2. Add your Twitch credentials (channel name, Oauth) to Bot.pde. If "irc.twitch.tv" in Bot.pde doesn't connect try "irc.chat.twitch.tv" (located further down in the code)
3. Install The MidiBus and Ani libraries from Processing with [Add Library...](https://github.com/processing/processing/wiki/How-to-Install-a-Contributed-Library)
4. Set up your virtual MIDI bus/port. On Window you will need a Virtual Midi Cable program like [loopMIDI](https://www.tobias-erichsen.de/software/loopmidi.html) (launch, add port with the +). On Mac you need to follow these [instructions](https://help.ableton.com/hc/en-us/articles/209774225-How-to-setup-a-virtual-MIDI-bus)
5. Run the sketch check the list of MIDI device and replace "loopMIDI Port" in TwitchToMidi.pde with the device you want to use.
Also check if the bot puts the "succesfully connected" message in your stream chat to make sure everything works till now.
6. In TwitchPlaysMidi.pde add your own chat commands and related MIDI controllers in the arraylist "controllers"
* *Trigger*  
  
Code: triggers.add(new Trigger("[CommandName]", "[note]")); 
  
*[CommandName]* - the exact phrase that when put in the chat should trigger the MIDI (you have to add *!* infront of it if you want it to look like a chatbot command)  
*[note]* - the MIDI not you want to be send

*Example:* triggers.add(new Trigger("dropBass", "C4"));  
If **dropBass** is send in chat the MIDI note C4 will be send to your DAW and trigger that note on your current instrument

* *Slider*  
  
Code: controllers.add(new Slider("[CommandName]", [channel], [minValue], [maxValue]));  
  
*[CommandName]* - the exact phrase that when put in the chat should trigger the MIDI (you have to add *!* infront of it if you want it to look like a chatbot command)  
*[channel]* - the coresponding channel for the setup as a number from 0 upwords (see below)  
*[minValue]* - the smalles value this slider should be allowed to be set to between 0-100 (it wont go lower than this value or 0)  
*[maxValue]* - the largest value this slider should be allowed to be set to between 0-100 (it wont go highter than this value or 100)  
  
*Example:* controllers.add(new Slider("!delay", 0, 0, 25));  
If **!delay 20 2** is send in chat the according Slider will be set to a value 20 over the cause of 2 seconds  
If **!delay 30 5** is send in chat the according Slider will be set to a value 25 over the cause of 5 seconds (because of the set maximum value)

7. Set up your music making program (DAW) and map the controls you want to expose to remote MIDI. This configuration depends on the application. Examples: [Ableton Live](https://help.ableton.com/hc/en-us/articles/360000038859-Making-custom-MIDI-Mappings), [FL Studio](https://www.youtube.com/watch?v=MtcZ2_6IG4c)...  
Setting up:  
* *Trigger:*  you can just type the command in chat and it will send the MIDI to your DAW so it can be used for the setup
* *Slider:*  at the top of TwitchToMIDI.pde there is a CONFIGURE variable that, if set true, will send a MIDI signal everytime you click on the window of the running sketch (black window that pops up when you click start). By default this will start with channel 0 and then count up for every click, so you have to keep in mind which effect you assignt to which channel. If you make a mistake, just re-run the sketch and do the steps again.
8. Test the Twitch to MIDI communication first and then the MIDI to DAW communication. You don't have to be live on Twitch to test the chat functionalities, just open your offline channel and type in the chat.
9. Start streaming 
10. ???
11. Profit!


# Notes

* This program doesn't create any music, it only produces MIDI inputs emulating a keyboard or a controller. You will need a MIDI-enabled digital audio workstation like Ableton Live, Garage Band, or FL Studio to turn notes into sound. 

* On Twitch there is a lag of a couple of seconds between video and chat, don't expect users to be in sync or to make meaningful compositions. TwitchPlaysMIDI is probably more appropriate for hybrid performances in which users contribute to a live set, slow ambient pieces, or generative music.

* Twitch hides the channel description at the bottom of the page so users don't generally see the instructions. Consider setting up a stream overlay with some information on how to interact. You can use Processing's graphical capabilities for that.
