class killconfirmed extends Mutator config(OpenGames);

var() config bool bEnabled;
var() config bool bBlockScoreKill;

replication
{
   reliable if (Role == ROLE_Authority)
      ShowMessage;
}

function PostBeginPlay(){
  Level.Game.BaseMutator.AddMutator (Self);
	Super.PostBeginPlay();
}



simulated function ShowMessage(DeusExPlayer Player, string Message){
  local HUDMissionStartTextDisplay    HUD;
  if ((Player.RootWindow != None) && (DeusExRootWindow(Player.RootWindow).HUD != None))  {
    HUD = DeusExRootWindow(Player.RootWindow).HUD.startDisplay;
  }
  if(HUD != None)  {
    HUD.shadowDist = 0;
	  HUD.setFont(Font'FontMenuSmall_DS');
    HUD.Message = "";
    HUD.charIndex = 0;
    HUD.winText.SetText("");
    HUD.winTextShadow.SetText("");
    HUD.displayTime = 5.50;
    HUD.perCharDelay = 0.20;
    HUD.AddMessage(Message);
    HUD.StartMessage();
  }
}

function ScoreKill(Pawn Killer, Pawn Other){
  local DeusExPlayer dxp, victim;
  local CapturePoint cpt;
  local Vector SpawnLoc;

  if(!bEnabled) return;

  dxp = DeusExPlayer(Killer);
  victim = DeusExPlayer(Other);
  
  if(dxp != None && victim != None && dxp != victim){

    ShowMessage(dxp, "Confirm the kill by taken the symbol from the body!")
    //BroadcastMessage("Both are players!");
    SpawnLoc = victim.location;
    SpawnLoc.Z += 50;
    cpt = Spawn(class'CapturePoint',,,SpawnLoc);

    if(cpt != None){
      cpt.Killer = dxp;
      cpt.Victim = victim;
    }

    if(bBlockScoreKill == True){
      Killer.PlayerReplicationInfo.Score -= 1;
      Victim.PlayerReplicationInfo.Deaths -= 1;
    }
  }
	
  if(bBlockScoreKill == False){
    super.ScoreKill(Killer, Other);
  }  	
}

function ResetScores(){
  local PlayerReplicationInfo PRI;
	foreach allactors(class'PlayerReplicationInfo',PRI)	{
		PRI.Score = 0;
		PRI.Deaths = 0;
		PRI.Streak = 0;
	}
}

function Mutate(string MutateString, PlayerPawn Sender){
  if(MutateString ~= "kc"){
    Sender.ClientMessage("Kill Confirmed (Enabled: "@bEnabled@)
  }

  if(MutateString ~= "kc.debug"){
    bBlockScoreKill = !bBlockScoreKill;
    Sender.ClientMessage(bBlockScoreKill);
    SaveConfig();
  }

  if(MutateString ~= "kc.resetscores"){
    ResetScores();
    BroadcastMessage("Scoreboard reset.");
  }

  if(MutateString ~= "kc.enable"){
    if(bEnabled) return;
    bEnabled = True;
    SaveConfig();
    BroadcastMessage("Kill Confirmed enabled.");
  }

  if(MutateString ~= "kc.disable"){
    if(!bEnabled) return;
    bEnabled = false;
    SaveConfig();
    BroadcastMessage("Kill Confirmed disabled.");
  }

  Super.Mutate(MutateString, Sender);
}


defaultproperties
{
  bBlockScoreKill=True
}
