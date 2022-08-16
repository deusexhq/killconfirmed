class killconfirmed extends Mutator config(OpenGames);

var() config bool bEnabled;

function PostBeginPlay(){
  Level.Game.BaseMutator.AddMutator (Self);
	Super.PostBeginPlay();

  if(bEnabled) DeusExMPGame(Level.Game).bFreezeScores = True;
  
}

function ScoreKill(Pawn Killer, Pawn Other){
  local DeusExPlayer dxp, victim;
  local CapturePoint cpt;
  local Vector SpawnLoc;

  if(bEnabled) {
    dxp = DeusExPlayer(Killer);
    victim = DeusExPlayer(Other);
    
    if(dxp != None && victim != None && dxp != victim){

      dxp.ClientMessage("Confirm the kill by taken the symbol from the body!");

      SpawnLoc = victim.location;
      SpawnLoc.Z += 50;
      cpt = Spawn(class'CapturePoint',,,SpawnLoc);

      if(cpt != None){
        cpt.Killer = dxp;
        cpt.Victim = victim;
      } 
    }
  }

  super.ScoreKill(Killer, Other); 	
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
    Sender.ClientMessage("Kill Confirmed (Enabled: "@bEnabled@")");
  }

  if(MutateString ~= "kc.help"){
    sender.ClientMessage("kc, kc.help, *kc.resetscores, *kc.enable, *kc.disable");
  }

  if(MutateString ~= "kc.resetscores" && DeusExPlayer(Sender).bAdmin){
    ResetScores();
    BroadcastMessage("Scoreboard reset.");
  }

  if(MutateString ~= "kc.enable" && DeusExPlayer(Sender).bAdmin){
    if(bEnabled) return;
    bEnabled = True;
    SaveConfig();
    BroadcastMessage("Kill Confirmed enabled.");
  }

  if(MutateString ~= "kc.disable" && DeusExPlayer(Sender).bAdmin){
    if(!bEnabled) return;
    bEnabled = false;
    SaveConfig();
    BroadcastMessage("Kill Confirmed disabled.");
  }

  Super.Mutate(MutateString, Sender);
}


defaultproperties
{
  bEnabled=True
}
