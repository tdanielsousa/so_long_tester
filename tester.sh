#!/bin/bash

DEF_COLOR='\033[0;39m'
RED='\033[1;91m'
GREEN='\033[1;92m'
GRAY='\033[0;90m'

C=1
FILE=$PWD/so_long
TEST=test_check.txt

if [ ! -f "$FILE" ]; then
    printf "${RED}SO LONG EXEC DOESNT EXIST ${DEF_COLOR}\n"
    exit 1
fi

rm -f traces.txt

check_args_count() {
    local desc="$1"
    shift
    local args=("$@")

    valgrind --leak-check=full --error-exitcode=1 ./so_long "${args[@]}" > /dev/null 2>&1
    LEAKS=$?
    if [ "$LEAKS" -eq 1 ]; then
        printf "${RED}$C.[MKO] LEAKS ${DEF_COLOR}"
    else
        printf "${GREEN}$C.[MOK]${DEF_COLOR}"
    fi

    ./so_long "${args[@]}" > "$TEST"
    local line1
    line1=$(head -n 1 "$TEST")

    local line2
    line2=$(sed -n '2p' "$TEST")

    if [ "$line1" = "Error" ]; then
        printf "${GREEN}[OK] ${DEF_COLOR}"
        if [ -n "$line2" ] && [ "${#line2}" -gt 1 ]; then
            printf "${GRAY}\nExpected output: ${DEF_COLOR} $desc\n"
            printf "${GRAY}Your output: ${DEF_COLOR} $line2\n"
        else
            printf "${RED}[KO] Missing explicit error message${DEF_COLOR}\n"
            printf "${GRAY}Expected output: ${DEF_COLOR} $desc\n"
        fi
    else
        printf "${RED}[KO] Expected output: Error${DEF_COLOR}\n"
    fi

    ((C++))
    rm -f "$TEST"
}

check_error_map() {
    local map_file="$1"
    local expected_output="$2"

    valgrind --leak-check=full --error-exitcode=1 ./so_long "$map_file" > /dev/null 2>&1
    LEAKS=$?
    if [ "$LEAKS" -eq 1 ]; then
        printf "${RED}$C.[MKO] LEAKS ${DEF_COLOR}"
    else
        printf "${GREEN}$C.[MOK]${DEF_COLOR}"
    fi

    ./so_long "$map_file" > "$TEST"
    local exit_code=$?
    local line1
    line1=$(head -n 1 "$TEST")

    local line2
    line2=$(sed -n '2p' "$TEST")

    if [ "$exit_code" -eq 139 ]; then
        printf "${RED}[KO] SEGFAULT${DEF_COLOR}\n"
    elif [ "$line1" = "Error" ]; then
        printf "${GREEN}[OK] ${DEF_COLOR}"
        if [ -n "$line2" ] && [ "${#line2}" -gt 1 ]; then
            printf "${GRAY}\nExpected output: ${DEF_COLOR} $expected_output\n"
            printf "${GRAY}Your output: ${DEF_COLOR} $line2\n"
        else
            printf "${RED}[KO] Missing explicit error message${DEF_COLOR}\n"
            printf "${GRAY}Expected output: ${DEF_COLOR} $expected_output\n"
        fi
    else
        printf "${RED}[KO] Expected output: Error${DEF_COLOR}\n"
    fi

    ((C++))
    rm -f "$TEST"
}


check_valid_map() {
    local map_file="$1"
    ./so_long "$map_file" & PID=$!
    sleep 0.35

    if ps -p "$PID" > /dev/null; then
        kill "$PID" > /dev/null 2>&1
        printf "${GREEN}$C.[OK] ${DEF_COLOR}\n"
    else
        printf "${RED}$C.[KO] ${DEF_COLOR}\n"
    fi

    ((C++))
}

# Tests identity to find errors
check_args_count "Wrong number of arguments"             # 1: No args
check_args_count "Wrong number of arguments" invent.ber more argv # 2

