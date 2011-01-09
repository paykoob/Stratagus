--
-- unit-zerg-hatchery
--


DefineAnimations("animations-zerg-hatchery", {
  Still = {
    "frame 1", "wait 2", "frame 2", "wait 2", "frame 3", "wait 4",
    "frame 2", "wait 2", "frame 1", "wait 2", "frame 0", "wait 4",
  },
  Train = {
    "frame 0", "wait 125",
  },
})


DefineUnitType("unit-zerg-hatchery", { Name = "Zerg Hatchery",
  Image = {"file", "zerg/units/hatchery.png", "size", {192, 160}},
  Shadow = {"file", "zerg/units/hatchery shadow.png", "size", {192, 160}},
  Animations = "animations-zerg-hatchery", Icon = "icon-zerg-hatchery",
  Costs = {"time", 255, "minerals", 300},
  RepairHp = 4,
  RepairCosts = {"minerals", 1, "gas", 0},
  Construction = "construction-zerg",
  Speed = 0,
  HitPoints = 1500,
  DrawLevel = 30,
  TileSize = {4, 3}, BoxSize = {126, 95},
  SightRange = 1,
  Armor = 20, BasicDamage = 0, PiercingDamage = 0, Missile = "missile-none",
  Priority = 35, AnnoyComputerFactor = 45,
  Points = 200,
  Supply = 8,
  RegenerationRate = 1,
--  ExplodeWhenKilled = "missle-zerg-rubble-large",
  Type = "land",
--  Corpse = "unit-zerg-rubble-large",
  BuilderLost = true,
  Building = true, VisibleUnderFog = true, 
  BuildingRules = { { "distance", { Distance = 3, DistanceType = ">", Type = "unit-minerals1"} } },
  CanStore = {"gas", "minerals"},
  Sounds = {
    "selected", "zerg-hatchery-selected",
--    "ready", "town-hall-ready",
    "ready", "zerg-building-ready",
    "help", "zerg-base-attacked",
    "dead", "zerg-building-blowup"} } )


DefineUnitType("unit-zerg-lair", {})
DefineUnitType("unit-zerg-hive", {})
CUpgrade:New("upgrade-zerg-burrow")
CUpgrade:New("upgrade-zerg-ventral-sacs")
CUpgrade:New("upgrade-zerg-antennae")
CUpgrade:New("upgrade-zerg-pneumatized-carapace")

DefineButton( { Pos = 1, Level = 0, Icon = "icon-zerg-larva",
  Action = "button", Value = 1,
  Key = "s", Hint = "~!Select Larva",
  ForUnit = {"unit-zerg-hatchery", "unit-zerg-lair", "unit-zerg-hive"} } )

DefineButton( { Pos = 2, Level = 0, Icon = "icon-rally-point",
  Action = "move",
  Key = "r", Hint = "Set ~!Rally Point",
  ForUnit = {"unit-zerg-hatchery", "unit-zerg-lair", "unit-zerg-hive"} } )

DefineButton( { Pos = 3, Level = 0, Icon = "icon-zerg-burrow-down",
  Allowed = "check-single-research",
  Action = "research", Value = "upgrade-zerg-burrow",
  Key = "b", Hint = "Evolve ~!Burrow",
  ForUnit = {"unit-zerg-hatchery", "unit-zerg-lair", "unit-zerg-hive"} } )

DefineButton( { Pos = 7, Level = 0, Icon = "icon-zerg-lair",
  Action = "upgrade-to", Value = "unit-zerg-lair",
  Key = "l", Hint = "Mutate into ~!Lair",
  ForUnit = {"unit-zerg-hatchery"} } )

DefineButton( { Pos = 7, Level = 0, Icon = "icon-zerg-hive",
  Action = "upgrade-to", Value = "unit-zerg-hive",
  Key = "h", Hint = "Mutate into ~!Hive",
  ForUnit = {"unit-zerg-lair"} } )

