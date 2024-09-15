# Part 1: Initial Setup and Skeleton Implementation
---

## Tasks

### Part A: Parents, Children, and Threads

- **A.1. Windows Program Skeleton**
  - [ ] **Design Documentation:** Draft `PartA.design.txt` outlining the 
            approach for creating multiple threads without synchronization.
  - [ ] **Implement Skeleton:**
    - Create `partA1.c` with a basic structure.
    - Parse command-line arguments (`threads`, `deadline`, `size`).
    - Add placeholder functions with print statements, e.g., 
        "Got to procedure CreateThread".
  - [ ] **Parameter Validation:** Ensure the program checks for valid integer 
        inputs and appropriate ranges.
  - [ ] **Initial Testing:** Compile using gcc on Windows to verify no 
        compilation errors.

### Part B: Shell Script

- **Shell Script Skeleton**
  - [ ] **Create `partB.bash`:** Initialize the script with a basic interactive 
        menu structure.
  - [ ] **Check Architecture:** Check to see that the user is on the proper 
        architecture for the program to run.
  - [ ] **Handle User Inputs:** Set up prompts for selecting 
        Parts A.1, A.2, A.3, or A.4.
  - [ ] **Command Execution Placeholders:** Add echo statements to simulate 
        execution, e.g., "Executing Part A.1 with arguments...".
  - [ ] **Input Validation:** Implement checks for three integer inputs per line.
  - [ ] **Testing:** Ensure the script runs without errors and handles invalid 
        inputs gracefully.

### Part C: List Library

- **Library Skeleton**
  - [ ] **Create `list.h`:** Define the `LIST` and `NODE` structures along 
        with function prototypes.
  - [ ] **Source Files Setup:**
    - `list_adders.c`: Placeholder functions for adding elements.
    - `list_movers.c`: Placeholder functions for navigating the list.
    - `list_removers.c`: Placeholder functions for removing elements.
  - [ ] **Implement Function Stubs:**
    - Each function should print "Got to procedure X" upon invocation.
    - Handle parameter validation and print errors if parameters are invalid.
  - [ ] **Create `mytestlist.c`:** Set up a test program that calls each 
        library function to verify the interface.
  - [ ] **Makefile Configuration:**
    - Add rules to compile `liblist.a`.
    - Compile `mytestlist.c` and link against `liblist.a`.
    - Ensure conditional compilation for Windows and Linux.
  - [ ] **Initial Testing:** Compile the library and test program to 
        ensure no compilation errors.

### Part F: Programming Style Guide

- **F.1. Draft Guidelines**
  - [X] Complete the initial version of `332-style-guidelines-team.txt`.

### Final Check

 - [ ] Make sure that all the code compiles on the vm using gcc compiler in Linux/Windows
 - [ ] Did we use Windows to write the code?
    - If so then make sure to remove unwanted characters. 
 - [ ] Create `a1-phase1` directory.
 - [ ] Ensure all relevant files are inside the directory.
 - [ ] Remove any unnecessary files (e.g., `.o`, executables).
 - [ ] Ensure meaningful commit messages. 

---

## Submission Files

- `PartA.design.txt`
- `PartC.design.txt`
- `partA1.c`
- `partB.bash`
- `list.h`
- `list_adders.c`
- `list_movers.c`
- `list_removers.c`
- `mytestlist.c`
- `Makefile`
- `gitlog.txt`
- `332-style-guidelines-team.txt`

---

## Commands

### Compilation

- **Compile Part A.1 (Windows):**
  ```bash
  gcc -std=gnu90 -Wall -pedantic -Wextra -o partA1.exe partA1.c -lpthread
  ```
