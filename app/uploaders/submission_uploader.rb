class SubmissionUploader < CarrierWave::Uploader::Base
    storage :file
    
    def store_dir
       "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
    
    def extension_whitelist
       %w(jpg jpeg png pdf doc docx)
    end

    def size_range
      0..5.megabytes
    end
 end
 