touch maps//permis.ber
chmod 000 maps//permis.ber
check_error_map "maps//permis.ber" "Permission denied" #3
rm -rf maps//permis.ber
check_error_map "invent.ber" "No exist map" #4
check_error_map "maps//badextension1.txt" "Bad extension" #5
check_error_map "maps//badextension2.ber.txt" "Bad extension" #6
check_error_map "maps//badextension3.bber" "Bad extension" #7
check_error_map "maps/.ber" "Bad extension" #8 Hidden file, not extension ber
check_error_map "maps//no_rectangular.ber" "No rectangular" #9
check_error_map "maps//no_rectangular1.ber" "No rectangular" #10
check_error_map "maps//no_rectangular2.ber" "No rectangular" #11
check_error_map "maps//no_rectangular3.ber" "No rectangular" #12
check_error_map "maps//no_rectangular4.ber" "No rectangular" #13
check_error_map "maps//no_rectangular5.ber" "No rectangular" #14
check_error_map "maps//no_rectangular6.ber" "No rectangular" #15
check_error_map "maps//no_rectangular7.ber" "No rectangular" #16
check_error_map "maps//no_rectangular8.ber" "No rectangular" #17
check_error_map "maps//no_rectangular9.ber" "No rectangular" #18
check_error_map "maps//no_player.ber" "No player" #19
check_error_map "maps//no_exit.ber" "No exit" #20
check_error_map "maps//no_object.ber" "No object" #21
check_error_map "maps//duplicate_player.ber" "Duplicate player" #22
check_error_map "maps//duplicate_exit.ber" "Duplicate exit" #23
check_error_map "maps//no_valid_road.ber" "Duplicate exit" #24
check_error_map "maps//no_valid_road1.ber" "Duplicate exit" #25
check_error_map "maps//no_valid_road2.ber" "Duplicate exit" #26
check_error_map "maps//no_valid_road3.ber" "Duplicate exit" #27
check_error_map "maps//no_valid_road4.ber" "Duplicate exit" #28
check_error_map "maps//no_valid_road5.ber" "Duplicate exit" #29
check_error_map "maps//no_valid_road6.ber" "Duplicate exit" #30
check_error_map "maps//no_valid_road7.ber" "Duplicate exit" #31
check_error_map "maps//no_valid_road8.ber" "Duplicate exit" #32
check_error_map "maps//no_valid_road9.ber" "Duplicate exit" #33
check_error_map "maps//no_valid_road10.ber" "Duplicate exit" #34
check_error_map "maps//no_walls.ber" "Not surrounded by walls" #35
check_error_map "maps//no_walls1.ber" "Not surrounded by walls" #36
check_error_map "maps//no_walls2.ber" "Not surrounded by walls" #37
check_error_map "maps//no_walls3.ber" "Not surrounded by walls" #38
check_error_map "maps//no_walls4.ber" "Not surrounded by walls" #39
check_error_map "maps//no_walls5.ber" "Not surrounded by walls" #40
check_error_map "maps//no_walls6.ber" "Not surrounded by walls" #41
check_error_map "maps//no_walls7.ber" "Not surrounded by walls" #42
check_error_map "maps//no_walls8.ber" "Not surrounded by walls" #43
check_error_map "maps//no_walls9.ber" "Not surrounded by walls" #44
check_error_map "maps//wrong_chars.ber" "Wrong characters" #45
check_error_map "maps//wrong_chars1.ber" "Wrong characters" #46
check_error_map "maps//wrong_chars2.ber" "Wrong characters" #47
check_error_map "maps//wrong_chars3.ber" "Wrong characters" #48
check_error_map "maps//wrong_chars4.ber" "Wrong characters" #49
check_error_map "maps//wrong_chars5.ber" "Wrong characters" #50
check_error_map "maps//no_valid_road11.ber" "Duplicate exit" #51
check_error_map "maps//no_valid_road12.ber" "Duplicate exit" #52
check_error_map "maps//no_valid_road13.ber" "Duplicate exit" #53
check_error_map "maps//no_valid_road14.ber" "Duplicate exit" #54
check_error_map "maps//no_valid_road15.ber" "Duplicate exit" #55

check_valid_map "maps/ok.ber" #56
check_valid_map "maps/ok1.ber" #57
check_valid_map "maps/ok2.ber" #58
check_valid_map "maps/ok3.ber" #59
check_valid_map "maps/ok4.ber" #60
check_valid_map "maps/ok5.ber" #61
check_valid_map "maps/ok6.ber" #62
check_valid_map "maps/ok7orok.ber" #63
check_valid_map "maps/ok8.ber" #64
check_valid_map "maps/ok9.ber" #65
check_valid_map "maps/ok10.ber" #66
check_valid_map "maps/ok11.ber" #67
check_valid_map "maps/ok12.ber" #68
check_valid_map "maps/ok13.ber" #69
check_valid_map "maps/ok14.ber" #70
check_valid_map "maps/ok15.ber" #71
