
#**************************************************************************
# Identification:backup_startup_config_tftp
# Purpose:       backup startup configuration by tftp
#**************************************************************************


	set timeout $long_timeout
	set WARNING_RESULT true
	send "copy startup.cfg tftp://$TFTPServer/$TFTPFile\r"
    expect { 
		-re "onfirm copy file" {
			send "Y\r"
		} -re "no such host name" {
			set ERROR_MESSAGE "Could not copy the $startupConfig to a tftp server."
			set ERROR_RESULT true
			expect $enable_prompt
		} "uthorization failed" {
			set ERROR_MESSAGE "The user is not authorized to use the command copy $startupConfig tftp"
			set ERROR_RESULT true
			expect $enable_prompt
		} "\\?" {
            expect {
				"egin to send file, please wait" {
					expect $enable_prompt
				} "o route to TFTP serve" {
					set ERROR_MESSAGE "An error occurred with the TFTP server at address $TFTPServer"
					set ERROR_RESULT true
					expect $enable_prompt
				} "Error writing" {
					set ERROR_MESSAGE "An error occurred writing the TFTP file to the TFTP server at address $TFTPServer"
					set ERROR_RESULT true
					expect $enable_prompt
				} "\\?" {
					send "\r"
					expect "bytes copied"
					expect $enable_prompt
				} -re $enable_prompt {
				}
			}
		}
	}
	if { $ERROR_RESULT != "true" } {
		set WARNING_RESULT false
	}
	set timeout $standard_timeout
