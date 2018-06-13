function getGitPagerCommand() {
  local _lessCommand='less --tabs=2 -RFX'
  local _isDiffSoFancyInstalled=$(findFirstInstalled diff-so-fancy)
  local _pagerCommand=''

  if [ "${_isDiffSoFancyInstalled}" ]; then
    _pagerCommand="diff-so-fancy | ${_lessCommand}"
  elif [ $PAGER = 'less' ]; then
    _pagerCommand="${_lessCommand}"
  else
    _pagerCommand="${PAGER}"
  fi

  echo "${_pagerCommand}"
  return 0
}
