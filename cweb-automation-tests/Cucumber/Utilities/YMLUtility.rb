require 'yaml'
require 'singleton'
require 'rubygems'

class YMLUtility
  def initialize(myfilename,mypath)
    if (mypath!="")
      fpath = "./test_data/%s/" %mypath
    else
      fpath = "./"
    end
    if myfilename !=""
      fname = fpath + "%s.yml" % myfilename
      fname=File.expand_path(fname)
      @hashconfig = YAML.load_file(fname)
    end
  end

  def readVariable(varname)
    return @hashconfig[varname]
  end

  def elements
    @hashconfig
  end
end

