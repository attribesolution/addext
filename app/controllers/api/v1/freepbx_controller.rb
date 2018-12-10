class Api::V1::FreepbxController < ApplicationController
    require 'uuidtools'
    require 'csv'

    before_action :authenticate_with_token
    before_action :set_csv_vars, :set_uuid, :set_cmd

    # this API is to run extension adding file run command 
    def create

        CSV.open("#{@path}#{@uuid}.csv", "wb") do |csv|
            csv << set_labels()

            wss_extension_set() # set wss extension
            set_extension_constructed_vars() # set wss's extension based variables accrodingly
            set_wss_options()   # set wss variables accrodingly

            csv << set_wss__udp_data()

            udp_extension_set() # set udp extension
            set_extension_constructed_vars() # set udp's extension based variables accrodingly
            set_udp_options() # set udp variables accrodingly
            
            csv << set_wss__udp_data()
        end

        puts set_cmd
        
        respond_to do |format|
            format.json { 
		    render :json => { executed: system( set_cmd ) }, status: 200 
            }
        end     

    end

    def update

        CSV.open("#{@path}#{@uuid}.csv", "wb") do |csv|
            csv << set_labels()

            wss_extension_set() # set wss extension
            set_extension_constructed_vars() # set wss's extension based variables accrodingly
            set_wss_options()   # set wss variables accrodingly

            csv << set_wss__udp_data()

            udp_extension_set() # set udp extension
            set_extension_constructed_vars() # set udp's extension based variables accrodingly
            set_udp_options() # set udp variables accrodingly
            
            csv << set_wss__udp_data()
        end

        puts set_cmd
        
        respond_to do |format|
            format.json { 
		    render :json => { executed: system( set_cmd ) }, status: 200 
            }
        end     
    end 

    private
        def authenticate_with_token
            render :json => {message: 'Unable to Authorize'}, status: 400 if !(request.headers['Authorization'] == ENV["API_AUTHORIZATION"])
        end

        def set_csv_vars
            # variables passed as params
            @name                        = params[:name] 
            @secret                      = params[:secret]

            # constructed
            @description                 = @name

            # constants
            @path                        = ENV["CSV_PATH_TO_SAVE"]
            @password                    = nil
            @voicemail                   = 'novm'
            @ringtimer                   = '0'
            @noanswer                    = nil
            @recording                   = nil
            @outboundcid                 = nil
            @sipname                     = nil
            @noanswer_cid                = nil
            @busy_cid                    = nil
            @chanunavail_cid             = nil
            @noanswer_dest               = nil
            @busy_dest                   = nil
            @chanunavail_dest            = nil
            @mohclass                    = 'default'
            @tech                        = 'sip'
            @devicetype                  = 'fixed'
            @emergency_cid               = nil
            @recording_in_external       = 'dontcare'
            @recording_out_external      = 'dontcare'
            @recording_in_internal       = 'dontcare'
            @recording_out_internal      = 'dontcare'
            @recording_ondemand          = 'disabled'
            @recording_priority          = '10'
            @answermode                  = nil
            @intercom                    = nil
            @concurrency_limit           = '3'
            @accountcode                 = nil
            @allow                       = nil
            @canreinvite                 = 'no'
            @context                     = 'from-internal'
            @defaultuser                 = nil
            @deny                        = '0.0.0.0/0.0.0.0'
            @disallow                    = nil
            @host                        = 'dynamic'
            @icesupport                  = 'yes'
            @namedcallgroup              = nil
            @namedpickupgroup            = nil
            @nat                         = 'no'
            @permit                      = '0.0.0.0/0.0.0.0'
            @port                        = '5060'
            @qualify                     = 'yes'
            @qualifyfreq                 = '60'
            @sendrpid                    = 'pai'
            @sessiontimers               = 'accept'
            @sipdriver                   = 'chan_sip'
            @trustrpid                   = 'yes'
            @type                        = 'friend'
            @videosupport                = 'inherit'
            @voicemail_enable            = nil
            @voicemail_vmpwd             = nil
            @voicemail_email             = nil
            @voicemail_pager             = nil
            @voicemail_options           = nil
            @voicemail_same_exten        = nil
            @disable_star_voicemail      = nil
            @vmx_unavail_enabled         = nil
            @vmx_busy_enabled            = nil
            @vmx_temp_enabled            = nil
            @vmx_play_instructions       = nil
            @vmx_option_0_number         = nil
            @vmx_option_1_number         = nil
            @vmx_option_2_number         = nil
        end
        
        def wss_extension_set
            @extension                   = params[:extension]
        end

        def udp_extension_set
            @extension                   = params[:extension] + '00000000'
        end

        def set_extension_constructed_vars()
            # constructed
            @id                          = @extension
            @user                        = @extension
	        @dial                        = 'SIP/' + @extension
            @callerid                    = @name + ' <' + @extension + '>'
            @cid_masquerade              = @extension
        end

        def set_wss_options()
            @avpf                        = 'yes'
            @dtmfmode                    = 'auto'
            @encryption                  = 'yes'
            @force_avp                   = 'yes'
            @rtcp_mux                    = 'yes'
            @transport                   = 'wss,udp,tcp,tls'
        end

        def set_udp_options()
            @avpf                        = 'no'
            @dtmfmode                    = 'rfc2833'
            @encryption                  = 'no'
            @force_avp                   = 'no'
            @rtcp_mux                    = 'no'
            @transport                   = 'udp,tcp,tls'
        end

        def set_wss__udp_data()
            wss__udp_data = [ 
                @extension, 
                @password, 
                @name, 
                @voicemail, 
                @ringtimer, 
                @noanswer, 
                @recording, 
                @outboundcid, 
                @sipname, 
                @noanswer_cid, 
                @busy_cid, 
                @chanunavail_cid, 
                @noanswer_dest, 
                @busy_dest, 
                @chanunavail_dest, 
                @mohclass, 
                @id, 
                @tech, 
                @dial, 
                @devicetype, 
                @user, 
                @description, 
                @emergency_cid, 
                @recording_in_external, 
                @recording_out_external, 
                @recording_in_internal, 
                @recording_out_internal, 
                @recording_ondemand, 
                @recording_priority, 
                @answermode, 
                @intercom, 
                @cid_masquerade, 
                @concurrency_limit, 
                @accountcode, 
                @allow, 
                @avpf, 
                @callerid, 
                @canreinvite, 
                @context, 
                @defaultuser, 
                @deny, 
                @disallow, 
                @dtmfmode, 
                @encryption, 
                @force_avp, 
                @host, 
                @icesupport, 
                @namedcallgroup, 
                @namedpickupgroup, 
                @nat, 
                @permit, 
                @port, 
                @qualify, 
                @qualifyfreq, 
                @rtcp_mux, 
                @secret, 
                @sendrpid, 
                @sessiontimers, 
                @sipdriver, 
                @transport, 
                @trustrpid, 
                @type, 
                @videosupport, 
                @voicemail_enable, 
                @voicemail_vmpwd, 
                @voicemail_email, 
                @voicemail_pager, 
                @voicemail_options, 
                @voicemail_same_exten, 
                @disable_star_voicemail, 
                @vmx_unavail_enabled, 
                @vmx_busy_enabled, 
                @vmx_temp_enabled, 
                @vmx_play_instructions, 
                @vmx_option_0_number, 
                @vmx_option_1_number, 
                @vmx_option_2_number
            ]

            return wss__udp_data
        end

        def set_labels()
            [
                "extension", 
                "password", 
                "name", 
                "voicemail", 
                "ringtimer", 
                "noanswer", 
                "recording", 
                "outboundcid", 
                "sipname", 
                "noanswer_cid", 
                "busy_cid", 
                "chanunavail_cid", 
                "noanswer_dest", 
                "busy_dest", 
                "chanunavail_dest", 
                "mohclass", 
                "id", 
                "tech", 
                "dial", 
                "devicetype", 
                "user", 
                "description", 
                "emergency_cid", 
                "recording_in_external", 
                "recording_out_external", 
                "recording_in_internal", 
                "recording_out_internal", 
                "recording_ondemand", 
                "recording_priority", 
                "answermode", 
                "intercom", 
                "cid_masquerade", 
                "concurrency_limit", 
                "accountcode", 
                "allow", 
                "avpf", 
                "callerid", 
                "canreinvite", 
                "context", 
                "defaultuser", 
                "deny", 
                "disallow", 
                "dtmfmode", 
                "encryption", 
                "force_avp", 
                "host", 
                "icesupport", 
                "namedcallgroup", 
                "namedpickupgroup", 
                "nat", 
                "permit", 
                "port", 
                "qualify", 
                "qualifyfreq", 
                "rtcp_mux", 
                "secret", 
                "sendrpid", 
                "sessiontimers", 
                "sipdriver", 
                "transport", 
                "trustrpid", 
                "type", 
                "videosupport", 
                "voicemail_enable", 
                "voicemail_vmpwd", 
                "voicemail_email", 
                "voicemail_pager", 
                "voicemail_options", 
                "voicemail_same_exten", 
                "disable_star_voicemail", 
                "vmx_unavail_enabled", 
                "vmx_busy_enabled", 
                "vmx_temp_enabled", 
                "vmx_play_instructions", 
                "vmx_option_0_number", 
                "vmx_option_1_number", 
                "vmx_option_2_number"
            ]
        end

        def set_uuid
            @uuid = UUIDTools::UUID.timestamp_create
        end

        def set_cmd
            return "/root/script/addextension.sh #{@path}#{@uuid}.csv #{params[:extension]}"
        end
end
