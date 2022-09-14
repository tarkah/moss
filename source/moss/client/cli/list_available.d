/*
 * SPDX-FileCopyrightText: Copyright © 2020-2022 Serpent OS Developers
 *
 * SPDX-License-Identifier: Zlib
 */

/**
 * moss.client.cli.list_available
 *
 * List available packages
 *
 * Authors: Copyright © 2020-2022 Serpent OS Developers
 * License: Zlib
 */

module moss.client.cli.list_available;

public import moss.core.cli;

import moss.client.cli : initialiseClient;
import moss.client.cli.list : DisplayItem, printItem;
import moss.client.ui;
import moss.client.remoteplugin;
import moss.deps.registry;
import std.array : array;
import std.algorithm : each, filter, map ,maxElement, sort, SwapStrategy;
import std.format;
import std.range : empty;

/**
 * List the available packages
 */
@CommandName("available") @CommandAlias("la") @CommandHelp(
        "List available packages", "TODO: Improve docs") struct ListAvailableCommand
{
    BaseCommand pt;
    alias pt this;

    @CommandEntry() int run(ref string[] argv) @safe
    {
        auto cl = initialiseClient(pt);
        scope (exit)
        {
            cl.close();
        }
        DisplayItem[] di = () @trusted {
            return cl.registry.list(ItemFlags.Available).filter!((i) {
                /* no collection id specified, list all available packages */
                if (collectionID is null)
                {
                    return true;
                }
                auto altCandidates = cl.registry.byID(i.pkgID).filter!((rp) {
                    auto r = cast(RemotePlugin) rp.plugin;
                    if (r !is null && r.remoteConfig.id == collectionID)
                    {
                        return true;
                    }
                    return false;
                });
                return !altCandidates.empty;
            })
                .map!((i) {
                    auto info = i.info();
                    return DisplayItem(info.name, info.summary,
                        format!"%s-%s"(info.versionID, info.releaseNumber));
                })
                .array();
        }();
        if (di.empty)
        {
            return 0;
        }
        di.sort!((a, b) => a.name < b.name);
        immutable largestName = di.maxElement!"a.name.length".name.length;
        immutable largestVersion = di.maxElement!"a.versionID.length".versionID.length;
        di.each!((d) => printItem(largestName + largestVersion, d));
        return 0;
    }

    /**
     * Collection ID to filter by
     */
    @Option("c", "collection", "Filter results by collection ID")
    string collectionID;
}
