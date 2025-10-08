# --- templating ---
alias tp=template
hash -d template=$HOME/.template

# tp: a create_w_template utility by github@moenupa
# Generate files according to a template, ~/.template/<ext>/<name> -> ./<name>.<ext>

template() {
	# parse options: -w/--write (write to file), -h/--help
	local write_mode=0
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-w | --write)
			write_mode=1
			shift
			;;
		-h | --help)
			_template_help
			return 0
			;;
		--)
			shift
			break
			;;
		-*)
			echo "tp: unknown option $1" >&2
			_template_help
			return 1
			;;
		*) break ;;
		esac
	done

	if [[ $# -lt 1 ]]; then
		echo "tp: missing template spec" >&2
		_template_help
		return 1
	fi

	local spec="$1"
	# expected format: <ext>/<filename>
	if [[ "$spec" != */* ]]; then
		echo "tp: template must be specified as <ext>/<name>" >&2
		return 1
	fi
	local ext="${spec%%/*}"
	local filename="${spec#*/}"

	# organize templates by file extension
	local src="$HOME/.template/$ext/$filename"
	local dest="./${filename}.${ext}"

	# edge cases
	if [[ ! -f "$src" ]]; then
		echo "tp: template not found: $spec" >&2
		return 1
	fi
	if ((write_mode)) && [[ -e "$dest" ]]; then
		echo "tp: destination exists: $dest" >&2
		return 1
	fi

	if ((write_mode)); then
		if cp "$src" "$dest"; then
			echo "'$dest' <- '$src'."
		else
			echo "tp: failed to write $dest" >&2
			return 1
		fi
	else
		cat "$src"
	fi
}
_template_help() {
	echo "usage: tp [-w | --write] <ext>/<template>"
	echo ""
	echo "Create a file or print a template stored under ~/.template/<ext>/<template>"
	echo ""
	echo "Examples:"
	echo "  tp py/script            # prints ~/.template/py/script to stdout"
	echo "  tp -w py/script         # writes ./script.py from ~/.template/py/script"
	echo ""
	echo "Options:"
	echo "  -w, --write    Write to ./<template>.<ext> (fails if exists)"
	echo "  -h, --help     Show this help message"
	return 0
}
_template_comp() {
	local dir="$HOME/.template"
	local -a templates
	if [[ -d "$dir" ]]; then
		local d f ext
		for d in "$dir"/*(/N); do
			ext="${d##*/}"
			for f in "$d"/*(N-.); do
				[[ -f "$f" ]] && templates+=("${ext}/${f##*/}")
			done
		done
	fi

	local -a values
	values=("${templates[@]}")
	_arguments -s \
		'(-w --write)'{-w,--write}'[write to file instead of stdout]' \
		'(-h --help)'{-h,--help}'[show help message]' \
		"1:template:($(printf '%s\n' "${values[@]}"))"
}
compdef _template_comp template
