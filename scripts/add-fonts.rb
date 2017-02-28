require 'xcodeproj'

# Lato-BoldItalic.ttf

projectPath = 'TextContour.xcodeproj'
project = Xcodeproj::Project.open(projectPath)
target = project.targets.first

textContourGroup = project.groups.first
fontGroup = textContourGroup.new_group('Fonts', 'Fonts')
refToAdd = fontGroup.new_reference('Google/Lato-BoldItalic.ttf')

target.add_resources([refToAdd])

project.save
