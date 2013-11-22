class KmediaFileUpdateTask
require_relative '../../config/environment'

#updates kmedia file with it's file type

  def self.update
    @token = KmediaToken.get_token

     KmediaFile.find_each do |kmedia_file|
       response = RestClient.post "#{APP_CONFIG['kmedia_url']}/admin/api/api/files.json",
                                  auth_token: @token,
                                  ids: kmedia_file.kmedia_id,
                                  secure: '0'
       hash = JSON.parse response
       files = hash['item']
       file = files.first
       if(file.present?)
         puts kmedia_file.name
         kmedia_file.ext = file['type']
         kmedia_file.save
         puts kmedia_file.ext
       end
     end
  end

end