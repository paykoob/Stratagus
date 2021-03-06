//       _________ __                 __
//      /   _____//  |_____________ _/  |______     ____  __ __  ______
//      \_____  \\   __\_  __ \__  \\   __\__  \   / ___\|  |  \/  ___/
//      /        \|  |  |  | \// __ \|  |  / __ \_/ /_/  >  |  /\___ |
//     /_______  /|__|  |__|  (____  /__| (____  /\___  /|____//____  >
//             \/                  \/          \//_____/            \/
//  ______________________                           ______________________
//                        T H E   W A R   B E G I N S
//         Stratagus - A free fantasy real time strategy game engine
//
/**@name pathfinder.h - The path finder headerfile. */
//
//      (c) Copyright 1998-2005 by Lutz Sammer, Russell Smith
//
//      This program is free software; you can redistribute it and/or modify
//      it under the terms of the GNU General Public License as published by
//      the Free Software Foundation; only version 2 of the License.
//
//      This program is distributed in the hope that it will be useful,
//      but WITHOUT ANY WARRANTY; without even the implied warranty of
//      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//      GNU General Public License for more details.
//
//      You should have received a copy of the GNU General Public License
//      along with this program; if not, write to the Free Software
//      Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
//      02111-1307, USA.
//
//      $Id$

#ifndef __PATH_FINDER_H__
#define __PATH_FINDER_H__

//@{

#ifndef STDCALL
#ifdef _MSC_VER
#define STDCALL __stdcall
#else
#define STDCALL
#endif
#endif

#if defined(DEBUG_ASTAR)
#define AstarDebugPrint(x) DebugPrint(x)
#else
#define AstarDebugPrint(x)
#endif

/*----------------------------------------------------------------------------
--  Declarations
----------------------------------------------------------------------------*/

class CUnit;

/**
**  Result codes of the pathfinder.
**
**  @todo
**    Another idea is SINT_MAX as reached, SINT_MIN as unreachable
**    stop others how far to goal.
*/
enum _move_return_ {
	PF_FAILED = -3,       /// This Pathfinder failed, try another
	PF_UNREACHABLE = -2,  /// Unreachable stop
	PF_REACHED = -1,      /// Reached goal stop
	PF_WAIT = 0,          /// Wait, no time or blocked
	PF_MOVE = 1           /// On the way moving
};

/**
**  To remove pathfinder internals. Called if path destination changed.
*/
#define NewResetPath(unit) \
	do { (unit).Data.Move.Fast = 1; (unit).Data.Move.Length = 0; } while (0)

/*----------------------------------------------------------------------------
--  Variables
----------------------------------------------------------------------------*/

	/// cost associated to move on a tile occupied by a fixed unit
extern int AStarFixedUnitCrossingCost;
	/// cost associated to move on a tile occupied by a moving unit
extern int AStarMovingUnitCrossingCost;
	/// Whether to have knowledge of terrain that we haven't visited yet
extern bool AStarKnowUnseenTerrain;
	/// Cost of using a square we haven't seen before.
extern int AStarUnknownTerrainCost;

//
//  Convert heading into direction.
//  N NE  E SE  S SW  W NW
extern const int Heading2X[9];
extern const int Heading2Y[9];
extern const int XY2Heading[3][3];

/*----------------------------------------------------------------------------
--  Functions
----------------------------------------------------------------------------*/

	/// Init the pathfinder
extern void InitPathfinder();
	/// Free the pathfinder
extern void FreePathfinder();

	/// Create a matrix for the old pathfinder
extern unsigned char *CreateMatrix(void);
	/// Allocate a new matrix and initialize
extern unsigned char *MakeMatrix(void);
	/// Get next element of the way to goal.
extern int NewPath(CUnit &unit);
	/// Returns the next element of the path
extern int NextPathElement(CUnit &unit, short int *xdp, short int *ydp);
	/// Return distance to unit.
extern int UnitReachable(const CUnit &unit, const CUnit &dst, int range);
	/// Can the unit 'src' reach the place x,y
extern int PlaceReachable(const CUnit &src, int x, int y, int w, int h,
	int minrange, int maxrange);

//
// in astar.cpp
//

extern void SetAStarFixedUnitCrossingCost(int cost);
extern int GetAStarFixedUnitCrossingCost();

extern void SetAStarMovingUnitCrossingCost(int cost);
extern int GetAStarMovingUnitCrossingCost();

extern void SetAStarUnknownTerrainCost(int cost);
extern int GetAStarUnknownTerrainCost();

extern void PathfinderCclRegister(void);

//@}

#endif // !__PATH_FINDER_H__
