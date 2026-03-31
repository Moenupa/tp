#!/bin/sh
# tp - a tiny template-expansion utility
#   Create a file from a template stored under $HOME/.template/<ext>/<name>
#   or simply dump the template to stdout.
#
#   Author: github@moenupa

# ----------------------------------------------------------------------
# Helper: print usage / help
# ----------------------------------------------------------------------
_template_help() {
	TEMPLATE_DIR=${TEMPLATE_DIR:-"$HOME/.template"}
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
	TEMPLATE_DIR=${TEMPLATE_DIR:-"$HOME/.template"}
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

	if [ $write_mode -eq 0 ]; then
		cat "$src"
		return 0
	fi

	if cp "$src" "$dest"; then
		[ $verbose -eq 1 ] && printf "'%s' <- '%s'.\n" "$dest" "$src"
		return 0
	else
		printf 'tp: failed to write %s\n' "$dest" >&2
		return 1
	fi
}

if [ -z "${BASH_SOURCE-}" ] && [ -z "${ZSH_EVAL_CONTEXT-}" ]; then
	template "$@"
	exit $?
fi
