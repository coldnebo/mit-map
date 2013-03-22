#!/usr/env/ruby

require 'nokogiri'
require 'open-uri'
require 'pry'


class MITCourse
  
  attr_accessor :name, :number, :prerequisites

  def self.get_courses(url)
    doc = Nokogiri::HTML(open(url))
    # this is because MIT's registrar doesn't believe in structured page HTML, so we have to 
    # serially parse the elements between h3's instead of using xpath to access them... thanks MIT.
    
    # ok, find the toplevel td containing all these h3's...
    container = doc.xpath('//h3[1]/..')

    courses = []
    current_course = nil
    current_prereq = nil
    
    # now iterate over the decendants...
    container.children.each do |element|
      case element.name
        when /h3/
          # push the previous course and make a new object...
          courses.push(current_course) unless current_course.nil?
          current_course = MITCourse.new()
          # grab the course number and name from the h3...
          element.inner_text.rstrip =~ /^([\d\.]+)\w* (.*)/
          current_course.name = $2
          current_course.number = $1
        when /br/
          # br acts as an EOR sentinel for the prereq field...
          unless current_course.nil? || current_prereq.nil?
            current_course.prerequisites = sanitize_prereqs(current_prereq)
            current_prereq = nil
          end
        when "a"
          unless current_course.nil? || current_prereq.nil? 
            # a's are sometimes interesting because they contain title info for our prereq...
            title = element.get_attribute("title")
            # push the inner text
            current_prereq.push(element.inner_text.strip) 
            # and the title if we got one
            current_prereq.push(title.strip) unless title.nil?
          end
        else
          # it's not an element, try to parse the text instead:
          text = element.inner_text.strip
          case text
            when /Prereq:/
              # create a new prereq object..
              current_prereq = []
              # and remove yourself from the text object
              text.gsub!(/Prereq:/,'')
          end
          # if we have started an active prereq block, then append everything else to the block.
          unless current_course.nil? || current_prereq.nil?
            text.gsub!(/Coreq:/,'')
            current_prereq.push(text)
          end
      end
    end
    courses
  end
  
  private
  
  def self.sanitize_prereqs(prereqs)
    # some of the prereqs have commas within them... normalize these to separate entries.
    text = prereqs.join(",")
    items = text.split(",").each {|i| i.strip!}
    items = items.select {|i| i =~ /\d+\.\d+/}
  end
  
end

def id(course)
  "c#{course.gsub(/\./,'_')}"
end

def color_map(num)
  case num
    when 0 then "000000"
    when 1 then "00008F" 
    when 2 then "008F8F" 
    when 3 then "008F00"
    when 4 then "8F8F00"
    else "8F0000"
  end
end

def generate_dot(courses)
  f = File.new("math.dot","w")
  f.puts "digraph mit_math {"
  f.puts "  graph[concentrate=true aspect=.25  rankdir=\"LR\"];"
  f.puts "  node[shape=rect];\n"
  courses.each do |course|
    unless course.number.nil? || course.name.empty?
      color = color_map(course.prerequisites.length)
      f.puts "  #{id(course.number)} [label=\"#{course.number}\\n#{course.name}\"];" 
      course.prerequisites.each do |prereq|
        f.puts "    #{id(prereq)} -> #{id(course.number)} [color=\"\##{color}\"] ;"
      end
    end
  end
  f.puts "}"
  f.close
end


pagea = MITCourse.get_courses('http://student.mit.edu/catalog/m18a.html')
pageb = MITCourse.get_courses('http://student.mit.edu/catalog/m18b.html')

all_math = pagea.concat(pageb)
pp pagea.select{|c| c.number =~ /18\.04/}
generate_dot(all_math)

%x{dot -Tpng math.dot -o math.png}

#binding.pry
