# CivPatched

This project is a series of patches for Civ plugins intended as a means to
learn about patching and the viability of doing so with actively developed
upstreams. But it's also an attempt to avoid the [threat of catastrophic rewrite](https://github.com/CivMC/FactoryMod/pull/27#issuecomment-1228870335)
given that this project and its patches naturally inherit [Bukkit's GPLv3](https://github.com/Bukkit/Bukkit/commit/6255d1794c4995b65dbd3db8b857a7d356266c5e)
licence.

## Prerequisites

1. Install Java 17: `https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/downloads-list.html`

2. Install git: `https://git-scm.com/downloads`

    * You'll need to set your global user details:

        * `git config --global user.name "<your name>"`

        * `git config --global user.email "<a non-person email>"`

3. Install just: `https://github.com/casey/just#installation`

## Development

1. Clone this repository: `git clone --recursive https://github.com/Protonull/CivPatched.git`

2. Run `just applyPatches` in a terminal.

3. Open a submodule project in your preferred IDE.

4. Commit your changes within that project's submodule repo.

5. Run `just generatePatches` in a terminal.

6. Commit those patches within to CivPatched!

## KEEP IN MIND

Your commits to the respective project submodule will cause it to appear
modified within CivPatched's git tracking. Do **NOT** commit that. You'd be
updating that project's submodule to a ghost-commit that only exists after
the patches have been applied. Don't discard the change either as that will
wholly reset the project submodule back to its cloned-commit. Just ignore it.

## Patching

Patches to existing code ought to be kept as minimal and distinct as possible,
for example:

- Single-line changes should be suffixed with a comment, like so:
    ```java
    public static final String SOME_STATIC_VALUE = "Hello, World!"; // CivPatched: This is needed for some purpose.
    ```

- Otherwise, multi-line changes should be comment-wrapped, like so:
    ```java
    // CivPatched Start: Add some method for some reason
    public boolean someMethod() {
        return true;
    }
    // CivPatched End
    ```

- Where possible and not redundant, these comments should be given a short
  explanation.

- Avoid impacting imports, try using fully-qualified names instead, like so:
    ```java
    final String name = vg.civcraft.mc.namelayer.NameAPI.getCurrentName(playerUUID);
    ```

## Contribution

Contributions to this project will likewise be licensed under [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html).
