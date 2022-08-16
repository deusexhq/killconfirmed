# Kill Confirmed mutator

## Install
Drop the files (KillConfirmed.u, OpenGames.ini) in your servers /System folder.

Open your server config file (Usually DeusEx.ini), and find the DeusEx.DeusExGameEngine block.
At the bottom, add the following;
```
ServerPackages=KillConfirmed
ServerActors=KillConfirmed.KillConfirmed
```

## Setup
No setup needed, this mutator is plug-n-play.

## Gameplay
Normal scoring is disabled. Killed players drop a symbol at their corpse. Run over the symbols of your victims to confirm your kill. If someone else takes the symbol, they steal your points.