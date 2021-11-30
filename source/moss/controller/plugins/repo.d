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

module moss.controller.plugins.repo;

public import moss.deps.registry;

/**
 * The repo plugin encapsulates access to online software repositories providing
 * the means to search for software , and install a full chain of met dependencies.
 */
public final class RepoPlugin : RegistryPlugin
{

    /**
     * Construct a new RepoPlugin
     */
    this()
    {
    }

    /**
     * Return any matching providers
     */
    override RegistryItem[] queryProviders(in ProviderType type, in string matcher,
            ItemFlags flags = ItemFlags.None)
    {
        return null;
    }

    /**
     * Provide details on a singular package
     */
    override NullableRegistryItem queryID(in string pkgID) const
    {
        return NullableRegistryItem();
    }

    /**
     * Return the dependencies for the given pkgID
     */
    override const(Dependency)[] dependencies(in string pkgID) const
    {
        return null;
    }

    /**
     * Return the providers for the given pkgID
     */
    override const(Provider)[] providers(in string pkgID) const
    {
        return null;
    }

    /**
     * TODO: Support getting info for the package
     */
    override ItemInfo info(in string pkgID) const
    {
        return ItemInfo();
    }

    /**
     * TODO: Support listing items in this plugin
     */
    override const(RegistryItem)[] list(in ItemFlags flags) const
    {
        return null;
    }
}