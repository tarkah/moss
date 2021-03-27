/*
 * This file is part of moss.
 *
 * Copyright © 2020-2021 Serpent OS Developers
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

/**
 * The moss.Manager module contains types that make it possible to interact
 * with the package mangling side of things.
 */
module moss.manager;

import moss.db.cache_db;
import serpent.ecs;
import std.stdint : uint16_t, uint64_t;

/**
 * Numerous reasons for why a package was installed
 */
enum SelectionType : uint16_t
{
    Manual = 0,
    AutomaticDependency = 1,
}

/**
 * Assign a State ID component to every package in the state.
 */
@serpentComponent package struct StateIDComponent
{
    uint64_t stateID;
}

/**
 * Each package may be installed automatically or manually,
 * and additionally has a unique identifier
 */
@serpentComponent package struct SelectionComponent
{
    SelectionType type = SelectionType.Manual;
}

/**
 * Every package has a unique ID which must be stored
 */
@serpentComponent package struct PackageIDComponent
{
    string packageID;
}
/**
 * The StateManager class the main entry point to package management operations,
 * allowing us to query and manipulate the state of an installed system.
 */
public final class StateManager
{

public:

    /**
     * Construct a new moss StateManager
     */
    this(const(string) systemRoot = "/")
    {
        _systemRoot = systemRoot;

        _entity = new EntityManager();
        _entity.registerComponent!PackageIDComponent;
        _entity.registerComponent!SelectionComponent;
        _entity.registerComponent!StateIDComponent;
        _entity.build();

        /* TODO: Initialise currentState from disk! */
        _currentState = new State(this, 0);
        _currentState.description = "Automatically generated transaction";
        _currentState.aliasName = "Installation of new system";
        _currentState.type = StateType.Regular;

        cacheDB = new CacheDB(_systemRoot);
    }

    ~this()
    {
        _entity.clear();
    }

    /**
     * Return the current system state
     */
    pure @property State currentState() @safe @nogc nothrow
    {
        return _currentState;
    }

    /**
     * Return the systemRoot for all operations
     */
    pure @property const(string) systemRoot() @safe @nogc nothrow
    {
        return _systemRoot;
    }

private:

    EntityManager _entity;
    State _currentState;
    string _systemRoot = "/";
    CacheDB cacheDB;
}

public import moss.manager.state;