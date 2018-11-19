class Api::V1::FreepbxController < ApplicationController
    require 'uuidtools'
    require 'csv'

    before_action :authenticate_with_token
    before_action :set_csv_vars, :set_uuid, only: [:update]

    # this API is to run extension adding file run command 
    def create
        path        = params[:path]         # path of the file to be run
        file_name   = params[:file_name]    # file name of the file to be run
        dbhost      = params[:dbhost]       # databse hostname
        dbname      = params[:dbname]       # database name
        dbuser      = params[:dbuser]       # database username
        dbpass      = params[:dbpass]       # databse password
        extension   = params[:extension]    # extension to be added
        firstname   = params[:firstname]    # firstname of the extension
        lastname    = params[:lastname]     # lastname of the extension
        secret      = params[:secret]       # secret of the extension

        # command string to execute
        cmplt_cmd   =   "#{path}" + 
                        "#{file_name}"  + ' ' + 
                        "#{dbhost}"     + ' ' + 
                        "#{dbname}"     + ' ' + 
                        "#{dbuser}"     + ' ' + 
                        "#{dbpass}"     + ' ' + 
                        "#{extension}"  + ' ' + 
                        "#{firstname}"  + ' ' + 
                        "#{lastname}"   + ' ' + 
                        "#{secret}"  

        puts cmplt_cmd
        
        respond_to do |format|
            format.json { 
                render :json => system( cmplt_cmd ), status: 200 # complete file run command execution
            }
        end     
    end

    def update

        CSV.open("#{@path}#{@uuid}.csv", "wb") do |csv|
            csv << ["extension", "password", "name", "voicemail", "ringtimer", "noanswer", "recording", "outboundcid", "sipname", "noanswer_cid", "busy_cid", "chanunavail_cid", "noanswer_dest", "busy_dest", "chanunavail_dest", "mohclass", "id", "tech", "dial", "devicetype", "user", "description", "emergency_cid", "recording_in_external", "recording_out_external", "recording_in_internal", "recording_out_internal", "recording_ondemand", "recording_priority", "answermode", "intercom", "cid_masquerade", "concurrency_limit", "accountcode", "allow", "avpf", "callerid", "canreinvite", "context", "defaultuser", "deny", "disallow", "dtmfmode", "encryption", "force_avp", "host", "icesupport", "namedcallgroup", "namedpickupgroup", "nat", "permit", "port", "qualify", "qualifyfreq", "rtcp_mux", "secret", "sendrpid", "sessiontimers", "sipdriver", "transport", "trustrpid", "type", "videosupport", "voicemail_enable", "voicemail_vmpwd", "voicemail_email", "voicemail_pager", "voicemail_options", "voicemail_same_exten", "disable_star_voicemail", "vmx_unavail_enabled", "vmx_busy_enabled", "vmx_temp_enabled", "vmx_play_instructions", "vmx_option_0_number", "vmx_option_1_number", "vmx_option_2_number"]

            wss_or_udp_data = [ 
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

            csv << wss_or_udp_data

            wss_or_udp_data[35] = 'no'
            wss_or_udp_data[42] = 'rfc2833'
            wss_or_udp_data[43] = 'no'
            wss_or_udp_data[44] = 'no'
            wss_or_udp_data[54] = 'no'
            wss_or_udp_data[59] = 'udp,tcp,tls'

            csv << wss_or_udp_data
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
            @path                        = params[:path]
            @extension                   = params[:extension]
            @name                        = params[:name] 
            @secret                      = params[:secret]

            #constructed
            @id                          = @extension
            @user                        = @extension
            @description                 = @name
	    @dial                        = 'SIP/' + @extension
            @callerid                    = @name + ' <' + @extension + '>'
            @cid_masquerade              = @extension

            # constants
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
            @avpf                        = 'yes'
            @canreinvite                 = 'no'
            @context                     = 'from-internal'
            @defaultuser                 = nil
            @deny                        = '0.0.0.0/0.0.0.0'
            @disallow                    = nil
            @dtmfmode                    = 'auto'
            @encryption                  = 'yes'
            @force_avp                   = 'yes'
            @host                        = 'dynamic'
            @icesupport                  = 'yes'
            @namedcallgroup              = nil
            @namedpickupgroup            = nil
            @nat                         = 'no'
            @permit                      = '0.0.0.0/0.0.0.0'
            @port                        = '5060'
            @qualify                     = 'yes'
            @qualifyfreq                 = '60'
            @rtcp_mux                    = 'yes'
            @sendrpid                    = 'pai'
            @sessiontimers               = 'accept'
            @sipdriver                   = 'chan_sip'
            @transport                   = 'wss,udp,tcp,tls'
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
        
        def set_uuid
            @uuid = UUIDTools::UUID.timestamp_create
        end

        def set_cmd
            return "/root/script/addextension.sh #{@path}#{@uuid}.csv #{@extension}"
        end
end
