# so_long Tester

A comprehensive, automated bash testing suite for the 42 School **so_long** project.  

It thoroughly validates error-handling robustness, CLI arguments, `.ber` map parsing rules, window initialization, and memory management.


---

##  Key Features

* **Dynamic Memory Leak Detection:** Integrates directly with Valgrind (`--leak-check=full`) to instantly flag memory leaks (`[MKO]`) or verify clean exits (`[MOK]`).
* **Segmentation Fault Safety:** Monitors the game's termination signals, warning you explicitly with a red `[KO] SEGFAULT` if the executable crashes.
* **Extensive Edge-Case Coverage:** Over 70 built-in test routines validating bad file extensions, missing permissions, invalid map boundaries, duplicate characters, missing targets, and broken paths.
* **Interactive Map Validation:** Instantly boots valid maps, verifies that your graphical window successfully initializes (using MLX), and safely terminates the process after `0.35 seconds` to keep the testing loop fluid.
  

<div align="center">
    <br>
    <a href="https://github.com/tdanielsousa/42_School/blob/main/Subjects/solong_subject.pdf" target="_blank">
        <img src="https://img.shields.io/badge/View%20Subject-PDF-red?style=for-the-badge&logo=adobe-acrobat-reader&logoColor=white" alt="Subject PDF" height="40">
    </a>
    <p><i>Click on the button above to see the subject's pdf.</i></p>

</div>

---

##  Automated Test Coverage

The script systematically tests your binary against the following scenarios:

| Test Category | Covered Scenarios | Expected Output |
|---|---|---|
| **Argument Checks** | Zero arguments, excess arguments | `"Wrong number of arguments"` |
| **System & Permissions** | Missing maps, unreadable maps (`chmod 000`) | `"No exist map"`, `"Permission denied"` |
| **File Extensions** | `.txt`, `.ber.txt`, `.bber`, hidden `.ber` files | `"Bad extension"` |
| **Map Geometry** | Non-rectangular maps, uneven line lengths | `"No rectangular"` |
| **Entity Counts** | Missing players, exits, or collectible items | `"No player"`, `"No exit"`, `"No object"` |
| **Duplicates** | Multiple starting positions, multiple exits | `"Duplicate player"`, `"Duplicate exit"` |
| **Pathfinding** | Unreachable collectibles or exits (flood-fill check) | `"No valid road"` |
| **Wall Boundaries** | Maps not completely enclosed by walls | `"Not surrounded by walls"` |
| **Characters** | Invalid characters within the map matrix | `"Wrong characters"` |
| **Valid Runs** | Correct `.ber` configurations | Program launches and runs successfully |

---

## Installation & Usage

### 1. Prerequisites
Make sure your compiled binary (`so_long`) and your testing script are in the same working directory.  
Additionally, you must have `valgrind` installed on your system.

### 2. Setup Directory Structure
Your maps directory should contain your test configurations matching the paths in the tester script:

    .
    ├── so_long              # Your compiled game executable
    ├── tester.sh            # This testing script
    └── maps/
        ├── ok.ber           # Valid map configurations
        ├── wrong_chars.ber  # Invalid map configurations
        └── ...

### 3. Run the Tester
Make the script executable and run it:

    chmod +x tester.sh
    ./tester.sh

---

##  Output Interpretations

The script uses clear visual cues to pinpoint exactly where your project succeeds or requires attention:

* **`[MOK]` / `[MKO]`**: Valgrind status. **MOK** indicates zero memory leaks; **MKO** indicates memory was lost during execution.
* **`[OK]`**: The program reacted correctly (e.g., printed `Error` followed by an explicit description on invalid inputs, or booted properly on valid inputs).
* **`[KO] SEGFAULT`**: The game crashed during the parsing or initialization sequence.
* **`[KO] Missing explicit error message`**: The program printed `Error` but failed to display a descriptive error explanation on the second line.

---


