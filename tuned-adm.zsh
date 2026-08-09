#compdef tuned-adm

_tuned-adm()
{
    # local variables needed by _arguments
    local context state state_descr line
    typeset -A opt_args

    local -a subcmds=('list:list available profiles or plugins'
                      'active:show active profile'
                      'off:switch off all tunings'
                      'profile:switch to a given profile'
                      'profile_info:show information about given/current profile'
                      'recommend:recommend profile'
                      'verify:verify profile'
                      'auto_profile:enable automatic profile selection mode'
                      'profile_mode:show current profile selection mode'
                      'instance_acquire_devices:assign other instances'\'' devices to the given instance'
                      'get_instances:list active instances of a given plugin'
                      'instance_get_devices:list devices assigned to a given instance')
    local -a profiles=("${(f)$(find /usr/lib/tuned/profiles /etc/tuned/profiles -mindepth 1 -maxdepth 1 -type d -printf '%f\n')}")
    local -a loglevels=('debug' 'info' 'warn' 'error' 'console' 'none')

    # The first two arrays below are named differently so that they cannot be
    # completed by using 'global' or 'none' as a subcommand
    local -a global_args=('(- :)'{-h,--help}'[show help message and exit]')
    local -a none_args=('(-t --timeout)'{-t+,--timeout=}'[use timeout for sync operation (default 600s)]:timeout:()'
                        '(-l --loglevel)'{-l+,--loglevel=}'[level of log messages to capture]:log level:->loglevel'
                        '(-a --async)'{-a,--async}'[with dbus, don'\''t wait for completion and return immediately]'
                        '(-d --debug)'{-d,--debug}'[show debug messages]'
                        '(- :)'{-v,--version}'[show program'\''s version number and exit]'
                        '1:subcommand:->subcmd'
                        '*:args:->args')
    local -a args_list=('(-v --verbose)'{-v,--verbose}'[show plugin configuration parameters]'
                        '2:listmode:(plugins profiles)')
    local -a args_profile=('*:profile:->profile')
    local -a args_profile_info=('*:profile:->profile')
    local -a args_verify=('(-i --ignore-missing)'{-i,--ignore-missing}'[do not treat missing/unsupported tunings as errors]')
    local -a args_instance_acquire_devices=('2:devices'
                                            '3:instance')
    local -a args_get_instances=('2:plugin name')
    local -a args_instance_get_devices=('2:instance')

    _arguments -C -A '-*' -s -S "${none_args[@]}" "${global_args[@]}" && return 0

    case "$state" in
        (subcmd)
            _describe 'subcommand' subcmds
            return 0
            ;;
        (args)
            local name="args_${line[1]}"
            [[ "${#${(P)name}[@]}" -eq 0 ]] && return 1
            _arguments -s -S "${global_args[@]}" "${${(P)name}[@]}" && return 0
            ;;
    esac

    case "$state" in
        (profile) _values 'profile' "${profiles[@]}" ;;
        (loglevel) _values 'loglevel' "${loglevels[@]}" ;;
    esac

    return 0
}
