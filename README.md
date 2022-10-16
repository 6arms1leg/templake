<!--
Keywords:
make, makefile, build, build-process, embedded, embedded-systems, template,
framework
-->

# Templake - Simple template for GNU Make

This set of Makefiles provide a (almost) simple

*GNU Make build process template*

to support software development, deployment and continuous integration,
tailored to the C programming language in a GNU/Linux environment.

## Requirements specification

The following loosely lists requirements, constraints, features and goals.

* GNU Make build process template that supports software development,
  deployment and continuous integration in a GNU/Linux environment
* Make targets to build, test, check and document software
* Configurable build/test/check/documentation tool chain
* Comfortable software module selection via include and exclude file/directory
  lists with support for extra header directory path inclusion
* Configurable build artifact paths
* Complex builds are managed via variation points provided as variables to the
  Make command
* Sanity check of variation points provided as variables to the Make command
* Correct dependency graph handling for incremental builds
* Well-formatted and informational help screen
* Executable using an example "dummy" implementation/header C (and assembly)
  file tree in the code base
* Generate checksums for each final build artifact file
* Logging of each Make target console output
* Cleanup functionality
* Support of "ToDo" notes (find and count)
* Support for generating checksums for each code base file

<!-- Separator -->

* Template design
* (Very) Suitable for embedded systems
* Tailored to the C (and assembly) programming language
* Interfaces with the code base by only depending on standard/core GNU/Linux
  tools, normally shipped with each GNU/Linux distribution
* Every build target (and every shell pipeline command) returns a non-zero exit
  code on failure for use in continuous integration systems

<!-- Separator -->

* Quality model
    * "Simple" (low complexity, essential features only)
    * Modular
    * Re-usable
    * Portable (between GNU/Linux distributions and toolchains)
    * Scalable from simple and small to complex and large projects with
      multiple build targets for different SW/HW configurations
    * Extensible (in features and also to other programming languages)
    * SCM via Git with [Semantic Versioning](https://semver.org)
* Well documented (from requirements over key features to usage), using
  Markdown

## How to deploy

Due to the individual setups and configurations of different code bases, this
project cannot be simply pulled in as a Git submodule but must be "dropped"
(i.e. copied and pasted) into each project’s code base and then customized.
To use this template, only the main Makefile (`Makefile`) and the sub-Makefiles
(`make/*.mk`; included by the main Makefile) must be copied to the project for
which the build process is being developed.
Then, each Make target and the respective variables must be adapted to the
individual build process needs of the project.  
The required modifications are either obvious or explained within the Makefiles
comments and can be generally summarized as:

* Multi-line deletions of helper shell commands to demonstrate the template
  functionality with the provided example "dummy" code base (indicated by
  explicit comments within the Makefile)
* Multi-line deletions of unwanted Make targets and features
* Replacement of provided example "dummy" tool chain commands with real ones
* Replacement of provided example "dummy" code base file/directory paths with
  real ones

This project comes with a fully executable build process for the provided
example "dummy" code base.
The easiest way to get acquainted with the build process template is to
actually run it:

```sh
$ make # Or `make help`
```

This lists available Make targets and build type variation points (that might
be required by some targets).  
This then "makes" a target:

```sh
$ make TARGET
```

Some targets may require a build type variation point:

```sh
$ make TARGET t=BUILD_TYPE
```

### Help message

To add a Make target to the help screen (shown with `make help`), a description
is simply appended (`+=`) to the already existing `HELP` variable.
The first word should be the Make target name itself, directly followed by a
tilde (`~`).
After the tilde a brief desription can be given but words must be separated by
an underscore (`_`) instead of a space.  
Example:

```make
# Cleanup all
HELP += clean-all~Clean_up_all_targets
.PHONY: clean-all
clean-all:
# [...]
```

### "ToDo" notes (inline comments)

Sometimes it can be useful to add "ToDo" comments in the code base to revisit
them later and contiue focusing on the current task.
However, such comments should not find their way into the release branch, let
alone be deployed/shipped.  
To mitigate that risk the Make template provides a `find-todo` target that
finds and counts all "ToDo" comments with a configurable marker (default is
`TODO:`).
The count report supports the identification of the effort/progress to resolve
all "ToDo" comments.
If any "ToDo" comments are present in the code base, the Make target returns
with a non-zero exit code to promote its usage in continuous integration
systems.

## Architecture

The main Makefile (`Makefile`) includes sub-Makefiles from a sub-directory
(`make/*.mk`).
The sub-Makefiles are divided into typical build process and continuous
integration pipeline "stages", coarsely guiding the development workflow of
"build -> test -> check -> document".

## Coding standard - style conventions

The style is only loosely defined:

New added code should use the same style (i.e. "look similar") as the already
existing code base.

## Workflow

This project uses a simple topic branch Git workflow.
The only permanently existing branches are "develop" (development status;
unstable) and "master" (release status; stable).
New development efforts are done in separate topic branches, which are then
merged into develop once ready.
For releases, the "develop" branch is then merged into "master".
Fast-forward merges are preferred, if possible.
