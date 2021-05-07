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

module moss.client.direct;

import serpent.ecs;
import moss.context;
import std.exception : enforce;
import std.file : exists;

import moss.db.state.meta;

public import moss.client : MossClient;

/**
 * The direct implementation for MossClient
 *
 * This (default) implementation works directly on the local filesystems
 * and has no broker mechanism
 */
public final class DirectMossClient : MossClient
{

    /**
     * Construct a new Direct moss client
     */
    this() @trusted
    {
        entityManager = new EntityManager();

        enforce(context.paths.root !is null, "context.paths.root() is null!");
        enforce(context.paths.root.exists, "context.paths.root() does not exist!");

        /* Ensure we can manipulate the DBs */
        stateMetaDB = new StateMetaDB(entityManager);

        /* Bake and step our DBs */
        entityManager.build();
        entityManager.step();
    }

    override void installLocalArchives(string[] archivePaths)
    {
        import std.stdio : writefln;

        foreach (p; archivePaths)
        {
            writefln("Failed to install: %s", p);
        }
    }

private:

    EntityManager entityManager = null;
    StateMetaDB stateMetaDB = null;
}