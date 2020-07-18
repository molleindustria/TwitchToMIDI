import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import themidibus.*;
import java.util.*; 
import java.util.HashMap;

//the chat bot
Bot bot;

MidiBus myBus; // The MidiBus

/*
 In Ableton Live I need to send a MIDI input to create a binding
 if CONFIGURE is set to true at every mouse click it will modify a controller 
 starting from 0 and increasing every time
 My process is: 
 set Live to MIDI mapping mode, select a knob, click on the processing app
 then hardcode the controllers names/sliders in the right position
 */
boolean CONFIGURE = false;
int controllerIndex = 0;

//duration in seconds
int MAX_TWEEN = 60;
int channel = 1;

//default values for notes
int VELOCITY = 127; //whatever that is
int DURATION = 200; //ms

ArrayList<Slider> controllers;
ArrayList<Trigger> triggers;


void setup() {
  size(400, 400);
  background(0);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.

  //                 Parent  In        Out
  //                   |     |          |
  myBus = new MidiBus(this, "loopMIDI Port", "loopMIDI Port"); 
  // Create a new MidiBus. Replace "Bus 1" with the name of the device in the list obtained above

  //Ani takes care of the transitions http://www.looksgood.de/libraries/Ani/
  Ani.init(this);

  //populate the ArrayList
  controllers = new ArrayList<Slider>();
  triggers = new ArrayList<Trigger>();

  /*
  MIDI controllers, it's a list of Slider objects taking care of the value changes and labeling
   
   controllers.add(new Slider("rate", 0, 10, 100));
   
   "rate" is the command to be typed in the chat
   0 is the corresponding controller number
   10 is the minimum value allowed 0-100
   100 is the minimum value allowed 0-100
   */

  controllers.add(new Slider("rate", 0, 10, 100));

  //if min and max are not specified the default is 0 100
  controllers.add(new Slider("depth", 1));
  controllers.add(new Slider("wave", 2));
  controllers.add(new Slider("dry/wet", 3));
  controllers.add(new Slider("volume", 4));

  /*
  Triggers are just commands associated to a note and a duration (optional)
   */
  triggers.add(new Trigger("dropBass", "C4"));

  bot = new Bot();
}


void draw() {

  //check all the controllers
  for (int i = 0; i < controllers.size(); i++) {

    Slider s = controllers.get(i);

    //if slider is sliding
    if (abs(s.value - s.target) > 1 &&  s.target != -1) {
      //println( s.id + ": " + s.value +" -> "+s.target);
      myBus.sendControllerChange(channel, s.cc, s.value); // Send a controllerChange
    } else if (s.target != -1) {
      //end point
      s.value = s.target;
      myBus.sendControllerChange(channel, s.cc, s.value); // Send a controllerChange
    }
  }
}


void parseCommand(String cmd) {
  //attempt to parse a command from the chat

  String[] c = split(cmd, ' ');

  //go through all the controller ids

  println("Parsing message "+c[0]+"...");

  /*
  //you can let users send notes directly but it's probably a bad idea
   int pitch = noteToPitch(c[0]);
   //valid note
   if (pitch != -1) {
   println("Send note "+ pitch);
   myBus.sendNoteOn(channel, pitch, VELOCITY); // Send a Midi noteOn
   delay(DURATION);
   myBus.sendNoteOff(channel, pitch, VELOCITY); // Send a Midi nodeOff
   } 
   */


  //check all the triggers
  for (int i = 0; i < triggers.size(); i++) {
    Trigger t = triggers.get(i);
    //this is the command!
    if (cmd.toUpperCase().equals(t.id.toUpperCase())) {
      t.go();
    }
  }

  if (c.length >= 2) {
    //check all the controllers
    for (int i = 0; i < controllers.size(); i++) {
      Slider s = controllers.get(i);
      String id = s.id.toLowerCase();

      //first member is the same as controller id
      if (id.equals(c[0].toLowerCase())) {
        //key matches let's see if the other members are valid

        int valuePercent = int(c[1]);
        valuePercent = constrain(valuePercent, s.min, s.max);
        int MIDIvalue = int(map(valuePercent, 0, 100, 0, 127));

        //default value 1 sec
        int time = 1;

        if (c.length >= 3) {
          time = int(c[2]);
          time = constrain(time, 0, MAX_TWEEN);
        }

        println("Command detected "+id+" - MIDI value "+MIDIvalue+" - time (s) "+time);

        s.target = MIDIvalue;

        //triggers the gradual transition with Ani
        //you can add a fifth parameter to determine the easing eg Ani.LINEAR
        //http://www.looksgood.de/libraries/Ani/
        Ani.to(s, time, "value", MIDIvalue);
      }//controlle
    }//controller loop
  }//two members
}

void mousePressed() {
  if (CONFIGURE) {
    println("Sending input of controller: "+controllerIndex);
    myBus.sendControllerChange(channel, controllerIndex, round(random(0, 127)));
    controllerIndex++;
  }
}


//https://www.midimountain.com/midi/midi_note_numbers.html
//position is number to multiply by octave
//yeah there's is no flat mapping
String[] NOTES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};

int noteToPitch (String p) {

  p = p.toUpperCase();

  int pitch = -1;
  int note = -1;
  int octave = 0;

  if (p.length() == 2 || p.length() == 3) {
    String noteString = "";

    if (p.length() == 2) {
      noteString = p.substring(0, 1); 
      octave = Character.getNumericValue(p.charAt(1));
    }
    if (p.length() == 3) {
      noteString = p.substring(0, 2);
      octave = Character.getNumericValue(p.charAt(2));
    }

    for (int i=0; i<NOTES.length; i++) {
      if (noteString.equals(NOTES[i]))
        note = i;
    }

    if (note != -1) {
      pitch = note + octave*12;
    }
  }

  return pitch;
}


void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}


//associates a command to a midi note 
class Trigger {
  String id = "";
  int pitch = 0;
  int duration = DURATION;

  Trigger(String _id, String note) {
    this.pitch = noteToPitch(note);
    this.id = _id;
  }

  Trigger(String _id, String note, int _d) {
    this.pitch = noteToPitch(note);
    this.id = _id;
    this.duration = _d;
  }

  //trigger the not
  void go() {
    myBus.sendNoteOn(channel, this.pitch, VELOCITY); // Send a Midi noteOn
    delay(this.duration);
    myBus.sendNoteOff(channel, this.pitch, VELOCITY); // Send a Midi nodeOff
  }
}

//slider class
class Slider {
  String id = "";
  int cc = 0; //controller value
  int value = 0;
  int target = -1; //target never set
  int min = 0;
  int max = 100;

  Slider(String _id, int _cc) {
    this.cc = _cc;
    this.id = _id;
  }

  Slider(String _id, int _cc, int _min, int _max) {
    this.cc = _cc;
    this.id = _id;
    this.min = _min;
    this.max = _max;
  }
}
