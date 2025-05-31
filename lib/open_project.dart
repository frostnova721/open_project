import 'dart:convert';
import 'dart:io';

const String configFile = "./op_pro_config.json";

const List<String> commands = ['list', 'add', 'remove', 'help'];
void run(List<String> args) async {
  if (args.isEmpty) return print("Arguments not provided.");

  final config = await loadMap();

  final folderPath = config[args[0]];
  if (folderPath == null) {
    final hasCmd = hasCommand(args[0]);
    if (!hasCmd)
      return print("Couldnt find folder path assigned with the identifier ${args[0]}.");
    else
      return executeCommand(args[0], args, config);
  }
  await Process.run("code", [folderPath], runInShell: true);
  exit(0);
}

Future<Map<String, String>> loadMap() async {
  File jsonFile = File(configFile);
  if (!(await jsonFile.exists())) {
    await jsonFile.writeAsString("{}");
    return {};
  } else {
    final contents = await jsonFile.readAsString();
    final Map<String, String> jsoned = Map.castFrom(jsonDecode(contents));
    return jsoned;
  }
}

bool hasCommand(String command) {
  return commands.contains(command);
}

void executeCommand(String command, List<String> args, Map<String, String> folderMap) {
  return switch (command) {
    "list" => listProjects(folderMap),
    "add" => addProject(args, folderMap),
    "help" => printHelp(args),
    "remove" => removeProject(args, folderMap),
    _ => print("unknown command $command")
  };
}

void removeProject(List<String> args, Map<String, String> folderMap) async {
  try {
    if (args.length < 2) return print("Identifier is missing");
    final identifier = args[1];
    folderMap.remove(identifier);
    final file = File(configFile);
    await file.writeAsString(jsonEncode(folderMap));
    return print("Removed $identifier from the projects");
  } catch (err) {
    return print("Failed to remove an entry from the projects.");
  }
}

void printHelp(List<String> args) {
  if (args.length < 2) {
    return print("Usage guide / Help!\n"
        "commands:\n"
        "list\tLists all projects set up in config.\n"
        "add\tAdd a new project to the config.\n"
        "help\tShow this help.");
  } else {
    final cmd = args[1];
    return switch (cmd) {
      "list" => print("List all the projects you've set up."),
      "add" => print("adds a new project to the config\n"
          "Usage: add <identifier> <project_path>"),
      "remove" => print("removes a project from the config\n" "Usage: remove <identifier>"),
      _ => print("unknown command $cmd"),
    };
  }
}

void addProject(List<String> args, Map<String, String> folderMap) async {
  try {
    final file = File(configFile);
    if (args.length < 3) print("identifier or project directory is missing.");
    final identifier = args[1];
    final projectDir = args[2];
    if (await Directory(projectDir).exists()) {
      folderMap[identifier] = projectDir;
      await file.writeAsString(jsonEncode(folderMap));
      print("Added $identifier to projects");
    } else {
      return print("Provided directory $projectDir doesnt exist!");
    }
  } catch (err) {
    print("Couldn't add an entry to projects");
    print(err);
  }
}

void listProjects(Map<String, String> folderMap) {
  final entries = folderMap.entries;
  print("\nIdentifier\tPath");
  for (final item in entries) {
    print("${item.key}\t${item.value}");
  }

  print("\nFound total of ${entries.length} projects.");
}
