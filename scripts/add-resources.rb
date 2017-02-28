require 'xcodeproj'

projectPath = 'TextContour.xcodeproj'
project = Xcodeproj::Project.open(projectPath)
target = project.targets.first
textContourGroup = project.groups.first

# Add fonts
puts 'Adding font resources...'
fontGroup = textContourGroup.new_group('Fonts', 'Fonts')
fontRefs = []
Dir.new('TextContour/Fonts').each do |file|
    fontRefs << fontGroup.new_reference(file) unless File.directory? file
end
target.add_resources(fontRefs)
puts 'Adding font resources... Done.'

# Add images
puts 'Adding image resources...'
imagesGroup = textContourGroup.new_group('Images', 'Images')
imageRefs = []
Dir.new('TextContour/Images').each do |file|
    imageRefs << imagesGroup.new_reference(file) unless File.directory? file
end
target.add_resources(imageRefs)
puts 'Adding image resources... Done.'

project.save
