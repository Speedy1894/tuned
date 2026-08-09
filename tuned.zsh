#compdef tuned

_tuned()
{
    # local variables needed by _arguments
    local context state state_descr line
    typeset -A opt_args

    local -a profiles=("${(f)$(find /usr/lib/tuned/profiles /etc/tuned/profiles -mindepth 1 -maxdepth 1 -type d -printf '%f\n')}")

    local -a global_args=('(-d --daemon)'{-d,--daemon}'[run in background]'
                          '(-D --debug)'{-D,--debug}'[show/log debugging messages]'
                          '(-l --log)'{-l,--log}'[use log file]::path:_files'
                          '(-P --pid)'{-P,--pid}'[use PID file]::path:_files'
                          '(-p --profile)'{-p+,--profile=}'[tuning profile to be activated]:profile:->profile'
                          '(- :)'{-h,--help}'[show help message and exit]'
                          '(- :)'{-v,--version}'[show program'\''s version number and exit]'
                          '--no-dbus[do not attach to Dbus]'
                          '--no-socket[do not attach to socket]')

    # The lack of a delimiter for path options is intentional -- if a filepath
    # is adjacent to an equals sign, then tilde expansion will not occur

    _arguments -s -S "${global_args[@]}" && return 0

    case "$state" in
        (profile) _values 'profile' "${profiles[@]}" ;;
    esac

    return 0
}
