Class CapturePoint extends DeusExDecoration;
var DeusExPlayer Killer, Victim;
var bool bTaken;
var float aliveTime;

function Tick(float deltatime){
	local DeusExPlayer P, winP;
	local vector dist;
	local float lowestDist;

    //Foolproofing to make sure it never triggers twice.
    if(bTaken) return;

    super.Tick(deltatime);

    aliveTime += deltatime;

    // Give it a little cooldown after spawning before it can be taken
    // Preventing any weird timing hickups with the victim being able to confirm themselves as they die.
    if(aliveTime <= 1.0) return;

    // Find nearest player if multiple are close-by.
	lowestDist = 1024;

	foreach VisibleActors(class'DeusExPlayer', P, 50){
		if(P != None && !P.IsInState('Dying') && P.Health > 0){
			if(vSize(P.Location - Location) < lowestDist){
				winP = P;
				lowestDist = vSize(P.Location - Location);
			}
		}
	}

    // We have a winner, give it to them.
	if(winP != None)
		Capture(winp);
	
}

function Capture(DeusExPlayer winner){
    bTaken = True;
    if(winner == victim){
        BroadcastMessage(GetName(winner)@"has denied their death by "@GetName(killer)@".");
        winner.PlayerReplicationInfo.Score += 1;
        return
    }

    if(winner == killer){
        BroadcastMessage(GetName(winner)@"has confirmed their kill of "@GetName(victim)@".");
        victim.PlayerReplicationInfo.Deaths += 1;
        winner.PlayerReplicationInfo.Score += 5;
        return
    }

    if(Level.Game.bTeamGame){
        if(winner.PlayerReplicationInfo.Team == victim.PlayerReplicationInfo.Team){
            BroadcastMessage(GetName(winner)@"has confirmed their teammate ("@GetName(Killer)@")'s kill of "@GetName(victim)@".");
            victim.PlayerReplicationInfo.Deaths += 1;
            winner.PlayerReplicationInfo.Score += 1;
        } else {
            BroadcastMessage(GetName(winner)@"has denied their teammate ("@GetName(victim)@")'s death by "@GetName(killer)@".");
            victim.PlayerReplicationInfo.Score += 1;
            winner.PlayerReplicationInfo.Score += 1;
        }
    } else {
        BroadcastMessage(GetName(winner)@"has stolen "@GetName(killer)@"'s kill of "@GetName(victim)@".");
        victim.PlayerReplicationInfo.Deaths += 1;
        winner.PlayerReplicationInfo.Score += 1;
    }
    Destroy();
}

function GetName(DeusExPlayer p){return p.PlayerReplicationInfo.PlayerName;}

defaultproperties
{
     bInvincible=True
     HitPoints=100
     ItemName="Confirm Kill"
     bPushable=False
     bHighlight=False
     LightBrightness=100
     Physics=PHYS_Rotating
     Lighttype=LT_Steady
     LightRadius=10
     Ambientglow=255
     LightSaturation=255
	 Drawscale=0.50
	 Fatness=140
	 style=sty_translucent
	 bBlockPlayers=False
	 DrawType=DT_Mesh
	 Mesh=Mesh'DXLogo'
     CollisionRadius=5.000000
     CollisionHeight=8.000000
     bFixedRotationDir=True
     RotationRate=(Yaw=8192)
}
