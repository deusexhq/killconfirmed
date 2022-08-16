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
    HUD.perCharDelay = 0.30;
    HUD.AddMessage(Message);
    HUD.StartMessage();
  }
}

function ScoreKill(Pawn Killer, Pawn Other){
  local DeusExPlayer dxp, victim;
  local CapturePoint cpt;
  local Vector SpawnLoc;
  dxp = DeusExPlayer(Killer);
  victim = DeusExPlayer(Other);
  //BroadcastMessage("Scorekilled");
  if(dxp != None && victim != None && dxp != victim){
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
  } else 
  	
}


function PrintToAll(string Str){
  local DeusExPlayer DXP;
  foreach allActors(class'DeusExPlayer',DXP){
    DXP.ClientMessage(str, 'Say');
  }
}

function PrintToPlayer(DeusExPlayer dxp, string Message){
    if (dxp != none) dxp.ClientMessage(Message,'TeamSay');
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

  if(MutateString == "dbg"){
    bBlockScoreKill = !bBlockScoreKill;
    Sender.ClientMessage(bBlockScoreKill);
    SaveConfig();
  }

  Super.Mutate(MutateString, Sender);
}


defaultproperties
{
  bBlockScoreKill=True
}
