#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h> 

#define MAX_WIDTH 100
#define MAX_HEIGHT 100

// Maze structure
typedef struct {
    char grid[MAX_HEIGHT][MAX_WIDTH];
    int width;
    int height;
    int player_row;
    int player_col;
    int exit_row;
    int exit_col;
} Maze;

// Load the maze from a file
bool load_from_file(Maze *maze, const char *filename) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        fprintf(stderr, "Error: Unable to find the file %s\n", filename);
        return false;
    }

    int row = 0;
    while (fgets(maze->grid[row], MAX_WIDTH, file) != NULL) {
        maze->grid[row][strcspn(maze->grid[row], "\n")] = '\0';
        if (row == 0) {
            maze->width = strlen(maze->grid[row]);
        } else if (strlen(maze->grid[row]) != maze->width) {
            fclose(file);
            fprintf(stderr, "Error: The maze is not rectangular\n");
            return false;
        }
        row++;
    }
    maze->height = row;

    if (maze->height == 0) {
        fclose(file);
        return false;
    }

    // Find the starting point and the exit
    for (int i = 0; i < maze->height; i++) {
        for (int j = 0; j < maze->width; j++) {
            if (maze->grid[i][j] == 'S') {
                maze->player_row = i;
                maze->player_col = j;
            } else if (maze->grid[i][j] == 'E') {
                maze->exit_row = i;
                maze->exit_col = j;
            }
        }
    }

    fclose(file);
    return true;
}

// Verify if the maze is valid
bool is_valid(const Maze *maze) {
    if (maze->width < 5 || maze->width > 100 ||
        maze->height < 5 || maze->height > 100) {
        fprintf(stderr, "Error: The maze size must be between 5x5 and 100x100\n");
        return false;
    }

    if (maze->player_row == -1 || maze->player_col == -1) {
        fprintf(stderr, "Error: The maze must contain a starting point (S)\n");
        return false;
    }

    if (maze->exit_row == -1 || maze->exit_col == -1) {
        fprintf(stderr, "Error: The maze must contain an exit point (E)\n");
        return false;
    }

    return true;
}

// Display the maze
void display(const Maze *maze, bool show_player) {
    for (int i = 0; i < maze->height; i++) {
        for (int j = 0; j < maze->width; j++) {
            if (show_player && i == maze->player_row && j == maze->player_col) {
                printf("X");
            } else {
                printf("%c", maze->grid[i][j]);
            }
        }
        printf("\n");
    }
}

// Move the player
bool move_player(Maze *maze, char direction) {
    int new_row = maze->player_row;
    int new_col = maze->player_col;

    switch (direction) {
        case 'w':
            new_row -= 1;
            break;
        case 's':
            new_row += 1;
            break;
        case 'a':
            new_col -= 1;
            break;
        case 'd':
            new_col += 1;
            break;
        default:
            return false;
    }

    if (new_row >= 0 && new_row < maze->height &&
        new_col >= 0 && new_col < maze->width &&
        maze->grid[new_row][new_col] != '#') {
        maze->player_row = new_row;
        maze->player_col = new_col;

        if (maze->player_row == maze->exit_row && maze->player_col == maze->exit_col) {
            return true;
        }
    } else {
        printf("Cannot move to this position!\n");
    }

    return false;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <maze file>\n", argv[0]);
        return 1;
    }

    Maze maze = {0};
    maze.player_row = -1;
    maze.player_col = -1;
    maze.exit_row = -1;
    maze.exit_col = -1;

    if (!load_from_file(&maze, argv[1])) {
        return 1;
    }

    if (!is_valid(&maze)) {
        return 1;
    }

    printf("The maze is loaded successfully! Use W/A/S/D to move, M to view the map, and Q to quit.\n");

    while (1) {
        char command[2];
        printf("Please enter a command: ");
        scanf("%1s", command);
        char lower_command = tolower(command[0]);

        if (lower_command == 'w' || lower_command == 'a' ||
            lower_command == 's' || lower_command == 'd') {
            if (move_player(&maze, lower_command)) {
                printf("Congratulations! You have reached the exit!\n");
                break;
            }
        } else if (lower_command == 'm') {
        } else if (lower_command == 'q') {
            printf("The game is exiting.\n");
            break;
        } else {
            printf("Invalid command. Please use W/A/S/D to move, M to view the map, and Q to quit.\n");
        }
    }

    return 0;
}