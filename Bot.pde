
public class Bot extends PircBot {

  //to config the bot change the following strings within the quotation marks:
  
  //this must match your channel name
  String channelName = "yourChannel";

  //get your Oauth token here (this is a 3rd party site, so it's up to you if you trust them):
  //https://twitchapps.com/tmi/
  //an oauth token looks like oauth:1l33afoi4tvlulkky1eile0ki59d52
  //This is NOT the streaming code
  String twitchOauth = "your Oauth";

  //set to false if you don't want to see the 'Successfully connected!' message in your channels chat
  //you have to have you channel page/chat open when you start the bot to see the message
  String joinMessage = "true";
  
  //-----End of config ------------------------------------------------------------------------------------------------------------------------------------
  
  
  String name = channelName.toLowerCase();
  
  String channel = '#' + channelName.toLowerCase();

  public Bot() {
    
    this.setName(name);

    // Enable debugging output.
    setVerbose(true);

    try {
      // Connect to the IRC server.
      connect("irc.twitch.tv", 6667, twitchOauth);
      //switch to this address if the above one doesn't work 
      //connect("irc.chat.twitch.tv", 6667, twitchOauth); 
    }
    catch (Exception e) {
      println(e.getMessage());
    }

    // Join the twitch channel.
    joinChannel(channel);
    //not sure it's necessary
    //EDIT: might be necassary according to this https://dev.twitch.tv/docs/irc/membership
    this.sendRawLine("CAP REQ :twitch.tv/membership");
  }


  public void onMessage(String channel, String sender, String login, String hostname, String message) {
    
    parseCommand(message);
    
    //sends a welcome message everytime a person is talking in chat
    //sendMessage(channel,"Welcome "+login+"!");
  }
  
  Integer nx = 0;
  
  public void onJoin(String channel, String sender, String login, String hostname) {
        
    if (nx == 0 && joinMessage == "true") {
      sendMessage(channel, "Successfully connected!");
      nx = nx + 1;
    }
  }
}
