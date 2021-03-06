# 
#  photo.rb
#  smile
#  
#  Created by Zac Kleinpeter on 2009-04-28.
#  Copyright 2009 Cajun Country. All rights reserved.
# 
class Smile::Photo < Smile::Base
  
  class << self
    # Convert the given xml into photo objects to play with
    def from_xml( xml, session_id )
      hash = Hash.from_xml( xml )["rsp"]
      
      hash["images"]["image"].map do |image|
        image.merge!( :image_id => image["id"] )
        image.merge!( :album_key => image["album"]["key"] )
        image.merge!( :album_id => image["album"]["id"] )
        image.delete( 'album' )
      
        p = Smile::Photo.new( image )
        p.session_id = session_id
        p
      end
    end
    
    # This will pull a single image from the smugmug
    #
    # * int image_id
    # * String Password optional
    # * String SitePassword optional
    # * String ImageKey
    # 
    def find( options={} )
      set_session if( session_id.nil? )
      options = Smile::ParamConverter.clean_hash_keys( options )
      
      params = default_params.merge(
          :method => 'smugmug.images.getInfo'
      )
      
      params.merge!( options ) if( options )
      xml = RestClient.post Smile::Base::BASE, params
      image = Hash.from_xml( xml )["rsp"]["image"]
      
      image.merge!( :image_id => image["id"] )
      image.merge!( :album_key => image["album"]["key"] )
      image.merge!( :album_id => image["album"]["id"] )
      image.delete( 'album' )
      
      p = Smile::Photo.new( image )
      p.session_id = session_id
      p
    end
  end
  
  # This method will return camera and photograph details about the image specified by ImageID.
  # The Album must be owned by the Session holder, or else be Public (if password-protected, a
  # Password must be provided), to return results. Otherwise, an "invalid user" faultCode will
  # result. Additionally, the album owner must have specified that EXIF data is allowed. Note that
  # many photos have no EXIF data, so an empty or partially returned result is very normal.# 
  #
  # Arguments:* 
  # 
  # String Password optional
  # String SitePassword optional
  #
  # Result:* struct "Image" [some, none, or all may be returned]
  # 
  # int "id"
  # String "DateTime"
  # String "DateTimeOriginal"
  # String "DateTimeDigitized"
  # String "Make"
  # String "Model"
  # String "ExposureTime"
  # String "Aperture"
  # int "ISO"
  # String "FocalLength"
  # int "FocalLengthIn35mmFilm"
  # String "CCDWidth"
  # String "CompressedBitsPerPixel"
  # int "Flash"
  # int "Metering"
  # int "ExposureProgram"
  # String "ExposureBiasValue"
  # int "ExposureMode"
  # int "LightSource"
  # int "WhiteBalance"
  # String "DigitalZoomRatio"
  # int "Contrast"
  # int "Saturation"
  # int "Sharpness"
  # String "SubjectDistance"
  # int "SubjectDistanceRange"
  # int "SensingMethod"
  # String "ColorSpace"
  # String "Brightness"
  def details( options =nil )
    params = default_params.merge(
      :method => "smugmug.images.getEXIF",
      :ImageID => self.image_id,
      :ImageKey => self.key
    )
    
    params.merge!( options ) if( options )
    xml = RestClient.post Smile::Base::BASE, params
    
    rsp = Hash.from_xml( xml )["rsp"]
    raise rsp["message"] if rsp["stat"] == 'fail'
      
    image = Hash.from_xml( xml )["rsp"]["image"]
    image.merge!( :image_id => image["id"] )
    
    OpenStruct.new( image )
  end
  
  # This method will return details about the image specified by ImageID. The Album must be owned
  # by the Session holder, or else be Public (if password-protected, a Password must be provided),
  # to return results.. Otherwise, an "invalid user" faultCode will result. Additionally, some
  # fields are only returned to the Album owner.
  # 
  # Arguments:
  # 
  # String Password optional
  # String SitePassword optional
  #
  # Result:* struct "Image"
  # 
  # int "id"
  # String "Caption"
  # int "Position"
  # int "Serial"
  # int "Size"
  # int "Width"
  # int "Height"
  # String "LastUpdated"
  # String "FileName" owner only
  # String "MD5Sum" owner only
  # String "Watermark" owner only
  # Boolean "Hidden" owner only
  # String "Format"  owner only
  # String "Keywords" 
  # String "Date" owner only
  # String "AlbumURL"
  # String "TinyURL"
  # String "ThumbURL"
  # String "SmallURL"
  # String "MediumURL"
  # String "LargeURL" (if available)
  # String "XLargeURL" (if available)
  # String "X2LargeURL" (if available)
  # String "X3LargeURL" (if available)
  # String "OriginalURL" (if available)
  # struct "Album"
  # integer "id"
  # String "Key"
  def info( options =nil )
    params = default_params.merge(
      :method => "smugmug.images.getInfo",
      :ImageID => self.image_id,
      :ImageKey => self.key
    )
    
    params.merge!( options ) if( options )
    xml = RestClient.post Smile::Base::BASE, params
    
    rsp = Hash.from_xml( xml )["rsp"]
    raise rsp["message"] if rsp["stat"] == 'fail'
      
    image = Hash.from_xml( xml )["rsp"]["image"]
    image.merge!( :image_id => image["id"] )
    
    OpenStruct.new( image )  
  end
  
  # This method will return all the URLs for the various sizes of the image specified by
  # ImageID. The Album must be owned by the Session holder, or else be Public (if
  # password-protected, a Password must be provided), to return results. Otherwise, an "invalid
  # user" faultCode will result. Additionally, obvious restrictions on Originals and Larges
  # apply if so set by the owner. They will return as empty strings for those URLs if they're
  # unavailable.
  # 
  # Arguments:*
  # 
  # int TemplateID
  # optional, specifies which Style to build the AlbumURL with. Default: 3
  #   Possible values:
  #     Elegant: 3
  #     Traditional: 4
  #     All Thumbs: 7
  #     Slideshow: 8
  #     Journal: 9
  # String Password optional
  # String SitePassword optional
  #
  # Result:* struct
  # 
  # String "AlbumURL"
  # String "TinyURL"
  # String "ThumbURL"
  # String "SmallURL"
  # String "MediumURL"
  # String "LargeURL" (if available)
  # String "XLargeURL" (if available)
  # String "X2LargeURL" (if available)
  # String "X3LargeURL" (if available)
  # String "OriginalURL" (if available)
  def urls( options =nil )
    params = default_params.merge(
      :method => "smugmug.images.getURLs",
      :ImageID => self.image_id,
      :ImageKey => self.key
    )
    
    params.merge!( options ) if( options )
    xml = RestClient.post Smile::Base::BASE, params
    
    rsp = Hash.from_xml( xml )["rsp"]
    raise rsp["message"] if rsp["stat"] == 'fail'
    
    image = Hash.from_xml( xml )["rsp"]["image"]
    image.merge!( :image_id => image["id"] )
    
    OpenStruct.new( image )  
  end
  
  def album
    Smile::Album.find( :AlbumID => album_id, :AlbumKey => album_key )
  end
end