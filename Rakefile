require "fileutils"
require_relative "./rakelib/util"

task :build do
    sh "bundle config set --local with development"
    sh "bundle install"
end

task :build_prod do
    sh "bundle config set --local without development"
    sh "bundle install"
end

desc "Print project info"
task :info do
    info = project_info
    puts "Name: #{info.name}"
    puts "Version: #{info.version}"
end

desc "Run unit tests"
task :test do
    sh "bundle exec rspec spec --format Fuubar --color"
end

namespace :generate do
    task :config do
        arguments = read_argv
        target_name = arguments[0]

        if target_name.nil?
            puts "Missing target config name"
        else
            template_path = expand_project_path("config/config-template.json")
            target_path = expand_project_path("config/#{target_name}.json")
            FileUtils.cp(template_path, target_path)
        end
    end
end