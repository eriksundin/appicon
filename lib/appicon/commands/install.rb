require 'json'
require 'shellwords'

command :'install' do |c|
  c.syntax = "appicon install [icon] [asset catalog]"
  c.summary = "Generate and install icons into an Xcode Asset Catalog."
  c.description = "Every specified format in you App Icon set will be generated and installed."

  c.action do |args, options|

    validate_image_magick!

    determine_icon! unless @icon = args[0]
    determine_asset_catalog! unless @asset_catalog = args[1]

    validate_icon!
    validate_asset_catalog!

    icon_sets = Dir.glob(File.join(@asset_catalog, '*.appiconset'))
    abort("Could not find any Icon sets (.appiconset folders) in the asset catalog. Create one first!") unless icon_sets.size > 0
    if icon_sets.size > 1
      @icon_set = determine_icon_set! icon_sets
    else
      @icon_set = icon_sets.first
    end

    @contents_file = File.join(@icon_set, 'Contents.json')
    contents = JSON.parse(File.read(@contents_file))
    contents['images'].each do |image|
      image_size = image['size']
      image_scale = image['scale']

      scaled_image_side = Integer(image_size.split('x').first.to_f * image_scale.sub('x', '').to_f)
      scaled_image_name = "Icon-#{image_size}-@#{image_scale}#{File.extname(@icon)}"
      scaled_image_output = File.join(@icon_set, scaled_image_name)

      # Generate each icon
      puts "Generating #{image_size} @ #{image_scale}."
      if system("convert #{@icon.shellescape} -resize #{scaled_image_side}x#{scaled_image_side} #{scaled_image_output.shellescape}")

        # Remove old icons that are not used any more
        previous_icon = image['filename']
        if previous_icon
          previous_icon_file = File.join(@icon_set, previous_icon)
          if File.exist?(previous_icon_file) and !scaled_image_name.eql?(previous_icon)
            FileUtils.rm(previous_icon_file)
          end
        end

        image['filename'] = scaled_image_name

      else
        say_error 'Failed during the conversion process for some reason...' and abort
      end
    end

    # Output the new JSON contents
    File.open(@contents_file,"w") do |f|
      f.write(JSON.pretty_generate(contents))
    end

    say_ok 'Done. Happy Days!'

  end

  private

  def validate_image_magick!
    abort('You need to install Image Magick! Check http://www.imagemagick.org for instructions.') unless system("which convert > /dev/null 2>&1")
  end

  def validate_icon!
    @icon = File.expand_path(@icon)
    abort("Ops! Can't find the source icon you specified. #{@icon}") unless File.exist?(@icon)
  end

  def validate_asset_catalog!
    @asset_catalog = File.expand_path(@asset_catalog)
    abort("Ops! Can't find the asset catalog you specified. #{@asset_catalog}") unless File.exist?(@asset_catalog)
    abort("Ops! It does not seem you specified a valid asset catalog.  It needs to be the .xcassets directory.") \
    unless File.directory?(@asset_catalog) and File.extname(@asset_catalog).eql?('.xcassets')
  end

  def determine_icon!
    @icon ||= ask "Source Icon:"
  end

  def determine_asset_catalog!
    @asset_catalog ||= ask "Asset Catalog:"
  end

  def determine_icon_set! icon_sets
    @icon_set ||= choose "Select Icon Set:", *icon_sets
  end


end
