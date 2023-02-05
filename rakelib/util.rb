ProjectInfo = Struct.new(:name, :version, :path)

def expand_project_path(path = nil)
    project_path = File.expand_path("#{__dir__}/..")
    project_path = "#{project_path}/#{path}" unless path.nil?
    project_path
end

def run_script(name, params = nil)
    path = expand_project_path("scripts/#{name}.sh")
    cmd = path.to_s

    if !params.nil? && !params.empty?
        param_string = ""
        params.each { |p| param_string += "#{p} " }
        cmd = "#{cmd} #{param_string}"
    end
    system cmd
end

def read_argv
    ARGV.each do |a|
        task a.to_sym do; end
    end
    ARGV.drop 1
end

def project_info
    lines = File.readlines(expand_project_path("description"))
    path = expand_project_path
    ProjectInfo.new(lines[0].strip, lines[1].strip, path)
end

PROJECT_INFO = project_info