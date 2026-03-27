#!/bin/sh
# tp - a tiny template-expansion utility
#   Create a file from a template stored under $HOME/.template/<ext>/<name>
#   or simply dump the template to stdout.
#
#   Author: github@moenupa

# ----------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------
# Directory that holds the templates.  Can be overridden by the user.
# Example layout:
#   $HOME/.template/py/script        →  a Python script template
#   $HOME/.template/sh/rc           →  a shell rc file template
TEMPLATE_DIR=${TEMPLATE_DIR:-"$HOME/.template"}

# ----------------------------------------------------------------------
# Helper: print usage / help
# ----------------------------------------------------------------------
_template_help() {
	printf 'usage: tp [-w|--write] [-f|--force] [-v|--verbose] <ext>/<template>\n'
	printf '\n'
	printf 'Create a file or print a template stored under %s/<ext>/<template>\n' \
		   "$TEMPLATE_DIR"
	printf '\n'
	printf 'Examples:\n'
	printf '  tp py/script            # prints the template to stdout\n'
	printf '  tp -w py/script         # writes ./script.py (fails if it exists)\n'
	printf '  tp -w -f py/script      # overwrites ./script.py if present\n'
	printf '\n'
	printf 'Options:\n'
	printf '  -w, --write    Write to ./<template>.<ext>\n'
	printf '  -f, --force    Overwrite the destination if it already exists\n'
	printf '  -v, --verbose  Emit a short confirmation message on write\n'
	printf '  -h, --help     Show this help message\n'
	return 0
}

template() {
	# Default option values
	write_mode=0
	force_mode=0
	verbose=0

	while [ $# -gt 0 ]; do
		case "$1" in
			-w|--write)   write_mode=1; shift ;;
			-f|--force)   force_mode=1; shift ;;
			-v|--verbose) verbose=1;   shift ;;
			-h|--help)    _template_help; return 0 ;;
			--)           shift; break ;;            # end of options
			-*)           printf 'tp: unknown option %s\n' "$1" >&2
						 _template_help; return 1 ;;
			*)            break ;;                    # first non‑option argument
		esac
	done

	if [ $# -lt 1 ]; then
		printf 'tp: missing template spec\n' >&2
		_template_help
		return 1
	fi

	# Expected format: <ext>/<name>
	spec=$1
	case "$spec" in
		*/*) :;;                     # ok
		*)   printf 'tp: template must be <ext>/<name>\n' >&2
			  return 1 ;;
	esac

	ext=${spec%%/*}
	filename=${spec#*/}
	src="${TEMPLATE_DIR}/${ext}/${filename}"
	dest="./${filename}"   # the user may later rename it; we keep the original name

	if [ ! -f "$src" ]; then
		printf 'tp: template not found: %s\n' "$spec" >&2
		return 1
	fi

	if [ $write_mode -eq 1 ]; then
		if [ -e "$dest" ] && [ $force_mode -eq 0 ]; then
			printf 'tp: destination already exists: %s (use -f/--force to overwrite)\n' \
				   "$dest" >&2
			return 1
		fi
	fi

	if [ $write_mode -eq 1 ]; then
		if cp "$src" "$dest"; then
			[ $verbose -eq 1 ] && printf "'%s' <- '%s'.\n" "$dest" "$src"
			return 0
		else
			printf 'tp: failed to write %s\n' "$dest" >&2
			return 1
		fi
	else
		# Print the template to the user's terminal / pipe
		cat "$src"
		return 0
	fi
}

# If the file is executed directly, forward the arguments to the function.
# This makes the script usable both as a stand‑alone program and as a
# source‑able library.
if [ "${0##*/}" = "tp" ] || [ "${0##*/}" = "tp.sh" ]; then
	# When executed, we are not inside a function, so we just call it.
	template "$@"
	exit $?
fi
