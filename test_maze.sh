#!/bin/bash

gcc maze.c -o maze

# Check if the maze file path parameter is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <maze file directory>"
    exit 1
fi

maze_dir="$1"

# Test 1: Valid maze loading
test_1_valid_maze_loading() {
    valid_maze="$maze_dir/valid_maze.txt"
    if [ ! -f "$valid_maze" ]; then
        echo "Error: Valid maze file does not exist: $valid_maze"
        return
    fi
    result=$(./maze "$valid_maze" 2>&1)
    if [[ $result != *"Maze loaded successfully"* ]]; then
        echo "Error: Failed to load the valid maze"
    else
        echo "Test 1 passed: Valid maze loaded successfully"
    fi
}

# Test 2: Invalid file path
test_2_invalid_file_path() {
    invalid_maze="$maze_dir/nonexistent.txt"
    result=$(./maze "$invalid_maze" 2>&1)
    if [[ $result != *"Unable to load the maze file"* ]]; then
        echo "Error: Invalid file path was not handled correctly"
    else
        echo "Test 2 passed: Invalid file path handled correctly"
    fi
}

# Test 3: Maze too small
test_3_maze_too_small() {
    small_maze="$maze_dir/small_maze.txt"
    if [ ! -f "$small_maze" ]; then
        echo "Error: The maze file with too small size does not exist: $small_maze"
        return
    fi
    result=$(./maze "$small_maze" 2>&1)
    if [[ $result != *"The maze size does not meet the requirements"* ]]; then
        echo "Error: The maze with too small size was not handled correctly"
    else
        echo "Test 3 passed: The maze with too small size handled correctly"
    fi
}

# Test 4: Maze too large
test_4_maze_too_large() {
    large_maze="$maze_dir/large_maze.txt"
    if [ ! -f "$large_maze" ]; then
        echo "Error: The maze file with too large size does not exist: $large_maze"
        return
    fi
    result=$(./maze "$large_maze" 2>&1)
    if [[ $result != *"The maze size does not meet the requirements"* ]]; then
        echo "Error: The maze with too large size was not handled correctly"
    else
        echo "Test 4 passed: The maze with too large size handled correctly"
    fi
}

# Test 5: No start position
test_5_no_start_position() {
    no_start_maze="$maze_dir/no_start.txt"
    if [ ! -f "$no_start_maze" ]; then
        echo "Error: The maze file without a start position does not exist: $no_start_maze"
        return
    fi
    result=$(./maze "$no_start_maze" 2>&1) 
    if [[ $result != *"The maze must contain a start position"* ]]; then
        echo "Error: The maze without a start position was not handled correctly"
    else
        echo "Test 5 passed: The maze without a start position handled correctly"
    fi
}

# Test 6: No exit position
test_6_no_exit_position() {
    no_exit_maze="$maze_dir/no_exit.txt"
    if [ ! -f "$no_exit_maze" ]; then
        echo "Error: The maze file without an exit position does not exist: $no_exit_maze"
        return
    fi
    result=$(./maze "$no_exit_maze" 2>&1)
    if [[ $result != *"The maze must contain an exit position"* ]]; then
        echo "Error: The maze without an exit position was not handled correctly"
    else
        echo "Test 6 passed: The maze without an exit position handled correctly"
    fi
}

# Test 7: Valid movement
test_7_valid_movement() {
    valid_maze="$maze_dir/valid_maze.txt"
    if [ ! -f "$valid_maze" ]; then
        echo "Error: Valid maze file does not exist: $valid_maze"
        return
    fi
    result=$(echo -e "d\nm\nq\n" |./maze "$valid_maze" 2>&1)
    if [[ $result != *"X"* ]]; then
        echo "Error: The map was not displayed correctly for valid movement"
    else
        echo "Test 7 passed: The map was displayed correctly for valid movement"
    fi
}

# Test 8: Wall collision
test_8_wall_collision() {
    valid_maze="$maze_dir/valid_maze.txt"
    if [ ! -f "$valid_maze" ]; then
        echo "Error: Valid maze file does not exist: $valid_maze"
        return
    fi
    result=$(echo -e "a\nq\n" |./maze "$valid_maze" 2>&1)
    if [[ $result != *"Cannot move"* ]]; then
        echo "Error: Wall collision was not handled correctly"
    else
        echo "Test 8 passed: Wall collision handled correctly"
    fi
}

# Test 9: Win condition
test_9_win_condition() {
    simple_win_maze="$maze_dir/simple_win.txt"
    if [ ! -f "$simple_win_maze" ]; then
        echo "Error: The simple win maze file does not exist: $simple_win_maze"
        return
    fi
    result=$(echo -e "d\nd\nd\n" |./maze "$simple_win_maze" 2>&1)
    if [[ $result != *"Congratulations! You have reached the exit"* ]]; then
        echo "Error: The win condition was not triggered correctly"
    else
        echo "Test 9 passed: The win condition was triggered correctly"
    fi
}

# Test 10: Invalid input
test_10_invalid_input() {
    valid_maze="$maze_dir/valid_maze.txt"
    if [ ! -f "$valid_maze" ]; then
        echo "Error: Valid maze file does not exist: $valid_maze"
        return
    fi
    result=$(echo -e "z\nq\n" |./maze "$valid_maze" 2>&1)
    if [[ $result != *"Invalid command"* ]]; then
        echo "Error: Invalid input was not handled correctly"
    else
        echo "Test 10 passed: Invalid input handled correctly"
    fi
}

# Test 11: Check if the maze is rectangular
test_11_maze_is_rectangular() {
    rectangular_maze="$maze_dir/rectangular_maze.txt"
    if [ ! -f "$rectangular_maze" ]; then
        echo "Error: Rectangular maze file does not exist: $rectangular_maze"
        return
    fi
    first_line_length=$(head -n 1 "$rectangular_maze" | wc -c)
    while IFS= read -r line; do
        current_length=${#line}
        if [ "$current_length" -ne "$first_line_length" ]; then
            echo "Error: The maze is not rectangular"
            return
        fi
    done < "$rectangular_maze"
    echo "Test 11 passed: The maze is rectangular"
}

# Execute each test function in sequence
test_1_valid_maze_loading
test_2_invalid_file_path
test_3_maze_too_small
test_4_maze_too_large
test_5_no_start_position
test_6_no_exit_position
test_7_valid_movement
test_8_wall_collision
test_9_win_condition
test_10_invalid_input
test_11_maze_is_rectangular
    