# Open project

## What is this?

Just a simple CLI program to open your projects in VSCode!

`PS: Made for personal convinience of opening projects >_<`

## Setup Instructions

If you are amazed by this and want to test this program, you can run it by

- Building

```bash
dart compile exe bin/open_project.dart -o bin/opro.exe
```

- Add its folder to system environment variables.

  - windows: <a href="https://stackoverflow.com/questions/44272416/add-a-folder-to-the-path-environment-variable-in-windows-10-with-screenshots">stack overflow thread on it</a>

  - linux (bash):

  ```bash
  nano ~/.bashrc
  export PATH=$PATH:<path_of_bin/opro.exe> # add this at the end
  source ~/.bashrc
  ```

- Run the command:

```bash
opro help
```

This will list out every command.

You should add a project path to open it with vscode.

```bash
opro add <project_nickname> <project_path>
```

And to open that project, just run:

```bash
opro <project_nickname>
```

For further help, run

```bash
opro help <command_name>
```

LICENSE

This project is licensed under MIT
