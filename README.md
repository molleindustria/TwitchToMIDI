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

1. Add your Twitch credentials to Bot.pde.
2. Install The MidiBus and Ani libraries from Processing with [Add Library...](https://github.com/processing/processing/wiki/How-to-Install-a-Contributed-Library)
3. Set up your virtual MIDI bus/port. On Window you will need a Virtual Midi Cable program like [loopMIDI](https://www.tobias-erichsen.de/software/loopmidi.html) (launch, add port with the +). On Mac you need to follow these [instructions](https://help.ableton.com/hc/en-us/articles/209774225-How-to-setup-a-virtual-MIDI-bus)
4. Run the sketch check the list of MIDI device and replace "loopMIDI Port" in TwitchToMidi.pde with the device you want to use.
5. Set up your music making program (DAW) and map the controls you want to expose to remote MIDI. This configuration depends on the application. Examples: [Ableton Live](https://help.ableton.com/hc/en-us/articles/360000038859-Making-custom-MIDI-Mappings), [FL Studio](https://www.youtube.com/watch?v=MtcZ2_6IG4c)...
6. In TwitchPlaysMidi.pde add your own chat commands and related MIDI controllers in the arraylist "controllers"
7. Test the Twitch to MIDI communication first and then the MIDI to DAW communication. You don't have to be live on Twitch to test the chat functionalities, just open your offline channel and type in the chat.
8. Start streaming 
9. ???
10. Profit!


# Notes

* This program doesn't create any music, it only produces MIDI inputs emulating a keyboard or a controller. You will need a MIDI-enabled digital audio workstation like Ableton Live, Garage Band, or FL Studio to turn notes into sound. 

* On Twitch there is a lag of a couple of seconds between video and chat, don't expect users to be in sync or to make meaningful compositions. TwitchPlaysMIDI is probably more appropriate for hybrid performances in which users contribute to a live set, slow ambient pieces, or generative music.

* Twitch hides the channel description at the bottom of the page so users don't generally see the instructions. Consider setting up a stream overlay with some information on how to interact. You can use Processing's graphical capabilities for that.
