class FileController < ApplicationController
  def upload
    name = params['datafile'].original_filename
    directory="tmp/uploads"
    path=File.join(directory,name)
    File.open(path, "wb") { |f| f.write(params['datafile'].read) } 
    return
  end
end
