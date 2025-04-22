#ifndef MY_HEADER_H
#define MY_HEADER_H

// Include standard libraries
#include <stdio.h>
#include <stdlib.h>

// Include project-specific headers
#include "cpu.h"
#include "udev.h"
#include "printer.h"
#include "args.h"
#include "global.h"
#include "ascii.h"

// Macro definitions
#define SUCCESS 0
#define FAILURE 1

// Function declarations for commonly used utility functions
void print_welcome_message();
void print_error_message(const char *message);

#endif // MY_HEADER_H
