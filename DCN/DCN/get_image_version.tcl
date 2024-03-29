#**************************************************************************
# Identification:get_software_version.tcl
# Purpose:       get device software version
#**************************************************************************

sleep 1

send "show version\r"
set loop true
while {$loop == "true"} {
	expect {
		-re $more_prompt {
			send " "
		} -re "uthorization failed" {
			set ERROR_MESSAGE "The user is not authorized to use the command show version"
			set ERROR_RESULT true
			expect $enable_prompt
		} -re $enable_prompt {
			# Done
			set loop false
		}		
	}		
}	