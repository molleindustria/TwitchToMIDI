
public class Bot extends PircBot {

  //change these strings
  String channel = "#yourChannel"; //must match your channel name

  //an oauth token looks like oauth:1l33afoi4tvlulkky1eile0ki59d52 
  //This is NOT the streaming code
  //if you trust this 3rd party site you can get it here:
  //https://twitchapps.com/tmi/
  String twitchOauth = "your auth";

  String name = "botname";

  public Bot() {
    
    this.setName(name);

    // Enable debugging output.
    setVerbose(true);

    try {
      // Connect to the IRC server.
      //connect("irc.foonetic.net");
      connect("irc.twitch.tv", 6667, twitchOauth);
    }
    catch (Exception e) {
      println(e.getMessage());
    }

    // Join the #pircbot channel.
    joinChannel(channel);
    //not sure it's necessary
    this.sendRawLine("CAP REQ :twitch.tv/membership");
  }


  public void onMessage(String channel, String sender, String login, String hostname, String message) {
    
    parseCommand(message);
    
    //send message to the whole channel
    //sendMessage(channel,"Welcome "+login+"!");
    
    //send PM
    //sendRawLineViaQueue("PRIVMSG #jtv :/w "+sender+" psst, secret");
  }
}
