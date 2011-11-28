#!/usr/bin/env ruby


# adding some cool magic I learned from merb :D
class String
  def /(other)
    File.join(self, other)
  end
end

bundles = {
  'Ruby'          => {:type => :git, :url => 'git://github.com/drnic/ruby-tmbundle.git'},
  'Ruby on Rails' => {:type => :git, :url => 'git://github.com/drnic/ruby-on-rails-tmbundle.git'},
  'git'           => {:type => :git, :url => 'git://github.com/jcf/git-tmbundle.git'},
  'RSpec'         => {:type => :git, :url => 'git://github.com/rspec/rspec-tmbundle.git'},
  'Ruby Haml'     => {:type => :git, :url => 'git://github.com/handcrafted/handcrafted-haml-textmate-bundle.git'},
  'Copy as RTF'   => {:type => :git, :url => 'git://github.com/drnic/copy-as-rtf-tmbundle.git'},
}


base_dir = ENV['HOME'] / "Library/Application Support/TextMate"

unless File.exist?(base_dir)
  puts "There is no TextMate directory: #{base_dir}"
  exit(1)
end

def update_svn(dir, url)
  if File.exist?(dir) && File.exist?(dir / '.svn')
    puts `cd "#{dir}" && svn up`
    true
  elsif !File.exist?(dir)
    puts `svn co "#{url}" "#{dir}"`
    true
  else
    nil
  end
end

def update_git(dir, url)
  if File.exist?(dir) && File.exist?(dir / '.git')
    puts `cd "#{dir}" && git pull`
    true
  elsif !File.exist?(dir)
    puts `git clone "#{url}" "#{dir}"`
    true
  else
    nil
  end
end

puts "Updating the Support folder."
unless update_svn(base_dir / 'Support', 'http://svn.textmate.org/trunk/Support')
  puts "You seem to have a Support directory not under Subversion source control."
  puts "Sorry, I can't deal with that."
end

require 'fileutils'
FileUtils.mkdir_p(base_dir/'Bundles')

bundles.each do |name, bundle|
  puts ""
  puts "Updating Bundle: #{name}"
  case bundle[:type]
  when :git, :svn
    unless send("update_#{bundle[:type]}", base_dir/'Bundles'/"#{name}.tmbundle", bundle[:url])
      puts "You seem to have a Bundle called #{name} already, but not under source control (#{bundle[:type]}).  Skipping."
    end
  else
    "Error with bundle #{name}, unkown type."
  end
end