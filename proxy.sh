# only can be exe in shell, not run.not run
export http_proxy="http://192.168.2.186:7890"
export https_proxy="http://192.168.2.186:7890"


# unset
unset http_proxy
unset https_proxy


#get current status
curl ipinfo.io
