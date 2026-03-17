import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Color bg = Color(0xff11151c);
  final Color mg = Color(0xff212d40);
  final Color fg = Color(0xff364156);

  // Stores our tasks
  List tasks = [
    ["task 1", false],
    ["task 2", true],
  ];

  @override
  void initState() {
    super.initState();
    tasks = Hive.box("data").get(
      "tasks",
      defaultValue: [
        ["Task 1", false],
        ["Task 2", false],
      ],
    );
  }

  // input handler
  TextEditingController inputHandler = TextEditingController();

  // checkbox functionality
  void onChange(bool? newValue, int index) {
    setState(() {
      tasks[index][1] = newValue!;
      saveTasks();
    });
  }

  void saveTasks() {
    Hive.box("data").put("tasks", tasks);
  }

  void addTask() {
    // You make it such that it adds a item to the list of strings ith taks
    inputHandler.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add a New Task", style: TextStyle(color: Colors.white)),
          backgroundColor: mg,
          content: TextField(
            controller: inputHandler,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter new task",
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (inputHandler.text != "") {
                    tasks.add([inputHandler.text, false]);
                    saveTasks();
                  }
                });

                Navigator.pop(context);
              },
              child: Text("Add", style: TextStyle(color: Colors.white)),
            ),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void editTask(String task, int index) {
    // You make it such that it adds a item to the list of strings ith taks
    inputHandler.text = task;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Task", style: TextStyle(color: Colors.white)),
          backgroundColor: mg,
          content: TextField(
            controller: inputHandler,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter new task",
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (inputHandler.text != "") {
                    tasks[index][0] = inputHandler.text;
                    saveTasks();
                  }
                });

                Navigator.pop(context);
              },
              child: Text("Save", style: TextStyle(color: Colors.white)),
            ),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Yet Another To Do App")),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        backgroundColor: mg,
        foregroundColor: Colors.white,
        child: Icon(Icons.add, size: 36),
      ),
      body: ListView.builder(
        itemCount: tasks.length,

        itemBuilder: (context, index) => Padding(
          key: ValueKey(tasks[index]),
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: index == tasks.length - 1 ? 15 : 0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: fg,
              borderRadius: BorderRadius.circular(20),
            ),

            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: tasks[index][1],
                    onChanged: (bool? newValue) {
                      onChange(newValue, index);
                    },
                    side: BorderSide(color: Colors.white),
                    fillColor: WidgetStateProperty.resolveWith<Color>((
                      Set<WidgetState> states,
                    ) {
                      return bg;
                    }),
                  ),
                ),
                Padding(padding: EdgeInsetsGeometry.only(left: 10)),
                Expanded(
                  child: Transform.translate(
                    offset: Offset(0, -1),
                    child: GestureDetector(
                      onTap: () => editTask(tasks[index][0], index),
                      child: Text(
                        tasks[index][0],
                        style: TextStyle(
                          color: !tasks[index][1] ? Colors.white : Colors.grey,

                          fontSize: 24,
                          decoration: tasks[index][1]
                              ? TextDecoration.none
                              : TextDecoration.none,
                          decorationColor: Colors.white,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsetsGeometry.only(left: 7.5)),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tasks.removeAt(index);
                      saveTasks();
                    });
                  },
                  child: Icon(Icons.delete, size: 28, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
