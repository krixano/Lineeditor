#include <stdio.h>
//#include <alloca.h>
#include <malloc.h>

#include "lineeditor.h"

State mainMenu(char *args, int *argsLength) {
    printf("Line Editor: Main Menu\n");
    printf("Copyright (c) Christian Seibold. All Rights Reserved.\n\n");
    
    /* Save - save new file */
    printf(" * 'n' - New File\n");
    /* Edit - rewrite a specific line, group of lines, group of characters in a line (given column numbers), and word/group of words */
    printf(" * 'o' - Open File\n");
    /* Quit */
    printf(" * 'Q' - Quit\n");
    
    /* Prompt */
    printf("\n: ");
    
    /* get first character - the menu item */
    char c;
    c = getchar();
    
    /* Store rest of line in rest */
    *argsLength = parsing_getLine(args, MAXLENGTH, TRUE);
    /*printf("Rest is: %s\n", rest);
 printf("RestLength is: %d", restLength);*/
    
    switch (c) {
        case 'n':
        {
            return NEW_FILE;
        } break;
        case 'o':
        {
            //printf("\nUnimplemented!\n");
            return OPEN_FILE;
        } break;
        case 'Q':
        {
            return QUIT;
        } break;
        default:
        printf("Unknown Command!");
    }
    
    return KEEP;
}

int main() {
    char args[MAXLENGTH] = { 0 };
    int argsLength = 0;
    int running = 1;
    State state = MAIN_MENU;
    State statePrev = state;
    
    while (running) {
        switch (state) {
            case MAIN_MENU:
            {
                state = mainMenu(args, &argsLength);
                if (state == KEEP) state = statePrev;
            } break;
            case NEW_FILE:
            {
                printf("\n");
                state = editorState(ED_NEW, args, argsLength);
                if (state == KEEP) state = statePrev;
            } break;
            case OPEN_FILE:
            {
                /*char *filename = alloca((argsLength + 1) * sizeof(char));
    //char filename[argsLength];
    int i, ii;
    
    while (args[i] != ' ' && args[i] != '\n' && args[i] != '\0')
    {
     filename[ii] = args[i];
     ++i;
     ++ii;
    }
    filename[ii] = '\0';
    
    printf("Opening %s\n", filename);*/
                //state = openFile(filename, ii + 1);
                state = editorState(ED_OPEN, args, argsLength);
                if (state == KEEP) state = statePrev;
                
                //free(filename);
                //filename = 0;
            } break;
            case QUIT:
            {
                running = FALSE;
                break;
            }
        }
        
        statePrev = state;
    }
    
    return(0);
}
