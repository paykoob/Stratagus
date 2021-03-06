/*
    wargus.c - Start game engine Stratagus with Wargus data
    Copyright (C) 2010  Pali Rohár <pali.rohar@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#define GAMENAME "Wargus"
#define GAMECD "Warcraft II CD"
#define GAME "wargus"

#if defined (MAEMO_GTK) || defined (MAEMO_CHANGES)
#define MAEMO
#endif

#ifdef WIN32
#define WINVER 0x0501
#include <windows.h>
#include <wincon.h>
#include <process.h>
#include <errno.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef _MSC_VER
#include <sys/stat.h>
#include <sys/types.h>
#endif

#ifdef _MSC_VER
#include <direct.h>
#define inline __inline
#define chdir _chdir
#define getcwd _getcwd
#define spawnvp _spawnvp
#define stat _stat
#endif

#ifndef WIN32
#include <unistd.h>
#include <X11/Xlib.h>
#include <gtk/gtk.h>
#endif

#ifdef MAEMO
#include <hildon/hildon.h>
#endif

#ifdef _WIN64
#define REGKEY "Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Stratagus (64 bit)"
#elif defined (WIN32)
#define REGKEY "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Stratagus"
#endif

#if ! defined(WIN32) && ! defined(DATA_PATH)
#define DATA_PATH "/usr/share/games/stratagus/" GAME
#endif

#if ! defined(WIN32) && ! defined(STRATAGUS_BIN)
#define STRATAGUS_BIN "/usr/games/stratagus"
#endif

#define TITLE GAMENAME
#define STRATAGUS_NOT_FOUND "Stratagus is not installed.\nYou need Stratagus to run " GAMENAME "!\nFirst install Stratagus from https://launchpad.net/stratagus"
#define DATA_NOT_EXTRACTED GAMENAME " data was not extracted yet.\nYou need extract data from original " GAMECD " first!"
#define CONSOLE_MODE_NOT_ROOT "You must be root to run " GAMENAME " in console framebuffer mode"

#define BUFF_SIZE 1024

#ifndef WIN32
int ConsoleMode = 0;
#endif

inline void error(char * title, char * text) {

#ifdef WIN32
	MessageBox(NULL, text, title, MB_OK | MB_ICONERROR);
#endif

#ifdef MAEMO
	GtkWidget * dialog, * label;
	dialog = gtk_dialog_new_with_buttons(title, NULL, GTK_DIALOG_MODAL | GTK_DIALOG_DESTROY_WITH_PARENT, GTK_STOCK_OK, GTK_RESPONSE_ACCEPT, GTK_STOCK_CANCEL, GTK_RESPONSE_REJECT, NULL);
	label = gtk_label_new(text);

	gtk_container_add(GTK_CONTAINER (GTK_DIALOG(dialog)->vbox), label);
	gtk_widget_show_all(GTK_WIDGET (dialog));

	gtk_dialog_run(GTK_DIALOG (dialog));
	gtk_widget_destroy(dialog);
#endif

#if ! defined(WIN32) && ! defined(MAEMO)
	if ( ! ConsoleMode ) {

		GtkWidget * dialog;
		dialog = gtk_message_dialog_new(NULL, GTK_DIALOG_MODAL | GTK_DIALOG_DESTROY_WITH_PARENT, GTK_MESSAGE_ERROR, GTK_BUTTONS_OK, text, NULL);
		gtk_window_set_title(GTK_WINDOW(dialog), title);
		gtk_dialog_run(GTK_DIALOG (dialog));
		gtk_widget_destroy(dialog);

	} else
		fprintf(stderr, "%s -- Error: %s\n", title, text);
#endif

	exit(-1);

}

int main(int argc, char * argv[]) {

#ifndef WIN32
	if ( ! XOpenDisplay(NULL) )
		ConsoleMode = 1;
#endif

#ifdef MAEMO
	if ( ConsoleMode ) {

		fprintf(stderr, "Error: Cannot open X Display\n");
		return -1;

	}
#endif

#ifndef WIN32
	if ( ! ConsoleMode )
		gtk_init(&argc, &argv);
#endif

#ifdef MAEMO
	hildon_init();
#endif

	int i;
	struct stat st;
	char data_path[BUFF_SIZE];
	char stratagus_bin[BUFF_SIZE];
	char title_path[BUFF_SIZE];

#ifdef WIN32
	size_t data_path_size = sizeof(data_path);
	memset(data_path, 0, data_path_size);
	getcwd(data_path, data_path_size);

	char stratagus_path[BUFF_SIZE];
	DWORD stratagus_path_size = sizeof(stratagus_path);
	memset(stratagus_path, 0, stratagus_path_size);
	HKEY key;

	if ( RegOpenKeyEx(HKEY_LOCAL_MACHINE, REGKEY, 0, KEY_QUERY_VALUE, &key) == ERROR_SUCCESS ) {

		if ( RegQueryValueEx(key, "InstallLocation", NULL, NULL, (LPBYTE) stratagus_path, &stratagus_path_size) == ERROR_SUCCESS )
			if ( stratagus_path_size == 0 || strlen(stratagus_path) == 0 )
				error(TITLE, STRATAGUS_NOT_FOUND);

		RegCloseKey(key);

	}

	if ( chdir(stratagus_path) != 0 )
		error(TITLE, STRATAGUS_NOT_FOUND);

	sprintf(stratagus_bin, "%s\\stratagus.exe", stratagus_path);
#else
	strcpy(data_path, DATA_PATH);
	strcpy(stratagus_bin, STRATAGUS_BIN);
#endif

	if ( stat(stratagus_bin, &st) != 0 )
		error(TITLE, STRATAGUS_NOT_FOUND);

	if ( stat(data_path, &st) != 0 )
		error(TITLE, DATA_NOT_EXTRACTED);

#ifdef WIN32
	sprintf(title_path, "%s\\graphics\\ui\\title.png", data_path);

	int data_path_len = strlen(data_path);

	for ( i = data_path_len - 1; i >= 0; --i )
		data_path[i + 1] = data_path[i];

	data_path[0] = '"';
	data_path[data_path_len + 1] = '"';
	data_path[data_path_len + 2] = 0;
#else
	sprintf(title_path, "%s/graphics/ui/title.png", data_path);
#endif

	if ( stat(title_path, &st) != 0 )
		error(TITLE, DATA_NOT_EXTRACTED);

	char * stratagus_argv[argc + 3];

#ifdef WIN32
	char stratagus_argv0_esc[BUFF_SIZE];
	memset(stratagus_argv0_esc, 0, sizeof(stratagus_argv0_esc));
	strcpy(stratagus_argv0_esc + 1, argv[0]);
	stratagus_argv0_esc[0] = '"';
	stratagus_argv0_esc[strlen(argv[0]) + 1] = '"';
	stratagus_argv0_esc[strlen(argv[0]) + 2] = 0;
	stratagus_argv[0] = stratagus_argv0_esc;
#else
	stratagus_argv[0] = argv[0];
#endif

	stratagus_argv[1] = "-d";
	stratagus_argv[2] = data_path;

	for ( i = 3; i < argc + 2; ++i )
		stratagus_argv[i] = argv[i - 2];

	stratagus_argv[argc + 2] = NULL;

#ifndef WIN32
	if ( ConsoleMode && getuid() != 0 )
		error(TITLE, CONSOLE_MODE_NOT_ROOT);
#endif

#ifdef WIN32
	AttachConsole(ATTACH_PARENT_PROCESS);

	errno = 0;
	int ret = spawnvp(_P_WAIT, stratagus_bin, stratagus_argv);

	if ( errno == 0 )
		return ret;
#else
	execvp(stratagus_bin, stratagus_argv);
#endif

	error(TITLE, STRATAGUS_NOT_FOUND);
	return -1;

}
