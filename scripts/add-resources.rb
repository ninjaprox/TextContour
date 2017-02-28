require 'xcodeproj'

projectPath = 'TextContour.xcodeproj'
project = Xcodeproj::Project.open(projectPath)
target = project.targets.first
textContourGroup = project.groups.first

# Add fonts
puts 'Adding font resources...'
fontRef = textContourGroup.new_reference('Fonts')
target.add_resources([fontRef])
puts 'Adding font resources... Done.'

# Add images
puts 'Adding image resources...'
imageRef = textContourGroup.new_reference('Images')
target.add_resources([imageRef])
puts 'Adding image resources... Done.'

project.save
