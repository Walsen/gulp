#!/usr/bin/ruby -w

#################################################
### Gentoo Unmaintained Packages Lister v0.3 ####
###                                          ####
### Written by: Sergio D. Rodríguez Inclan   ####
### Web: http://zerox.net63.net              ####
### Email: srinclan@gmail.com                ####
### Licence: GPLv2.                          ####
###                                          ####
#################################################

require 'rexml/document'
include REXML

DISTFILES = "/usr/portage/"
root = Dir.entries(DISTFILES)
current = dir = nil
npkgs = 0

RESTRICTED = [ ".", "..", "header.txt", "skel.ChangeLog", "metadata", "skel.ebuild", "skel.metadata.xml", "metadata.xml", "manifest1_obsolete", ".cache", "packages", "distfiles", "eclass", "licenses", "profiles", "scripts" ]
f = File.new("unmaintained.txt", "w+")

puts "Start scanning the tree...."
root.each do |rpath| 
  if ! RESTRICTED.include?(rpath)
    current = DISTFILES + rpath + '/'
    dir = Dir.entries(current)
    dir.each do |arch|
      if ! RESTRICTED.include?(arch)
        metadata = current + arch + '/metadata.xml'
        file = File.new(metadata)
        doc = Document.new(file)  
        if doc.elements["pkgmetadata/herd"].to_a == ["no-herd"] && doc.elements["pkgmetadata/maintainer/email"].to_a == ["maintainer-needed@gentoo.org"]
          f.puts rpath + '/' + arch + '<br />'
          npkgs+=1
        end
      end
    end
  end
end
f.puts "Scanning complete, there are " + npkgs.to_s + " packages without maintainer in Gentoo, please visit http://bugs.gentoo.org and give them some love ;-)"
f.close
puts "Parsing complete, there are " + npkgs.to_s + " packages without maintainer in Gentoo, please open unmaintained.txt, visit http://bugs.gentoo.org and give them some love ;-)"