DefineButton( { Pos = 4, Level = 0, Icon = "icon-zerg-ventral-sacs",
  Allowed = "check-single-research",
  Action = "research", Value = "upgrade-zerg-ventral-sacs",
  Key = "v", Hint = "Evolve ~!Ventral Sacs",
  ForUnit = {"unit-zerg-lair", "unit-zerg-hive"} } )

DefineButton( { Pos = 5, Level = 0, Icon = "icon-zerg-antennae",
  Allowed = "check-single-research",
  Action = "research", Value = "upgrade-zerg-antennae",
  Key = "a", Hint = "Evolve ~!Antennae",
  ForUnit = {"unit-zerg-lair", "unit-zerg-hive"} } )

DefineButton( { Pos = 6, Level = 0, Icon = "icon-zerg-pneumatized-carapace",
  Allowed = "check-single-research",
  Action = "research", Value = "upgrade-zerg-pneumatized-carapace",
  Key = "p", Hint = "Evolve ~!Pneumatized Carapace",
  ForUnit = {"unit-zerg-lair", "unit-zerg-hive"} } )

-- larva

DefineUnitType("unit-zerg-drone", {})
DefineUnitType("unit-zerg-zergling", {})
DefineUnitType("unit-zerg-hydralisk", {})
DefineUnitType("unit-zerg-ultralisk", {})
DefineUnitType("unit-zerg-overlord", {})
DefineUnitType("unit-zerg-queen", {})
DefineUnitType("unit-zerg-defiler", {})
DefineUnitType("unit-zerg-mutalisk", {})

DefineButton( { Pos = 1, Level = 1, Icon = "icon-zerg-drone",
  Action = "train-unit", Value = "unit-zerg-drone",
  Key = "d", Hint = "Build Drone",
  ForUnit = {"unit-zerg-hatchery", "unit-zerg-lair", "unit-zerg-hive"} } )

DefineButton( { Pos = 2, Level = 1, Icon = "icon-zerg-zergling",
  Action = "train-unit", Value = "unit-zerg-zergling",
  Key = "z", Hint = "Zergling",
  ForUnit = {"unit-zerg-hatchery", "unit-zerg-lair", "unit-zerg-hive"} } )

DefineButton( { Pos = 3, Level = 1, Icon = "icon-zerg-hydralisk",
  Action = "train-unit", Value = "unit-zerg-hydralisk",
  Key = "h", Hint = "Hydralisk",
  ForUnit = {"unit-zerg-hatchery", "unit-zerg-lair", "unit-zerg-hive"} } )
  
DefineButton( { Pos = 4, Level = 1, Icon = "icon-zerg-ultralisk",
  Action = "train-unit", Value = "unit-zerg-ultralisk",
  Key = "u", Hint = "Ultralisk",
  ForUnit = {"unit-zerg-hatchery", "unit-zerg-lair", "unit-zerg-hive"} } )
  
DefineButton( { Pos = 5, Level = 1, Icon = "icon-zerg-overlord",
  Action = "train-unit", Value = "unit-zerg-overlord",
  Key = "o", Hint = "Overlord",
  ForUnit = {"unit-zerg-hatchery", "unit-zerg-lair", "unit-zerg-hive"} } )

DefineButton( { Pos = 7, Level = 1, Icon = "icon-zerg-mutalisk",
  Action = "train-unit", Value = "unit-zerg-mutalisk",
  Key = "m", Hint = "Mutalisk",
  ForUnit = {"unit-zerg-hatchery", "unit-zerg-lair", "unit-zerg-hive"} } )

DefineButton( { Pos = 8, Level = 1, Icon = "icon-zerg-queen",
  Action = "train-unit", Value = "unit-zerg-queen",
  Key = "q", Hint = "Queen",
  ForUnit = {"unit-zerg-hatchery", "unit-zerg-lair", "unit-zerg-hive"} } )

DefineButton( { Pos = 9, Level = 1, Icon = "icon-zerg-defiler",
  Action = "train-unit", Value = "unit-zerg-defiler",
  Key = "d", Hint = "Defiler",
  ForUnit = {"unit-zerg-hatchery", "unit-zerg-lair", "unit-zerg-hive"} } )

